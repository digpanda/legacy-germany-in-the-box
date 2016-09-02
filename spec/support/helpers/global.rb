module Helpers
  module Global

    module_function

    def login_admin
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:admin) # Using factory girl as an example
    end

    def login_customer(customer)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in customer
      #allow(controller).to receive(:current_user) { customer } 
      #allow(request.env['warden']).to receive(:authenticate!).and_return(customer)
    end

    def random_time
      rand * Time.now.utc.to_i
    end

    def random_date
      Time.at(random_time).strftime("%F")
    end

    def random_year
      Time.at(random_time).year
    end

    def next_number(symbol)
      User.where(:role => symbol).count + 1
    end

    def random_gender
      ['f', 'm'].sample
    end

  end
end