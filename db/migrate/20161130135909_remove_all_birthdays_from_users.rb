class RemoveAllBirthdaysFromUsers < Mongoid::Migration
  def self.up
    # we must remove all the birthdays from users
    # because it was corrupted from the wechat auto-login
    User.all.each do |user|
      user.birth = nil
      user.save
    end
  end

  def self.down
  end
end
