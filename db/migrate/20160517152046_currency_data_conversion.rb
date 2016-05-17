class CurrencyDataConversion < Mongoid::Migration
  
  def self.up
    Shop.all.each do |s|
      if s.currency.nil?
        puts "Fixing shop #{s.name} ; converting `nil` currency to `EUR`"
        s.currency = 'EUR'
        s.save!
      else
        puts "Nothing to do to shop #{s.name}"
      end
    end
  end

  def self.down
  end

end