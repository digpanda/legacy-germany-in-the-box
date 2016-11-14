module FileUploadHelper

  def js_file_upload(form:, field:)
    render partial: "shared/partials/file_upload", :locals => {form: form, field: field}
  end

  # this helper is solely used in the file_upload partial
  # to guess what path to use to destroy any image
  # depending on the form class
  def guess_destroy_image_path(form, field)
    case form.object
    when Sku
      shopkeeper_product_sku_destroy_image_path(form.object.product, form.object, image_field: field)
    when Shop
      destroy_image_shopkeeper_shop_path(form.object, image_field: field)
    end
  end

end
