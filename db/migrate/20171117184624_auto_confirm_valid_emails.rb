class AutoConfirmValidEmails < Mongoid::Migration
  def self.up
    User.all.each do |user|
      if user.valid_email?
        puts "We will skip confirmation for User #{user.id} with email #{user.email} ..."
        user.skip_confirmation!
        user.save(validate: false)
      end
    end
  end

  def self.down
  end
end
