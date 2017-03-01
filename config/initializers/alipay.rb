Alipay.pid = '2088101122136241'
Alipay.key = '760bdzec6y9goq7ctyx96ezkz78287de'
# Alipay.pid = '2088621169102875'
# Alipay.key = 'rl6bmklv0qieuqee02psosxxgrdb0v9f'



AlipayGlobal.api_partner_id = '2088101122136241'
AlipayGlobal.api_secret_key = '760bdzec6y9goq7ctyx96ezkz78287de'


AlipayGlobal::Service::Trade.create(
    out_trade_no: '20150401000-0001',
    subject: 'Subject',
    currency: 'EUR',
    total_fee: '10.00',
    notify_url: 'https://example.com/orders/20150401000-0001/notify'
)