class CountryDataConversion < Mongoid::Migration
  
  def self.up
      # C/C FROM RAKE TASK `bugfix`
      puts "fixing address #{a.street} #{a.number}"
      if a.read_attribute(:country) == 'Deutschland'
        a.write_attribute(:country,'DE')
      elsif a.read_attribute(:country) == '中国'
        a.write_attribute(:country,'CN')
      end
      a.save!
  end

  def self.down
  end

end