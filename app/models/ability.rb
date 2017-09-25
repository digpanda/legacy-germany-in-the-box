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
    namespaces.shift if namespaces.first == 'Api'
    authorization = namespaces.shift

    # namespaced authorization
    if user

      case authorization

        # anyone
      when 'Guest'
        can :manage, :all

        # any server (API inter-communication)
        # NOTE : no difference from user so far, but the system is ready.
      when 'Webhook'
        can :manage, :all

        # customer section
      when 'Customer'
        can :manage, :all if user.customer?

        # shopkeeper section
      when 'Shopkeeper'
        can :manage, :all if user.shopkeeper?

        # admin section
      when 'Admin'
        can :manage, :all if user.admin?

        # if the user is logged-in in any type of account
      when 'Shared'
        can :manage, :all if user

      end

    end
    # end of namespaced authorization
  end
end
