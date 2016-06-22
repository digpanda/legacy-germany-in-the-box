require 'rake'

describe Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru do

  context "basic invokation of the rake task" do


    it "should be executed without error" do

      expect { Tasks::Cron::CompileAndTransferOrdersCsvsToBorderguru.new }.not_to raise_exception

    end
  end

end