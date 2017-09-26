# remove images dynamically
class ImageDestroyer < BaseService
  # TODO : this is not a good way to tackle the problem
  # the structure of the model itself should be changed
  # this is pathetic to have such fields in the database.
  # we are not a bunch of amateurs.
  # - Laurent
  SHOP_IMAGE_FIELDS = [:logo, :banner, :seal0, :seal1, :seal2, :seal3, :seal4, :seal5, :seal6, :seal7]
  SKU_IMAGE_FIELDS = [:img0, :img1, :img2, :img3]
  SETTING_IMAGE_FIELDS = [:package_sets_cover]
  PACKAGE_SET_IMAGE_FIELDS = [:cover]
  CATEGORY_IMAGE_FIELDS = [:cover]

  attr_reader :model

  def initialize(model)
    @model = model
  end

  # will effectively destroy an image field
  def perform(image_field)
    image_field = image_field.to_sym
    if valid_model_image?(image_field)
      remove!(image_field)
    else
      false
    end
  end

  def perform_image_file_destroyer(image_id)
    image = model.images.where(id: image_id).first
    image&.delete
  end

  private

    # get the authorized fields
    # depending on the model itself
    def authorized_fields
      @authorized_fields ||= begin
        case model
        when Shop
          SHOP_IMAGE_FIELDS
        when Sku
          SKU_IMAGE_FIELDS
        when Setting
          SETTING_IMAGE_FIELDS
        when PackageSet
          PACKAGE_SET_IMAGE_FIELDS
        when Category
          CATEGORY_IMAGE_FIELDS
        else
          []
        end
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
