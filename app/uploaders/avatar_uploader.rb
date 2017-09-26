class AvatarUploader < CarrierWave::Uploader::Base
  include Concerns::Uploadable
  include Concerns::Imageable
end
