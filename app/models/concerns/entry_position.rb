module EntryPosition
  extend ActiveSupport::Concern

  included do
  end

  # previous entry
  def previous
    self.class.where(:_id.lt => self._id).order_by([[:_id, :desc]]).limit(1).first
  end

  # next entry
  def next
    self.class.where(:_id.gt => self._id).order_by([[:_id, :asc]]).limit(1).first
  end
end
