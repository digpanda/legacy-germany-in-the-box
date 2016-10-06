describe Api::Webhook::Wirecard::MerchantsController, :type => :controller do

  render_views # jbuilder requirement

  describe "#create" do

    context "server to server without authentication" do

      let(:shopkeeper) { FactoryGirl.create(:shopkeeper) }

      it "should throw a bad format error" do

        params = {"random" => true}
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:bad_request)
        expect(response_json_body["success"]).to eq(false) # Check if the server replied properly
        expect(response_json_body["code"]).to eq(1) # Error code from errors.yml

      end

      it "should throw a bad credentials error" do

        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "processing", "reseller_id": "bad-reseller-id"}
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:unauthorized)
        expect(response_json_body["success"]).to eq(false) # Check if the server replied properly
        expect(response_json_body["code"]).to eq(2) # Error code from errors.yml

      end

      it "should throw a bad merchant id error" do

        params = {"merchant_id" => "bad-merchant-id", "merchant_status": "processing", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id]}
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_json_body["success"]).to eq(false) # Check if the server replied properly
        expect(response_json_body["code"]).to eq(3) # Error code from errors.yml

      end

      it "should throw a validation error for bad wirecard status" do

        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "bad-merchant-status", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id]}
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:bad_request)
        expect(response_json_body["success"]).to eq(false) # Check if the server replied properly
        expect(response_json_body["code"]).to eq(4) # Error code from errors.yml

      end

      it "should change the merchant status and return a success" do

        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "processing", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id]}
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:ok)
        expect(response_json_body["success"]).to eq(true) # Check if the server replied properly
        shopkeeper.reload # database refreshed meanwhile
        expect(shopkeeper.shop.wirecard_status).to eq(:processing)

      end

      it "should change the merchant status as active, return a success" do

        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "ACTIVE", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id],
                  "wirecard_credentials" => {"ee_user_cc"=>"TEST-USER",
                                             "ee_password_cc"=>"TEST-PASSWORD",
                                             "ee_secret_cc"=>"TEST-SECRET",
                                             "ee_maid_cc"=>"TEST-MAID"}
                  }
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:ok)
        expect(response_json_body["success"]).to eq(true) # Check if the server replied properly
        shopkeeper.reload # database refreshed meanwhile
        expect(shopkeeper.shop.wirecard_status).to eq(:active)
        expect(shopkeeper.shop.payment_gateways.first.merchant_id).to eq("TEST-MAID")
        expect(shopkeeper.shop.payment_gateways.first.merchant_secret).to eq("TEST-SECRET")
        expect(shopkeeper.shop.payment_gateways.first.payment_method).to eq(:creditcard)

      end

      it "should throw an error with unrecognized payment method" do

        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "ACTIVE", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id],
                  "wirecard_credentials" => {"ee_user_wrong"=>"TEST-USER",
                                             "ee_password_wrong"=>"TEST-PASSWORD",
                                             "ee_secret_wrong"=>"TEST-SECRET-CREDITCARD",
                                             "ee_maid_wrong"=>"TEST-MAID-CREDITCARD"}
                  }


        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:bad_request)
        expect(response_json_body["success"]).to eq(false) # Check if the server replied properly
        expect(response_json_body["code"]).to eq(1) # Error code from errors.yml

      end

      it "should change the merchant status as active, fill its wirecard credentials for 3 different gateway, and update one of them" do

        # CREDIT CARD
        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "ACTIVE", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id],
                  "wirecard_credentials" => {"ee_user_cc"=>"TEST-USER",
                                             "ee_password_cc"=>"TEST-PASSWORD",
                                             "ee_secret_cc"=>"TEST-SECRET-CREDITCARD",
                                             "ee_maid_cc"=>"TEST-MAID-CREDITCARD"}
                  }

        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:ok)

        # UNION PAY
        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "ACTIVE", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id],
                  "wirecard_credentials" => {"ee_user_cup"=>"TEST-USER",
                                             "ee_password_cup"=>"TEST-PASSWORD",
                                             "ee_secret_cup"=>"TEST-SECRET-UPOP",
                                             "ee_maid_cup"=>"TEST-MAID-UPOP"}
                  }
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:ok)

        # PAYPAL
        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "ACTIVE", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id],
                  "wirecard_credentials" => {"ee_user_paypal"=>"TEST-USER",
                                             "ee_password_paypal"=>"TEST-PASSWORD",
                                             "ee_secret_paypal"=>"TEST-SECRET-PAYPAL",
                                             "ee_maid_paypal"=>"TEST-MAID-PAYPAL"}
                  }
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:ok)

        expect(response_json_body["success"]).to eq(true) # Check if the server replied properly
        shopkeeper.reload # database refreshed meanwhile
        expect(shopkeeper.shop.wirecard_status).to eq(:active)
        expect(shopkeeper.shop.payment_gateways.count).to eq(3)
        expect(shopkeeper.shop.payment_gateways.where(payment_method: :upop).first.merchant_secret).to eq("TEST-SECRET-UPOP")

        # UPDATE UNION PAY
        params = {"merchant_id" => "#{shopkeeper.shop.merchant_id}", "merchant_status": "ACTIVE", "reseller_id": Rails.application.config.wirecard[:merchants][:reseller_id],
                  "wirecard_credentials" => {"ee_user_cup"=>"TEST-USER",
                                             "ee_password_cup"=>"TEST-PASSWORD",
                                             "ee_secret_cup"=>"TEST-SECRET-UPOP2",
                                             "ee_maid_cup"=>"TEST-MAID-UPOP2"}
                  }
        post :create, request_wirecard_post(params)
        expect(response).to have_http_status(:ok)
        expect(shopkeeper.shop.payment_gateways.count).to eq(3)
        expect(shopkeeper.shop.payment_gateways.where(payment_method: :upop).first.merchant_secret).to eq("TEST-SECRET-UPOP2")

      end

    end

  end

end
