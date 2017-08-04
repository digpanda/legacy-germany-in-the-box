namespace :bugfix do
  
  desc "different bugfixes"

  task fix_country: :environment do
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

  task fix_shop_currency_contact_person: :environment do
    Shop.all.each do |s|
      puts "fixing shop #{s.name}"

      s.currency = 'EUR'

      sa = ShopApplication.find_by(email: s.shopkeeper.email)

      if sa
        s.fname = sa.fname
        s.lname = sa.lname
        s.tel = sa.tel
        s.mobile = sa.mobile
        s.mail = sa.mail
        s.function = sa.function
        s.website = sa.website
      else
        s.fname = 'Y.'
        s.lname = 'L.'
        s.tel = '08912345678'
        s.mail = 'info@digpanda.com'
      end

      s.save!
    end
  end
end
