# Webhook related
namespace :webhook do

  namespace :alipay do
    resource :customer do
    end
  end

  namespace :wechatpay do
    resource :customer do
    end
  end

  namespace :wechat do
    resource :qrcode do
    end
  end

end
