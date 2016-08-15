class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user, controller_namespace)

    namespaces = controller_namespace.split('::')

    # Currently there's no `app` so it's extremely difficult to differentiate the Api from the App
    # Best is to avoid this differentiation until we have a strict organization of the folders and namespaces
    # It will come progressively.
    # - Laurent, 2016/06/21
    #service = namespaces.shift
    namespaces.shift if namespaces.first == "Api"
    authorization = namespaces.shift

    # Namespaced authorization
    case authorization

      when 'Guest' # Anyone
        can :manage, :all

      when 'Webhook' # Any server (API inter-communication) -> no difference from user so far, but the system is ready.
        can :manage, :all

      when 'Customer' # Customer only
        can :manage, :all if user&.role == :customer

      when 'Shopkeeper' # Shopkeeper only
        can :manage, :all if user&.role == :shopkeeper

      when 'Admin' # Admin only
        can :manage, :all if user&.role == :admin

      when 'Shared' # If the user is logged-in in any type of account
        can :manage, :all if user != nil

    end

    # End of namespaced authorization

    #
    # WARNING :
    # THIS BELOW WILL BE REMOVED AT SOME POINT, DON'T GET HEADACHE FROM IT, IT WILL BE BETTER SECURED AFTER.
    # - Laurent, 2016/06/21
    #
    #
    user ||= User.new # THIS SHOULD DISAPPEAR, BUT WE NEED IT FOR GUESTS RIGHT NOW

    if user.role == :customer

      can [:show], Shop, :status => true

      can [:popular,
           :get_sku_for_options,
           :autocomplete_product_name,
           :search], Product

      can [:show,
           :like], Product, :status => true

      can [:unlike,
        ], Product

      can [:skus], Product

      can [:show,
           :show_products,
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
           :favorites,
           :edit_personal,
           :edit_bank, :show_addresses, :set_address], User, :id => user.id

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
           :unlike_collection,
           :show_collections], Collection, :user => user

      can [:like_collection,
           :unlike_collection], Collection

      can :manage, Address, :user => user

    elsif user.role == :shopkeeper

      can [:show,
           :update,
           :edit_setting,
           :edit_producer,
           :destroy_image,
           :show_products,
           :apply_wirecard], Shop, :shopkeeper => user

      can [:popular,
           :get_sku_for_options,
           :autocomplete_product_name,
           :search], Product

      can [:show,
           :like], Product, :status => true

      can [:unlike], Product

      can [:remove_sku,
           :remove_option,
           :remove_variant,
           :update,
           :destroy,
           :show_products,
           :edit_product,
           :show_skus,
           :show_likes,
           :edit_sku,
           :clone_sku], Product, :shop => { :shopkeeper => user }

      can [:new,
           :create,
           :new_sku], Product

      can [:show_products,
           :list_products], Category

      can [:index,
           :search,
           :favorites,
           :show_addresses,
           :unfollow], User

      can [:show,
           :follow,
           :get_followers,
           :get_following,
           :edit_account,
           :edit_personal], User, :status => true

      can [:create,
           :update], User, :id => user.id

      can :manage, Order, :shop => user.shop

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
           :unlike_collection], Collection

      can :manage, Address, :shop => user.shop

    elsif user.role == :admin
      can :manage, :all
    end
  end
end
