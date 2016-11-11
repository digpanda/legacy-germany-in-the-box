module FileUploadHelper

  def js_file_upload(form:, field:)
    render partial: "shared/partials/file_upload", :locals => {form: form, field: field}
  end

end
