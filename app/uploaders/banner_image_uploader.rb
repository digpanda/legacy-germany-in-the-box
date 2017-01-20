class BannerImageUploader < CarrierWave::Uploader::Base

  include Uploadable
  
  if Rails.env.local?
    # Create different versions of your uploaded files:
    version :thumb, :if => :image? do
      process :resize_and_pad => [728, 90]
    end

    version :detail, :if => :image? do
      process :resize_and_pad => [850, 400]
    end
  end

end
