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

      can [:show,
           :like_product], Product, :status => true

      can [:dislike_product], Product

      can [:show_products,
           :list_products], Category

      can [:index,
           :search,
           :unfollow], User

      can [:show,
           :follow,
           :get_followers,
           :get_following], User, :status => true

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
           :show_my_collections,
           :dislike_collection], Collection, :user => user

      can [:like_collection,
           :dislike_collection], Collection

      can [:create,
           :index,
           :update,
           :destroy], Address, :user => user

    elsif user.role == :shopkeeper
      can [:show,
           :update], Shop, :shopkeeper => user

      can [:list_popular_products,
           :get_sku_for_options,
           :autocomplete_product_name,
           :search], Product

      can [:show,
           :like_product], Product, :status => true

      can [:dislike_product], Product

      can [:remove_sku,
           :remove_option,
           :remove_variant,
           :update,
           :destroy], Product, :shop => { :shopkeeper => user }

      can [:create], Product

      can [:show_products,
           :list_products], Category

      can [:index,
           :search,
           :unfollow], User

      can [:show,
           :follow,
           :get_followers,
           :get_following], User, :status => true

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
           :show_my_collections], Collection, :user => user

      can [:like_collection,
           :dislike_collection], Collection

      can :manage, Address, :shop => user.shop

    elsif user.role == :admin
      can :manage, :all
    end
  end
end
