# image displayer for qiniu
class ImageDisplayer
  class Qiniu
    
    CONFIG = Rails.configuration.qiniu
    ACCEPTED_SIZES = [:thumb, :detail, :fullsize, :zoomin]

    attr_reader :base_url, :version, :size

    def initialize(base_url, version)
      @version = version
      @base_url = base_url
      @size = CONFIG[:size][version]
    end

    def url
      "#{base_url}&#{url_extension}"
    end

    private

    def url_extension
      size_url if accepted_size?
    end

    def size_url
      "imageView2/2/w/#{size}/h/#{size}"
    end

    def accepted_size?
      ACCEPTED_SIZES.include?(version)
    end

  end
end
