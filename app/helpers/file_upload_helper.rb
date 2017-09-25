module FileUploadHelper
  def js_file_upload(form:, field:)
    render partial: 'shared/partials/file_upload', locals: { form: form, field: field }
  end

  def js_image_file_upload(form:, assoc:, field:)
    render partial: 'shared/partials/image_file_upload', locals: { form: form, assoc: assoc, field: field }
  end

  # this helper is solely used in the file_upload partial
  # to guess what path to use to destroy any image
  # depending on the form class
  # TODO : this system is ok for now but it's too many conditions
  # we should group those methods into a shared controller rather than duplicating it. very useless.
  # PROBLEM : the controllers don't have the exact same name. i suppose we should first refactor the model and create an `image` model which would simplify everything.
  def guess_destroy_image_path(form, field)
    case form.object
    when Sku
      if current_user.shopkeeper?
        shopkeeper_product_sku_destroy_image_path(form.object.product, form.object, image_field: field)
      else
        admin_shop_product_sku_destroy_image_path(form.object.product.shop, form.object.product, form.object, image_field: field)
      end
    when Shop
      if current_user.shopkeeper?
        destroy_image_shopkeeper_shop_path(form.object, image_field: field)
      else
        admin_shop_destroy_image_path(form.object, image_field: field)
      end
    when Setting
      admin_setting_destroy_image_path(form.object, image_field: field)
    when PackageSet
      admin_shop_package_set_destroy_image_path(shop_id: form.object.shop.id, package_set_id: form.object.id, image_field: field)
    when Image
      admin_shop_package_set_destroy_image_path(shop_id: form.object.package_set.shop.id, package_set_id: form.object.package_set.id, image_field: field)
    when Category
      admin_category_destroy_image_path(form.object, image_field: field)
    end
  end

  def guess_destroy_image_file_path(object, image_id)
    case object
    when PackageSet
      admin_shop_package_set_destroy_image_file_path(shop_id: object.shop.id, package_set_id: object.id, image_id: image_id)
    end
  end
end
