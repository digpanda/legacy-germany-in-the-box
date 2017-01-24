class PackageSetDecorator < Draper::Decorator

  include Concerns::Imageable

  delegate_all
  decorates :package_set

end
