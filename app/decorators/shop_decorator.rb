class ShopDecorator < Draper::Decorator

  delegate_all

  def wirecard_apply_merchant

    billing_address = object.billing_address.decorate
    shopkeeper = object.shopkeeper

    {
        
        # mandatory datas
        :form_url             => ::Rails.application.config.wirecard["merchants"]["signup"],
        :merchant_id          => object.id, # match reseller system
        :merchant_country     => ::Rails.application.config.wirecard["merchants"]["country"],
        :merchant_mcc         => '5499', # VISA MCC -> TODO : We should make it dynamic later on
        :package_id => ::Rails.application.config.wirecard["merchants"]["package_id"],
        :reseller_id => ::Rails.application.config.wirecard["merchants"]["reseller_id"],
        
        # optional datas
        :representative_first_name => shopkeeper.fname,
        :representative_last_name => shopkeeper.lname,
        :representative_address => '', # TODO : ASK SHA ABOUT THIS
        :representative_zip => '',
        :representative_phone => '',
        :representative_city => '',
        :representative_mobile => '',
        :representative_fax => '',
        
        :email => '',
        :company_name => object.shopname,
        :company_address => billing_address.decorate.street_and_number,
        :company_city => billing_address.city,
        :company_zip => billing_address.zip,
        :company_state => '', # object.billing_address.state,
        :company_url => object.website,
        :object_url => '',
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

