class Notifier

  private

  # call the dispatcher more simply
  # this method solely used into the subclasses
  # such as Admin, Shopkeeper, Customer
  def dispatch(*args)
    Dispatcher.new({user: user}.merge(*args))
  end

end
