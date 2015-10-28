json.array!(@posts) do |post|
  json.extract! post, :id, :name, :image, :productId, :collectionId, :chatId
  json.url post_url(post, format: :json)
end
