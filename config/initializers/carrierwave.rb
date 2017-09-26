::CarrierWave.configure do |config|

  config.storage              = :qiniu
  config.qiniu_access_key     = ENV['qiniu_access_key']
  config.qiniu_secret_key     = ENV['qiniu_secret_key']

  if Rails.env.production?
    config.qiniu_bucket         = 'carrierwave-laiyinn-prod'
    config.qiniu_bucket_domain  = 'www.germanyinbox.com' # 'o9fhtjfm2.qnssl.com'
  else
    config.qiniu_bucket         = 'carrierwave-laiyinn-staging'
    config.qiniu_bucket_domain  = 'o9fh2muer.qnssl.com' #'www.germanyinbox.com' # 'o9fh2muer.qnssl.com'
  end

  config.qiniu_bucket_private = true
  config.qiniu_block_size     = 4 * 1024 * 1024
  config.qiniu_protocol       = 'https'
  config.qiniu_up_host        = 'http://up.qiniug.com'

end
