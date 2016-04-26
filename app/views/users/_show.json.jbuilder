json.extract! user, :id, :username, :fname, :lname, :birth, :about, :website, :tel, :mobile
json.gender user.gender.abbr
json.pic user.pic.url
json.follower_count user.followers.size
json.following_count user.following.size
