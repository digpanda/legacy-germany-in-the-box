class Admin::ReferrerGroupsController < ApplicationController
  include DestroyImage

  attr_accessor :referrer_group, :referrer_groups

  authorize_resource class: false

  before_action :set_referrer_group, :except => [:index, :new, :create]

  before_action :breadcrumb_admin_referrer_groups, :except => [:index]
  before_action :breadcrumb_admin_referrer_group, :except => [:index]
  before_action :breadcrumb_admin_referrer_group_edit, only: [:edit]
  before_action :breadcrumb_admin_referrer_group_new, only: [:new]

  layout :custom_sublayout

  def index
    @referrer_groups = ReferrerGroup.order_by(:position => :asc).paginate(page: current_page, per_page: 10)
  end

  def new
    @referrer_group = ReferrerGroup.new
  end

  def show
  end

  def create
    @referrer_group = ReferrerGroup.create(referrer_group_params)
    if @referrer_group.errors.empty?
      flash[:success] = "The referrer group was created."
      redirect_to admin_referrer_groups_path
    else
      flash[:error] = "The referrer token was not created (#{@referrer_group.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def edit
  end

  def update
    if referrer_group.update(referrer_group_params)
      flash[:success] = "The referrer_group was updated."
      redirect_to admin_referrer_groups_path
    else
      flash[:error] = "The referrer group was not updated (#{referrer_group.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def destroy
    if referrer_group.destroy
      flash[:success] = "The referrer group account was successfully destroyed."
    else
      flash[:error] = "The referrer group was not destroyed (#{referrer_group.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

    def set_referrer_group
      @referrer_group = ReferrerGroup.find(params[:referrer_group_id] || params[:id])
    end

    def referrer_group_params
      params.require(:referrer_group).permit!
    end
end
