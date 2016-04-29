# A dispatcher is the organisation that dispatches the
# merchandise. They can be identical to the shop owner,
# but do not need to be. Quite often a shop has an office
# address at one place, and warehouse/dispatch at
# another place.
class Dispatcher
  include Mongoid::Document

  embedded_in :shop
  embeds_one :address, as: :addressable

  def country
    address.country
  end
end
