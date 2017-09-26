EasyCaptcha.setup do |config|
  # Cache
  config.cache          = true
  # Cache temp dir from Rails.root
  config.cache_temp_dir = Rails.root.join('tmp', 'captchas')
  # Cache expire
  config.cache_expire   = 1.day
  # Cache size
  # config.cache_size     = 500
  config.length         = 4
  config.image_width    = 80
end
