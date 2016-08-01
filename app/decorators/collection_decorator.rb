class CollectionDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :collection

end