module Uploadable
  extend ActiveSupport::Concern

  include CarrierWave::MiniMagick

  included do

    storage Rails.env.development? ? :file : :qiniu

    self.qiniu_can_overwrite = true
    self.qiniu_protocal = 'https'

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

  end
end
