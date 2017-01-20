class ProductUploader < CarrierWave::Uploader::Base

  include Uploadable
  include Imageable

  version :thumb, :if => :image? do
    process resize_to_limit: [500, 500]
  end

  def default_url
    [version_name].compact.join('_')
  end

end
