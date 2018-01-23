module FileUploadHelper
  def js_file_upload(form:, field:)
    render partial: 'shared/partials/file_upload', locals: { form: form, field: field }
  end

  def js_image_file_upload(form:, assoc:, field:)
    render partial: 'shared/partials/image_file_upload', locals: { form: form, assoc: assoc, field: field }
  end
end
