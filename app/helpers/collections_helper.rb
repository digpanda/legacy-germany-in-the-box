module CollectionsHelper

  def in_user_collections?(product)
    current_user.oCollections.each do |c|
      return true if c.products.include?(product)
    end

    return false
  end

end