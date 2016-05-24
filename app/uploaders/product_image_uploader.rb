class ProductImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage Rails.env.local? ? :file : :qiniu

  self.qiniu_can_overwrite = true

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def image?(new_file)
    self.file.content_type.include? 'image'
  end

  def not_image?(new_file)
    !self.file.content_type.include? 'image'
  end

  if Rails.env.local?
    version :thumb, :if => :image? do
      process :resize_and_pad => [400, 400]
    end

    version :detail, :if => :image? do
      process :resize_and_pad => [400, 400]
    end
  end

  def default_url
    [version_name, "no_image_available.jpg"].compact.join('_')
  end
end