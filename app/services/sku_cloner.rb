# we clone entirely the sku and alter the cloned one (image service, etc.)
# in the `target` model which's most of the time `product`
# but it's flexible.
# sku can be present in other part of the system such as `order_item`
# the `relationship` is the way we should integrate the sku to the `target` (many or one sku relationship)
class SkuCloner < BaseService

  IMAGES_MAP = [:img0, :img1, :img2, :img3]
  ATTACH_MAP = [:attach0]

  attr_reader :target, :sku, :relationship

  def initialize(target, sku, relationship=:plural)
    @target = target
    @sku = sku
    @relationship = relationship
  end

  def process
    entry!
    # we save after all alterations
    if target.save
      FileWorker.perform_async(sku.product.id, target.id, sku.id, clone.id, relationship)
      return_with(:success, :clone => clone)
    else
      clone.destroy
      return_with(:error, :target => target)
    end
  end

  def clone
    @clone ||= begin
      sku.clone.tap do |clone|
        if relationship == :plural
          target.skus << clone
        elsif relationship == :singular
          target.sku = clone
        end
      end
    end
  end

  private

  # we simply call the memoized method
  # this will process it once
  def entry!
    clone
  end

end
