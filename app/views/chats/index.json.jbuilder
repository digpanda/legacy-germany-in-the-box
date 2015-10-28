json.array!(@chats) do |chat|
  json.extract! chat, :id, :name, :desc, :chat_type, :owner, :chatters, :products, :collections, :products_imgs, :products_names
  json.url chat_url(chat, format: :json)
end
