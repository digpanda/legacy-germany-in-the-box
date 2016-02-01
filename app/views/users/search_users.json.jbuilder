json.array!(@users) do |u|
  json.extract! u, :id, :username, :country, :pic, :lang
  json.isFollowed u.followers.size > 0
end
