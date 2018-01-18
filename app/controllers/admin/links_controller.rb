require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Admin::LinksController < ApplicationController
  attr_reader :link, :links

  authorize_resource class: false
  before_action :set_link, except: [:index, :create, :new]

  layout :custom_sublayout

  def index
    @links = Link.order_by(position: :asc).order_by(c_at: :desc).full_text_search(params[:query], match: :all, allow_empty_search: true).paginate(page: current_page, per_page: 10)
  end

  def new
    @link = Link.new
  end

  def show
  end

  def create
    @link = Link.create(link_params)
    if link.errors.empty?
      if link.newly_published?
        flash[:success] = 'The link was created and published, all notifications were sent accordingly.'
        notify_publication!
      else
        flash[:success] = 'The link was created and will not be visible for users yet.'
      end
      redirect_to admin_links_path
    else
      flash[:error] = "The link was not created (#{link.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def edit
  end

  def update
    if link.update(link_params)
      if link.newly_published?
        flash[:success] = 'The link was updated and is currently published, notification were sent if needed.'
        notify_publication!
      else
        flash[:success] = 'The link was updated and was already published.'
      end
      redirect_to admin_links_path
    else
      flash[:error] = "The link was not updated (#{link.errors.full_messages.join(', ')})"
      render :new
    end
  end

  def destroy
    if link.destroy
      flash[:success] = 'The link account was successfully destroyed.'
    else
      flash[:error] = "The link was not destroyed (#{link.errors.full_messages.join(', ')})"
    end
    redirect_to admin_links_path
  end

  def ping
    if valid_link?
      link.update(valid_url: true)
      flash[:success] = 'Link is valid.'
    else
      link.update(valid_url: false)
      flash[:error] = 'Link is not valid.'
    end
    redirect_to admin_links_path
  end

  private

    def notify_publication!
      Referrer.all.each do |referrer|
        Notifier::Customer.new(referrer.user).published_link(link)
      end
    end

    def valid_link?
      RestClient.get(link.raw_url)
      true
    rescue SocketError => exception
      false
    end

    def set_link
      @link = Link.find(params[:id] || params[:link_id])
    end

    def link_params
      params.require(:link).permit!
    end
end
