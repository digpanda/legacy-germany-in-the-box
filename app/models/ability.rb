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

      can [:show,
           :index,
           :search], User

      can [:create,
           :edit,
           :update], User, :id => user.id

      can :manage, Order, :user => user

      can [:show,
           :index,
           :search], Collection, :public => true

      can [:create_and_add,
           :toggle_product,
           :is_collected,
           :add_product,
           :remove_product,
           :remove_products,
           :remove_all_products,
           :create,
           :update,
           :destroy,
           :show_liked_by_me,
           :like_collection,
           :dislike_collection], Collection, :user => user

      can :manage, Address, :user => user

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
