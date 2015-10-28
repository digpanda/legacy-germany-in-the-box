json.array!(@users) do |user|
  json.extract! user, :id, :username, :email, :en_password, :fname, :lname, :birth, :gender, :about, :website, :country, :pic, :lang, :parse_id, :saved_collections, :saved_products, :private_chats, :public_chats, :notifications
  json.url user_url(user, format: :json)
end
