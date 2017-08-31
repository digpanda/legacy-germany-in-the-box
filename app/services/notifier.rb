require "notifier/customer"
require "notifier/shopkeeper"
require "notifier/admin"
require "notifier/dispatcher"

class Notifier

  private

  # call the dispatcher more simply
  # this method solely used into the subclasses
  # such as Admin, Shopkeeper, Customer
  def dispatch(*args)
    Dispatcher.new({user: user, unique_id: unique_id}.merge(*args))
  end

end
