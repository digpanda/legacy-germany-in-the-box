class KeenioUserWasRegisteredDispatchBis < Mongoid::Migration
  def self.up
    EventDispatcher.new.activate!
    User.where(role: :customer).all.each do |user|
      callback = EventDispatcher.new.customer_was_registered(user).dispatch!
      puts "Dispatched User #{user.id} (callback: `#{callback}`)"
    end
  end

  def self.down
  end
end
