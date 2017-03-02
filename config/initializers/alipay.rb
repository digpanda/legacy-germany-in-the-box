if Rails.env.production?
  Alipay.pid = '2088621169102875'
  Alipay.key = 'rl6bmklv0qieuqee02psosxxgrdb0v9f'
else
  Alipay.pid = '2088101122136241'
  Alipay.key = '760bdzec6y9goq7ctyx96ezkz78287de'
end
