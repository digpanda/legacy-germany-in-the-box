module ErrorsHelper

  ERRORS_CONFIG = Rails.application.config.errors

  def throw_error(sym)
    devlog.info ERRORS_CONFIG[sym][:error] if self.respond_to?(:devlog)
    {success: false}.merge(ERRORS_CONFIG[sym] || ERRORS_CONFIG[:unknown_error])
  end

  def throw_model_error(model, view=nil)
    flash[:error] = model.errors.full_messages.join(', ')
    return render view if view
    return redirect_to(:back)
  end
  
end