class Admin::InquiriesController < ApplicationController
  attr_reader :inquiry, :inquiries

  authorize_resource class: false
  before_action :set_inquiry, except: [:index]

  before_action :breadcrumb_admin_inquiries, except: [:index]
  before_action :breadcrumb_admin_inquiry, only: [:show, :edit]

  layout :custom_sublayout

  def index
    @inquiries = Inquiry.order_by(position: :asc).order_by(c_at: :desc).full_text_search(params[:query], match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10)
  end

  def show
  end

  def update
    if inquiry.update(inquiry_params)
      flash[:success] = 'The inquiry was updated.'
      redirect_to admin_inquiries_path
    else
      flash[:error] = "The inquiry was not updated (#{inquiry.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def destroy
    if inquiry.destroy
      flash[:success] = 'The inquiry account was successfully destroyed.'
    else
      flash[:error] = "The inquiry was not destroyed (#{inquiry.errors.full_messages.join(', ')})"
    end
    redirect_to admin_inquiries_path
  end

  private

    def set_inquiry
      @inquiry = Inquiry.find(params[:id] || params[:inquiry_id])
    end

    def inquiry_params
      params.require(:inquiry).permit!
    end
end
