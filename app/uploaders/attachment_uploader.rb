class AttachmentUploader < CarrierWave::Uploader::Base

  include Uploadable

  def extension_white_list
    %w(pdf)
  end
end
