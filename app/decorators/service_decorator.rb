class ServiceDecorator < Draper::Decorator
  include Concerns::Imageable

  delegate_all
  decorates :service
end
