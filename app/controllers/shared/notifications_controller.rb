require 'will_paginate/array'

class Shared::NotificationsController < ApplicationController

  # This controller is linked with an API controller (Api::Customer::FavoritesController)
  before_action :authenticate_user!
  attr_reader :notifications

  before_action :set_notifications

  layout :custom_sublayout, only: [:index]

  def index
  end

  private

  def set_notifications
    @notifications ||= current_user.notifications.order_by(:c_at => 'desc').paginate(:page => (params[:page] ? params[:page].to_i : 1), :per_page => 10);
  end

end