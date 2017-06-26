class ShopDecorator < Draper::Decorator

  include Concerns::Imageable
  include ActionView::Helpers::TextHelper # load truncate

  delegate_all
  decorates :shop

  def short_desc(characters=70)
    truncate(self.desc, length: characters)
  end

  def manager_full_name
    "#{fname} #{lname}"
  end

end
