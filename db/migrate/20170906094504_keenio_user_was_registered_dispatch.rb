class KeenioUserWasRegisteredDispatch < Mongoid::Migration
  def self.up
    User.where(role: :customer).all.each do |user|
      EventDispatcher.new.customer_was_registered(user).dispatch!
      puts "Dispatched User #{user.id}"
    end
  end

  def self.down
  end
end
