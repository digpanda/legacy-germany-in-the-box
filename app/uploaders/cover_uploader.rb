class CoverUploader < CarrierWave::Uploader::Base
  include Concerns::Uploadable
  include Concerns::Imageable
end
