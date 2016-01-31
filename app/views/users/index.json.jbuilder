json.array!(@users) do |u|
  json.extract! u, :id, :username, :fname, :lname, :website, :country, :pic, :lang
  json.follower_count u.followers.size
  json.following_count u.following.size
end
