module DestroyImage
  extend ActiveSupport::Concern

  # ugly but working for now
  # we guess the model by selecting
  # the last instance variable
  def guess_model_entry
    # TODO : change the way it is
    # params[:model], :id
    self.instance_variable_names.last.sub('@', '')
  end

  # we call the instance variable
  # should return a model
  def call_model_entry
    self.send(guess_model_entry)
  end

  private

    def get_process_message(image_destroyer)
      if image_destroyer
        flash[:success] = I18n.t('action.removed_image')
      else
        flash[:error] = I18n.t('action.no_removed_image')
      end
    end
end
