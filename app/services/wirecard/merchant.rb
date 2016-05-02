module Wirecard
  class Merchant

    attr_reader :shop

    def initialize(shop)
      @shop = shop
    end

    def apply_partnership_datas

      billing_address = shop.billing_address.decorate
      shopkeeper = shop.shopkeeper

      {

        # mandatory datas
        :form_url             => ::Rails.application.config.wirecard["merchants"]["signup"],
        :merchant_id          => shop.id, # match reseller system
        :merchant_country     => ::Rails.application.config.wirecard["merchants"]["country"],
        :merchant_mcc         => '5499', # VISA MCC -> TODO : We should make it dynamic later on
        :package_id => ::Rails.application.config.wirecard["merchants"]["package_id"],
        :reseller_id => ::Rails.application.config.wirecard["merchants"]["reseller_id"],

        # optional datas
        :representative_first_name => shopkeeper.fname,
        :representative_last_name => shopkeeper.lname,
        :representative_address => '',
        :representative_zip => '',
        :representative_phone => '',
        :representative_city => '',
        :representative_mobile => '',
        :representative_fax => '',

        :email => shopkeeper.email,
        :company_name => shop.shopname,
        :company_address => billing_address.street_and_number,
        :company_city => billing_address.city,
        :company_zip => billing_address.zip,
        :company_state => '', # shop.billing_address.state,
        :company_url => shop.website,
        :user_url => '',
        :vat_number => '',
        :bank_name => '',
        :bank_city => '',
        :bank_iban => '',
        :bank_swift => '',
        :bank_code => '',
        :bank_account_number => '',
        :bank_owner => '',


      }

    end

  end
end