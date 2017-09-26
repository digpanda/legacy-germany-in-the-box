class AttachmentUploader < CarrierWave::Uploader::Base
  include Concerns::Uploadable
  include Concerns::Pdfable
end
