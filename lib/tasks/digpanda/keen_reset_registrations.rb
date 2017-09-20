class Tasks::Digpanda::KeenResetRegistrations
  def initialize
    agregate_registrations!
  end

  private

    def agregate_registrations!
      User.where(role: :customer).all.each do |user|
        callback = EventDispatcher.new.customer_was_registered(user).dispatch!
        puts "Dispatched User #{user.id} (callback: `#{callback}`)"
      end
    end
end
