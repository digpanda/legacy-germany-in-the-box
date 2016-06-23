module Helpers
  module Global

    module_function

    def login_admin
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in FactoryGirl.create(:admin) # Using factory girl as an example
      end
    end

    def login_customer
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:customer)
    end

    def random_time
      rand * Time.now.to_i
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