namespace :bugfix do
  desc "TODO"

  task fix_country: :environment do
    Address.all.each do |a|
      if a.country == 'Deutschland'
        a.country = 'DE'
      elsif a.country == '中国'
        a.country == 'CN'
      end
   end

    Address.all.each(&:save)
  end
end
