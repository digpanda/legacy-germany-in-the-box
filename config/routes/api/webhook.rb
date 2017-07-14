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

  resource :wechat, :controller => 'wechat' do
  end

end
