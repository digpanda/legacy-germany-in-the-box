class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:home, :privacy, :imprint, :saleguide, :fees, :menu]

  def home
    @categories = Category.all

      EmitNotificationAndDispatchToUser.new.perform({
        :user_id => User.first.id,
        :title => 'You just received a new order',
        :desc => "A customer just ordered in your shop. Check it out !"
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

