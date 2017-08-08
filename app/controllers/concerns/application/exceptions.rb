module Application
  module Exceptions
    extend ActiveSupport::Concern
    include ErrorsHelper

    included do
      around_action :hard_exception_handler
      around_action :soft_exception_handler
    end

    # handle hard exception (which will throw a page error)
    # and soft ones even on dev / test (which will usually redirect the customer)
    if Rails.env.development?

      def hard_exception_handler
        yield
      end

    else

      def hard_exception_handler
        yield
      rescue Mongoid::Errors::DocumentNotFound => exception
        throw_resource_not_found
      rescue Exception => exception
        throw_server_error_page
      ensure
        dispatch_error_email(exception)
      end

    end

    def soft_exception_handler
      yield
    rescue CanCan::AccessDenied
      throw_unauthorized_page
    end
  end
end
