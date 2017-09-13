# the site logic can cause some carts to be orphans and to actually persist in the database
# this can happen in various scenario which we should work on to limitate.
# as a supplementary protection, we made a cron job to ensure the database is not filled with them.
class Tasks::Cron::RemoveEmptyCarts
  attr_reader :carts

  def initialize
    @carts = Cart.all
  end

  def perform
    puts 'We will check all the Carts for emptiness ...'
    carts.each do |cart|
      if cart.orders.count == 0
        puts "We will remove the Cart #{cart.id} because it is without any order."
        cart.delete
      end
    end
    puts 'End of process.'
  end

end
