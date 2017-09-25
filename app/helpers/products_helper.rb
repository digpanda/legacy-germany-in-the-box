module ProductsHelper
  def enough_inventory?(sku, quantity)
    sku&.enough_stock?(quantity)
  end

  def get_options_names(product)
    product.skus.map do |s|
      s.option_ids.compact.map do |oid|
        o = product.options.detect { |v| v.suboptions.where(id: oid).first }.suboptions.find(oid)
        o.name
      end.join(', ')
    end.join(' - ')
  end

  def get_options_for_select(product)
    skus = product.available_skus
    values = skus.map { |s| s.option_ids.compact.join(',') }
    names  = skus.map do |s|
      s.option_ids.compact.map do |oid|
        o = product.options.detect { |v| v.suboptions.where(id: oid).first }.suboptions.find(oid)
        o.name
      end.join(', ')
    end
    values.each_with_index.map { |v, i| [names[i], v] }
  end

  def get_options_json(sku)
    variants = sku.option_ids.map do |oid|
      sku.product.options.detect do |v|
        v.suboptions.where(id: oid).first
      end
    end

    variants.each_with_index.map do |v, i|
      o = v.suboptions.find(sku.option_ids[i])
      { name: v.name, option: { id: o.id, name: o.name } }
    end
  end
end
