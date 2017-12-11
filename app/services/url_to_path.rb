require 'digest/sha1'
require 'open-uri'

class UrlToPath < BaseService
  attr_reader :url

  # UrlToPath.new("http://localhost:3000/guest/referrers/59e0d6782fe398a892253f8d/qrcode.jpg").perform
  def initialize(url)
    @url = url
  end

  # TODO : avoid overwriting, but output direct path when already existing.

  def directory_path
    "#{Rails.root}/public/tmp/"
  end

  # the filename is the encrypted complete URL
  def filename
    @filename ||= "#{Digest::SHA1.hexdigest("#{url}")}#{extension}"
  end

  def extension
    @extension ||= File.extname(url)
  end

  def full_path
    "#{Rails.root}/public/images/tmp/#{filename}"
  end

  def original_file
    @original_file ||= open(url).read
  end

  def end_file
    @end_file ||= File.open(full_path, "wb")
  end

  def perform
    FileUtils.mkdir_p directory_path
    end_file.write(original_file)
    full_path
  end

end
