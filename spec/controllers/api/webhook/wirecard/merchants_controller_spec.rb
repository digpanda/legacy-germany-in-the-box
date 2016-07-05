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

      it "should change the merchant status as active, fill its wirecard credentials and return a success" do

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
        expect(shopkeeper.shop.wirecard_ee_user_cc).to eq("TEST-USER")
        expect(shopkeeper.shop.wirecard_ee_password_cc).to eq("TEST-PASSWORD")
        expect(shopkeeper.shop.wirecard_ee_secret_cc).to eq("TEST-SECRET")
        expect(shopkeeper.shop.wirecard_ee_maid_cc).to eq("TEST-MAID")

      end

    end

  end

end