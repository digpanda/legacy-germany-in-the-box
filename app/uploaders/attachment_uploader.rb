class AttachmentUploader < CarrierWave::Uploader::Base

  include Uploadable
  include Pdfable

end
