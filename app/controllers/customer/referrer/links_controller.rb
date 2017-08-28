class Customer::Referrer::LinksController < ApplicationController
  attr_reader :referrer

  before_action :freeze_header
  before_filter :valid_referrer?
  before_action :set_referrer
  before_action :set_link, only: [:share]

  # this will load the weixin handler on the front-end side
  before_action :activate_weixin_js_config, only: [:share]
  before_action :minimal_layout, only: [:share]

  authorize_resource class: false

  def index
    if current_user.tester?
      @links = Link.order_by(position: :asc).order_by(c_at: :desc)
    else
      @links = Link.active.order_by(position: :asc).order_by(c_at: :desc)
    end
  end

  def share
  end

  private

    def set_referrer
      @referrer = current_user.referrer
    end

    def set_link
      @link = Link.find(params[:link_id])
    end

    def valid_referrer?
      unless current_user&.referrer?
        flash[:error] = I18n.t('general.not_allowed_section')
        redirect_to navigation.back(1)
        false
      end
    end
end
