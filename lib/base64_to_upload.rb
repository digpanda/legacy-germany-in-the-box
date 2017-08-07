module Base64ToUpload
  def base64_to_uploadedfile(model, image)
    base64 = params.require(model)[:base64]

    if base64
      base64_code = base64[:code]
      base64_original_filename = base64[:original_filename]

      tempfile = Tempfile.new(SecureRandom.hex(16).to_s)
      tempfile.binmode
      tempfile.write(Base64.decode64(base64_code))

      params[model][image] = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: base64_original_filename, original_filename: base64_original_filename);
    end
  end
end
