class GroupJuniorSeniorResellerToJuniorSenior < Mongoid::Migration
  def self.up

    User.all.each do |user|
      if user.group == :junior_reseller
        user.group = :junior
      elsif user.group == :senior_reseller
        user.group = :senior
      end
      puts "User `#{user.id}` is now `#{user.group}`"
      user.save(validate: false)
    end
  end

  def self.down
  end
end
