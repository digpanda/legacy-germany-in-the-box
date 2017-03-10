module DestroyImage
  extend ActiveSupport::Concern

  # TODO : this should be completely refactored and
  # abstracted into a specific image model to stay DRY and RESTful
  def destroy_image
    if ImageDestroyer.new(call_model_entry).perform(params[:image_field])
      flash[:success] = I18n.t(:removed_image, scope: :action)
    else
      flash[:error] = I18n.t(:no_removed_image, scope: :action)
    end
    redirect_to navigation.back(1)
  end

  # ugly but working for now
  # we guess the model by selecting
  # the last instance variable
  def guess_model_entry
    # TODO : change the way it is
    # params[:model], :id
    self.instance_variable_names.last.sub('@','')
  end

  # we call the instance variable
  # should return a model
  def call_model_entry
    self.send(guess_model_entry)
  end

end
