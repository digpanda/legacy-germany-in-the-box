class ShopDecorator < Draper::Decorator

  include Concerns::Imageable
  include ActionView::Helpers::TextHelper # load truncate

  delegate_all
  decorates :shop

  def readable_wirecard_status
    case self.wirecard_status
      when :unactive
        'Not applied'
      when :active
        'Active'
      when :processing
        'Processing'
      when :documents_complete
        'Documents complete'
      when :declined
        'Disapproved'
      when :terminated
        'Terminated'
      else
        'Unknown'
    end
  end

  def short_desc(characters=70)
    truncate(self.desc, length: characters)
  end

  def manager_full_name
    "#{fname} #{lname}"
  end

end
