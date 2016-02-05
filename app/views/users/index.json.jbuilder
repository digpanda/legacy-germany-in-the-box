json.array!(@users) do |u|
  json.id u.id
  json.extract! u, :username, :fname, :lname, :country, :lang
  json.pic u.pic.thumb.url ? request.base_url + u.pic.thumb.url : nil
  json.follower_count u.followers.size
  json.following_count u.following.size
end