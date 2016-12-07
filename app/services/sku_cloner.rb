# we clone entirely the sku and alter the cloned one (image service, etc.)
# in the `target` model which's most of the time `product`
# but it's flexible.
# sku can be present in other part of the system such as `order_item`
class SkuCloner < BaseService

  IMAGES_MAP = [:img0, :img1, :img2, :img3]
  ATTACH_MAP = [:attach0]

  attr_reader :target, :sku

  def initialize(target, sku)
    @target = target
    @sku = sku
  end

  def process
    entry!
    images!
    attach!
    # we save after all alterations
    if target.save
      return_with(:success)
    else
      return_with(:error, :target => target)
    end
  end

  def clone
    @clone ||= begin
      sku.clone.tap do |clone|
        target.skus << clone
      end
    end
  end

  private

  # we simply call the memoized method
  # this will process it once
  def entry!
    clone
  end

  def images!
    IMAGES_MAP.each do |image_field|
      copy_file(image_field)
    end
  end

  def attach!
    ATTACH_MAP.each do |attach_field|
      copy_file(attach_field)
    end
  end

  def copy_file(field)
    if sku.send(field).present?
      CopyCarrierwaveFile::CopyFileService.new(sku, clone, field).set_file
    end
  end

end
