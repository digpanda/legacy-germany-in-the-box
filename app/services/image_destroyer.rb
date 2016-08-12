# remove images dynamically
class ImageDestroyer < BaseService

  attr_reader :model, :authorized_fields

  def initialize(model, authorized_fields)
    @model = model
    @authorized_fields = authorized_fields
  end

  def perform(image_field)
    image_field = image_field.to_sym
    if valid_model_image?(image_field)
      remove!(image_field)
    else
      false
    end
  end

  def remove!(image_field)
    model.send("remove_#{image_field}=", true)
    model.save
  end

  def valid_model_image?(image_field)
    model.respond_to?(image_field) && authorized_fields.include?(image_field)
  end

end
