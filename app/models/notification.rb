class Notification
  include Mongoid::Document

  field :senderId, type: String
  field :receiverId, type: String
  field :targetId, type: String
  field :message, type: String
  field :timestamp, type: Time, default: Time.now


  field :read, type: String #:read => 1, :notread => 0
  field :state, type: String #:read => 1, :notread => 0
  field :noti_type, type: String #:prod => 0, :coll => 1 ,:chat => 2 , :msg => 3

end
