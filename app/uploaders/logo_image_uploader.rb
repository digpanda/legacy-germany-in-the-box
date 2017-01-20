class LogoImageUploader < CarrierWave::Uploader::Base

  include Uploadable

  if Rails.env.local?
    # Create different versions of your uploaded files:
    version :thumb, :if => :image? do
      process :resize_and_pad => [90, 90]
    end

    version :detail, :if => :image? do
      process :resize_and_pad => [350, 350]
    end
  end
end
