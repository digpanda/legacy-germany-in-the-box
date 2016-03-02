class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role == :customer
      can [:show], Shop

      can [:list_popular_products,
           :get_sku_for_options,
           :autocomplete_product_name,
           :search,
           :show], Product

      can [:add_product, :manage_cart, :set_address_payment, :checkout], Order
      can [:show, :index, :search, :edit, :update], User
      can :manage, Collection
      can :manage, Address
    elsif user.role == :shopkeeper
      can [:show, :update], Shop
      can [:list_popular_products], Product
      can [:show, :index, :search, :edit, :update], User
      can :manage, Collection
      can :manage, Address
    elsif user.role == :admin
    end
  end
end
