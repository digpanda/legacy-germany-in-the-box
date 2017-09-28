class Guest::InquiriesController < ApplicationController
  attr_reader :inquiry

  before_filter do
    restrict_to :customer
  end

  before_action :set_inquiry, except: [:create]
  before_action :freeze_header

  def create
    binding.pry
  end

  private

    def set_inquiry
      @inquiry = Service.find(params[:id] || params[:inquiry_id]) if params[:id] || params[:inquiry_id]
    end
end
