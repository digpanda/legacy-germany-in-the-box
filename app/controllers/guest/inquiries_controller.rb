class Guest::InquiriesController < ApplicationController
  attr_reader :inquiry

  before_filter do
    restrict_to :customer
  end

  before_action :set_inquiry, except: [:create]

  def create
    @inquiry = Inquiry.create(inquiry_params)
    if inquiry.errors.empty?
      if current_user
        inquiry.update(user: current_user, referrer: current_user.parent_referrer)
      end

      if inquiry.errors.empty?
        Notifier::Admin.new.new_inquiry(inquiry)
        flash[:success] = 'Your inquiry was successfully sent.'
        redirect_to guest_services_path
        return
      end
    end

    flash[:error] = "#{inquiry.errors.full_messages.join(', ')}"
    redirect_to navigation.back(1)
  end

  private

    def inquiry_params
      params.require(:inquiry).permit(:service_id, :email, :mobile, :scheduled_for, :comment, :raw_referrer)
    end

    def set_inquiry
      @inquiry = Service.find(params[:id] || params[:inquiry_id]) if params[:id] || params[:inquiry_id]
    end
end
