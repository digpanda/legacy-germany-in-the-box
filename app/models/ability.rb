class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.role == :customer

      can [:show], Shop, :status => true

      can [:popular,
           :get_sku_for_options,
           :autocomplete_product_name,
           :search], Product

      can [:show,
           :like], Product, :status => true

      can [:dislike], Product

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
           :update,
           :edit_account,
           :edit_personal,
           :edit_bank], User, :id => user.id

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
           :dislike_collection,
           :show_collections], Collection, :user => user

      can [:like_collection,
           :dislike_collection], Collection

      can :manage, Address, :user => user

    elsif user.role == :shopkeeper
      can [:show,
           :update,
           :edit_setting,
           :edit_producer,
           :show_products], Shop, :shopkeeper => user

      can [:popular,
           :get_sku_for_options,
           :autocomplete_product_name,
           :search], Product

      can [:show,
           :like], Product, :status => true

      can [:dislike], Product

      can [:remove_sku,
           :remove_option,
           :remove_variant,
           :update,
           :destroy,
           :show_products,
           :edit_product,
           :show_skus,
           :edit_sku,
           :clone_sku], Product, :shop => { :shopkeeper => user }

      can [:new,
           :create,
           :new_sku], Product

      can [:show_products,
           :list_products], Category

      can [:index,
           :search,
           :unfollow], User

      can [:show,
           :follow,
           :get_followers,
           :get_following,
           :edit_account,
           :edit_personal], User, :status => true

      can [:create,
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
