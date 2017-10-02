class Admin::ServicesController < ApplicationController
  attr_reader :service, :services

  authorize_resource class: false
  layout :custom_sublayout

  before_action :set_service, except: [:new, :create, :index]

  def index
    @services = Service.order_by(position: :asc).full_text_search(query, match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10)
  end
  def new
    @service = Service.new
  end

  def show
  end

  def create
    @service = Service.create(service_params)
    if service.errors.empty?
      flash[:success] = 'The service was created'
      redirect_to admin_services_path
    else
      flash[:error] = "The service was not created (#{service.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def edit
  end

  def update
    if service.update(service_params)
      flash[:success] = 'The service was updated.'
      redirect_to admin_services_path
    else
      flash[:error] = "The service was not updated (#{service.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def destroy
    if service.destroy
      flash[:success] = 'The service account was successfully destroyed.'
    else
      flash[:error] = "The service was not destroyed (#{service.errors.full_messages.join(', ')})"
    end
    redirect_to admin_services_path
  end

  def active
    service.active = true
    if service.save
      flash[:success] = 'Service is now active'
    else
      flash[:error] = service.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  def unactive
    service.active = false
    if service.save
      flash[:success] = 'Service is now unactive'
    else
      flash[:error] = service.errors.full_messages.join(', ')
    end
    redirect_to navigation.back(1)
  end

  private

    def query
      params.require(:query) if params[:query].present?
    end

    def set_service
      @service = Service.find(params[:service_id] || params[:id])
    end

    def service_params
      params.require(:service).permit!
    end
end
