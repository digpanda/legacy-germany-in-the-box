# this class solely exists to get give the matching duty category
# through AJAX calls
class Api::Admin::DutyCategoriesController < Api::ApplicationController
  attr_reader :duty_category

  authorize_resource class: false
  before_action :set_duty_category

  def show

    unless duty_category
      render status: :not_found,
             json: throw_error(:resource_not_found).to_json
      return
    end

    render status: :ok,
          json: {success: true, datas: {:duty_category => duty_category}}.to_json
  end

  private

    # we use the code to find for now
    def set_duty_category
      @duty_category = DutyCategory.where(code: params[:id]).first
    end
end
