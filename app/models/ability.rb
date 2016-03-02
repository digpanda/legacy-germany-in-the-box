class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role == :customer

      can [:show], Shop, :status => true

      can [:list_popular_products,
           :get_sku_for_options,
           :autocomplete_product_name,
           :search], Product

      can [:show], Product, :status => true

      can [:index,
           :search], User

      can [:show], User, :status => true

      can [:create,
           :edit,
           :update], User, :id => user.id

      can :manage, Order, :user => user

      can [:index,
           :search], Collection

      can [:show], Collection, :public => true

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
      can [:show,
           :update], Shop, :shopkeeper => user

      can [:list_popular_products,
           :get_sku_for_options,
           :autocomplete_product_name,
           :search], Product

      can [:show], Product, :status => true

      can [:remove_sku,
           :remove_option,
           :remove_variant,
           :create,
           :update,
           :destroy], Product, :shop => { :shopkeeper => user }

      can [:index,
           :search], User

      can [:show], User, :status => true

      can [:create,
           :edit,
           :update], User, :id => user.id

      can [:index,
           :search], Collection

      can [:show], Collection, :public => true

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

    elsif user.role == :admin
    end
  end
end
