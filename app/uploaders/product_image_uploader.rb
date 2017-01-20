class ProductImageUploader < CarrierWave::Uploader::Base

  include Uploadable

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
