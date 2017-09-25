class PackageSetDecorator < Draper::Decorator
  include Concerns::Imageable
  include ActionView::Helpers::TextHelper

  delegate_all
  decorates :package_set

  def short_desc(characters = 100)
    truncate(self.desc, length: characters)
  end
end
