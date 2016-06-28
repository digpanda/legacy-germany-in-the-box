class BannerImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage Rails.env.local? ? :file : :qiniu

  self.qiniu_can_overwrite = true

  # Where should files be stored?
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Returns true if the file is an image
  def image?(new_file)
    self.file.content_type.include? 'image'
  end

  # Returns true if the file is not an image
  def not_image?(new_file)
    !self.file.content_type.include? 'image'
  end

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