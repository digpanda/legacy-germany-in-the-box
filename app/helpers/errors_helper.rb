module ErrorsHelper

  ERRORS_CONFIG = Rails.application.config.errors

  def throw_resource_not_found
    render "errors/page_not_found",
           status: :not_found,
           layout: "errors/default"
  end

  def throw_unauthorized_page
    render "errors/unauthorized_page",
           status: :unauthorized,
           layout: "errors/default"
  end

  def throw_app_error(sym)
    render "errors/customized_error",
           status: :bad_request,
           layout: "errors/default",
           locals: throw_error(sym)
  end

  def throw_api_error(sym, merged_attributes={}, status=:bad_request)
    render status: status, 
           json: throw_error(sym).merge(merged_attributes).to_json
  end

  def throw_error(sym)
    devlog.info ERRORS_CONFIG[sym][:error] if self.respond_to?(:devlog)
    json_error(sym)
  end

  def json_error(sym)
    {success: false}.merge(ERRORS_CONFIG[sym] || ERRORS_CONFIG[:unknown_error])
  end

  def throw_model_error(model, view=nil)
    flash[:error] = model.errors.full_messages.join(', ')
    return render view if view
    return redirect_to(:back)
  end
  
end