class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home, :privacy, :imprint, :saleguide, :fees, :menu]

  def home
    @categories = Category.all

    EmitNotificationAndDispatchToUser.perform({
        :user_id => current_user.id,
        :title => 'Test',
        :desc => 'Description'
      })

  end

  def agb
  end

  def privacy
  end

  def imprint
  end

  def saleguide
  end

  def sending_guide
  end
  
  def fees
  end

  def menu
  end

end

