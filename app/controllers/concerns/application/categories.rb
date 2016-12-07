module Application
  module Categories
    extend ActiveSupport::Concern

    include UsersHelper

    included do
      before_action :set_categories
    end

    def set_categories
      if potential_customer?
        @categories = Category.order(position: :asc).all
      end
    end

  end
end
