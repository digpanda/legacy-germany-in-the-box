module Concerns
  module Uploadable
    extend ActiveSupport::Concern

    include CarrierWave::MiniMagick

    included do

      storage (Rails.env.development? || Rails.env.test?) ? :file : :qiniu

      self.qiniu_can_overwrite = true
      self.qiniu_protocal = 'https'

      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

      def image?(new_file)
        self.file.content_type.include? 'image'
      end
    end
  end
end
