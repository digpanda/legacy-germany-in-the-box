::CarrierWave.configure do |config|

  config.storage              = :qiniu
  config.qiniu_access_key     = 'sjmi6rq8r6Z7oO84m9WQ3grXZJNaDmBlHC5eDWsu'
  config.qiniu_secret_key     = 'Vp_6J0c4GZML4PESk5vMv6yVgTCYY7x4XtKt3JCj'

  if Rails.env.production?
    config.qiniu_bucket         = 'carrierwave-laiyinn-prod'
    config.qiniu_bucket_domain  = 'img.germanyinbox.com'
  else
    config.qiniu_bucket         = 'carrierwave-laiyinn-staging'
    config.qiniu_bucket_domain  = 'o9fh2muer.qnssl.com'
  end

  config.qiniu_bucket_private = true
  config.qiniu_block_size     = 4*1024*1024
  config.qiniu_protocol       = 'http'
  config.qiniu_up_host        = 'http://up.qiniug.com'

end
