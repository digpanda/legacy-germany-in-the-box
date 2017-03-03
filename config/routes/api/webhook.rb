# Webhook related
namespace :webhook do

  namespace :wirecard do
    resource :merchant do
    end
    resource :customer do
    end
  end

  namespace :alipay do
    resource :customer do
    end
  end

end
