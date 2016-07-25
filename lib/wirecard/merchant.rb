module Wirecard
  class Merchant < Base

    CONFIG = BASE_CONFIG[:merchants]

    include Rails.application.routes.url_helpers

    attr_reader :shop,
                :shopkeeper,
                :billing_address

    def initialize(shop)
      @shop = shop
      @shopkeeper = shop.shopkeeper
      @billing_address = shop.billing_address.decorate
    end

    def apply_partnership_datas
      mandatory_datas.merge(optional_datas)
    end

    private

    def mandatory_datas
      {
        :form_url         => CONFIG[:signup],
        :merchant_id      => shop.merchant_id, # match reseller system
        :merchant_country => CONFIG[:country],
        :merchant_mcc     => '5499', # VISA MCC : 5499
        :package_id       => CONFIG[:package_id],
        :reseller_id      => CONFIG[:reseller_id]
      }
    end

    def optional_datas
      {
        :representative_first_name => shop.fname,
        :representative_last_name  => shop.lname,
        :representative_address    => shopkeeper_address.street_and_number,
        :representative_zip        => shopkeeper_address.zip,
        :representative_city       => shopkeeper_address.city,
        :representative_mobile     => shop.mobile,
        :representative_phone      => shop.tel,
        :representative_fax        => '',
        
        :email               => shop.mail,
        :company_name        => shop.shopname,
        :company_address     => billing_address.street_and_number,
        :company_city        => billing_address.city,
        :company_zip         => billing_address.zip,
        :company_state       => billing_address.province,
        :company_url         => shop.website,
        :shop_url            => shop_url(shop),
        :user_url            => '',
        :vat_number          => '',
        :bank_name           => '',
        :bank_city           => '',
        :bank_iban           => '',
        :bank_swift          => '',
        :bank_code           => '',
        :bank_account_number => '',
        :bank_owner          => '',
      }
    end

    def shopkeeper_address
      shopkeeper.addresses.first&.decorate || billing_address
    end

  end
end