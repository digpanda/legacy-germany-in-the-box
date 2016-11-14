module FileUploadHelper

  def js_file_upload(form:, field:, destroy_image_path:)
    render partial: "shared/partials/file_upload", :locals => {form: form, field: field, destroy_image_path: destroy_image_path}
  end

end
