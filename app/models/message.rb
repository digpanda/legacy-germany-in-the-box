class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :chat
  field :content, type: String
  field :sender, type: String
  field :sender_name, type: String
  field :sender_imgurl, type: String

  field :sender_name, type: String
  field :receiver, type: String
end
