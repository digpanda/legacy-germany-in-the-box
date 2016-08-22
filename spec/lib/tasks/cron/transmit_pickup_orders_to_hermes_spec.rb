require 'rake'

describe Tasks::Cron::TransmitPickupOrdersToHermes do

  context "basic invokation of the rake task" do

    it "should be executed without error" do

      expect { Tasks::Cron::TransmitPickupOrdersToHermes.new.perform }.not_to raise_exception

    end

  end

  context "invokation with datas" do

    it "should process 5 orders with status `custom_checking`" do

      create(:shop, :with_custom_checkable_orders)
      expect { Tasks::Cron::TransmitPickupOrdersToHermes.new.perform }.not_to raise_exception

    end
    
  end

end