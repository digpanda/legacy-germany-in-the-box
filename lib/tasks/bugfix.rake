namespace :bugfix do
  desc "TODO"

  task fix_country: :environment do
    Address.all.each do |a|
      puts "fixing address #{a.street} #{a.number}"

      if a.country == 'Deutschland'
        a.country = 'DE'
      elsif a.country == '中国'
        a.country == 'CN'
      end

      a.save!
   end
  end

  task fix_shop_currency_contact_person: :environment do
    Shop.all.each do |s|
      puts "fixing shop #{s.name}"

      s.currency = 'EUR'

      sa = ShopApplication.find_by(:email => s.shopkeeper.email)

      if sa
        s.fname = sa.fname
        s.lname = sa.lname
        s.tel = sa.tel
        s.mobile = sa.mobile
        s.mail = sa.mail
        s.function = sa.function
        s.website = sa.website
      end

      s.save!
    end
  end
end
