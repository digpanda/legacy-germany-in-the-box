json.array!(@collections) do |collection|
  json.extract! collection, :id, :name, :desc, :visible, :coltype, :img, :owner, :likers, :products, :private_chats, :public_chats, :owner_img, :owner_name, :products_imgs
  json.url collection_url(collection, format: :json)
end
