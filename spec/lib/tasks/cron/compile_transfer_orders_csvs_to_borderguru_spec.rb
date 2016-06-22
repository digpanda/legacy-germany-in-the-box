require 'rake'

describe Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru do

  context "basic invokation of the rake task" do

    it "should be executed without error" do

      expect { Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru.new }.not_to raise_exception

    end

  end

  context "invokation with datas" do

    #let(:shopkeeper) { FactoryGirl.create(:shopkeeper) }
    let(:shop_with_custom_checking_orders) { FactoryGirl.create(:shop_with_custom_checking_orders) }

    it "should process 5 orders with status `custom_checking`" do

      shop_with_custom_checking_orders
      expect { Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru.new }.not_to raise_exception

    end
    
  end

end