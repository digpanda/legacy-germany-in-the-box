class FixAddresses < Mongoid::Migration
  def self.up
    Address.all.each do |a|

      puts "fixing address #{a.street} #{a.number}"

      if a.read_attribute(:country) == 'Deutschland'
        a.write_attribute(:country,'DE')
        a.write_attribute(:province, 'Bayern')
        a.write_attribute(:company, 'Unknown')
      elsif a.read_attribute(:country) == '中国'
        a.write_attribute(:country,'CN')
        a.write_attribute(:province, 'Unknown')
      end

      a.save!
   end
  end


  def self.down
  end
end