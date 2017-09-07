class BaseService

  Response = Struct.new(:success?, :data, :error)
  Error = Class.new(StandardError)

  def return_with(state, details=nil)
    case state
    when :error
      dispatch_error!
      Response.new(false, nil, details)
    when :success
      Response.new(true, details)
    else throw "Bad state."
    end
  end

  private

    def dispatch_error!
      if Rails.config.debug_mode
        SlackDispatcher.new.message("[DEBUG] Error returned by a service `#{details}`")
      end
    end

end
