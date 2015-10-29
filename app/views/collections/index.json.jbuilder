json.array!(@collections) do |collection|
  json.extract! collection, :id, :name, :desc, :visible, :coltype, :img, :user, :users, :products
  json.url collection_url(collection, format: :json)
end
