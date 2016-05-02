class ShopViewModel < ViewModels

  def wirecard_apply_merchant

    {
        
        # mandatory datas
        :form_url             => ::Rails.application.config.wirecard["merchants"]["signup"],
        :merchant_id          => self.id, # match reseller system
        :merchant_country     => ::Rails.application.config.wirecard["merchants"]["country"],
        :merchant_mcc         => '5499', # VISA MCC -> TODO : We should make it dynamic later on
        :package_id => ::Rails.application.config.wirecard["merchants"]["package_id"],
        :reseller_id => ::Rails.application.config.wirecard["merchants"]["reseller_id"],
        
        # optional datas
        :representative_first_name => self.shopkeeper.fname,
        :representative_last_name => self.shopkeeper.lname,
        :representative_address => '', # TODO : ASK SHA ABOUT THIS
        :representative_zip => '',
        :representative_phone => '',
        :representative_city => '',
        :representative_mobile => '',
        :representative_fax => '',
        
        :email => '',
        :company_name => self.shopname,
        :company_address => self.billing_address.street_and_number,
        :company_city => self.billing_address.city,
        :company_zip => self.billing_address.zip,
        :company_state => '', # self.billing_address.state,
        :company_url => self.website,
        :shop_url => '',
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

