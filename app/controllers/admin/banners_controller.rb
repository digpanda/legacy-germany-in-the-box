class Admin::BannersController < ApplicationController
  include DestroyImage

  attr_reader :banner, :banners

  authorize_resource class: false

  before_action :set_banner, except: [:index, :new, :create]

  before_action :breadcrumb_admin_banners, except: [:index]
  before_action :breadcrumb_admin_banner, only: [:edit]

  layout :custom_sublayout

  def index
    @banners = Banner.all
  end

  def new
    @banner = Banner.new
  end

  def edit
  end

  def update
    if banner.update(banner_params)
      flash[:success] = 'The banner was updated.'
      redirect_to admin_banners_path
    else
      flash[:error] = "The banner was not updated (#{banner.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def destroy
    if banner.destroy
      flash[:success] = 'The banner account was successfully destroyed.'
    else
      flash[:error] = "The banner was not destroyed (#{banner.errors.full_messages.join(', ')})"
    end
    redirect_to admin_banners_path
  end

  private

    def set_banner
      @banner = Banner.find(params[:banner_id] || params[:id])
    end

    def banner_params
      params.require(:banner).permit!
    end
end
