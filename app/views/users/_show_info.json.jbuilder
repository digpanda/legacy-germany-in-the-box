json.extract! user, :id, :username, :country, :lang, :birth, :about, :website
json.gender user.gender.abbr
json.pic user.pic.url
json.follower_count user.followers.size
json.following_count user.following.size
