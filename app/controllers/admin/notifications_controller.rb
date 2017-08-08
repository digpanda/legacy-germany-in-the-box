class Admin::NotificationsController < ApplicationController
  attr_accessor :notification, :notifications

  before_action :set_notification, except: [:index]

  authorize_resource class: false

  layout :custom_sublayout

  def index
    @notifications = Notification.order(c_at: :desc).full_text_search(params[:query], match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10)
  end

  def destroy
    if notification.destroy
      flash[:success] = 'The notification account was successfully destroyed.'
    else
      flash[:error] = "The notification was not destroyed (#{notification.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

    def set_notification
      @notification = Notification.find(params[:id] || params[:notification_id])
    end
end
