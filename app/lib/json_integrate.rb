module JsonIntegrate

  def followers_reciprocity(user, followers)
    followers.map { |f| f.as_json.merge({:reciprocity => (f.followers.include? user._id)}) }
  end

end