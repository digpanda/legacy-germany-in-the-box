json.extract! @user, :id, :username, :fname, :lname, :country, :pic, :lang
json.follower_count @user.followers.size
json.following_count @user.following.size