class ProductImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage Rails.env.development? ? :file : :qiniu

  self.qiniu_can_overwrite = true
  self.qiniu_protocal = 'https'

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def image?(new_file)
    self.file.content_type.include? 'image'
  end

  def not_image?(new_file)
    !self.file.content_type.include? 'image'
  end

  version :thumb, :if => :image? do
    process resize_to_limit: [500, 500]
  end

  # version :detail, :if => :image? do
  #   process resize_to_fill: [400, 400]
  # end
  #
  # version :fullsize, :if => :image? do
  #   process resize_to_fill: [600, 600]
  # end
  #
  # version :zoomin, :if => :image? do
  #   process resize_to_fill: [1000, 1000]
  # end

  def default_url
    [version_name].compact.join('_')
  end
end
