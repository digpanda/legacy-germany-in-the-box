json.array!(@notifications) do |notification|
  json.extract! notification, :id, :senderId, :receiverId, :targetId, :message, :timestamp, :read, :state, :noti_type
  json.url notification_url(notification, format: :json)
end
