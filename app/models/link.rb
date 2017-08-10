class Link
  include MongoidBase

  field :title, type: String
  field :url, type: String
  field :position, type: Integer

end
