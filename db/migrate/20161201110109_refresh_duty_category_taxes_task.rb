class RefreshDutyCategoryTaxesTask < Mongoid::Migration
  def self.up
    # we just auto-launch the task
    Tasks::Digpanda::RefreshDutyCategoriesTaxes.new
  end

  def self.down
  end
end
