module NotDeleteable
  def destroy
    unless self.respond_to? :deleted
      raise MissingMigrationException
    end

    self.update_attribute :deleted, true
  end

  def delete
    self.destroy
  end

  def self.included(base)
    base.class_eval do
      default_scope -> { where( :deleted => false ) }
    end
  end
end

class MissingMigrationException < Exception
  def message
    'deleted flag not defined'
  end
end