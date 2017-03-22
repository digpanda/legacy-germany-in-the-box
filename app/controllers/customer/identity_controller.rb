require 'net/http'

class Customer::IdentityController < ApplicationController

  UID = "kacam".freeze
  KEY = "9f74e107b1519718584af77847deb5b2".freeze

  authorize_resource :class => false
  layout :custom_sublayout, only: [:edit]

  def edit
    @identity_form = Net::HTTP.get_response(URI.parse(identity_remote_url)).body.force_encoding('UTF-8')
  end

  private

  def identity_remote_url
    "http://www.xipost.de/api15.php?uid=#{UID}f&key=#{KEY}&i=uiNewIdCard&type=ui"
  end


end
