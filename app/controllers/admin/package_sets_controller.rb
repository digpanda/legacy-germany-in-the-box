class Admin::PackageSetsController < ApplicationController
  attr_reader :package_set, :package_sets

  authorize_resource class: false
  layout :custom_sublayout

  before_action :set_package_set, except: [:index]

  def index
    @package_sets = PackageSet.order_by(position: :asc).full_text_search(query, match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10)
  end

  private

    def query
      params.require(:query) if params[:query].present?
    end

    def set_package_set
      @package_set = PackageSet.find(params[:package_set_id] || params[:id])
    end
end
