class UserBirthToTime < Mongoid::Migration
  def self.up
    User.all.each do |user|
      birth = user.attributes['birth']
      if birth.present?
        user.birth = DateTime.parse(birth)
        user.save!(validate: false)
        puts "Birth #{birth} converted to #{user.birth}"
      end
    end
  end

  def self.down
  end
end
