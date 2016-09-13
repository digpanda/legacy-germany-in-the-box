# Get notifications from Wirecard when a transaction has been done
class Api::Webhook::Wirecard::CustomersController < Api::ApplicationController

  attr_reader :datas

  WIRECARD_CONFIG = Rails.application.config.wirecard

  before_action :testing

  def index
  end

  def show
  end

  def create
  end

  def update
  end

  def testing
    SlackDispatcher.new.message(params)
  end

end
