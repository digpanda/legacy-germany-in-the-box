class Admin::ReferrerTokensController < ApplicationController

  include DestroyImage

  attr_accessor :referrer_token, :referrer_tokens

  authorize_resource :class => false

  before_action :set_referrer_token, :except => [:index, :new, :create]

  before_action :breadcrumb_admin_referrer_tokens, :except => [:index]
  before_action :breadcrumb_admin_referrer_token, :except => [:index]
  before_action :breadcrumb_admin_referrer_token_edit, only: [:edit]
  before_action :breadcrumb_admin_referrer_token_new, only: [:new]

  layout :custom_sublayout

  def index
    @referrer_tokens = ReferrerToken.order_by(:position => :asc).paginate(:page => current_page, :per_page => 10)
  end

  def new
    @referrer_token = ReferrerToken.new
  end

  def show
  end

  def create
    @referrer_token = ReferrerToken.create(referrer_token_params)
    if @referrer_token.errors.empty?
      flash[:success] = "The referrer token was created."
      redirect_to admin_referrer_tokens_path
    else
      flash[:error] = "The referrer token was not created (#{@referrer_token.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def edit
  end

  def update
    if referrer_token.update(referrer_token_params)
      flash[:success] = "The referrer_token was updated."
      redirect_to admin_referrer_tokens_path
    else
      flash[:error] = "The referrer_token was not updated (#{referrer_token.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def destroy
    if referrer_token.destroy
      flash[:success] = "The referrer token account was successfully destroyed."
    else
      flash[:error] = "The referrer token was not destroyed (#{referrer_token.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_referrer_token
    @referrer_token = ReferrerToken.find(params[:referrer_token_id] || params[:id])
  end

  def referrer_token_params
    params.require(:referrer_token).permit!
  end

end
