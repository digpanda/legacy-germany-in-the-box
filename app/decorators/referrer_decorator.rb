class ReferrerDecorator < Draper::Decorator
  delegate_all
  decorates :referrer

  def histories
    provisions = referrer.provisions
    operations = referrer.provision_operations

    array_provisions = provisions.reduce([]) do |acc, provision|
      acc << {
          type: provision.type,
          description: provision.desc,
          transfer: provision.provision.in_euro.display,
          date: provision.c_at.strftime('%Y-%m-%d')
        }
    end
    array_operations = operations.reduce([]) do |acc, operation|
      acc << {
          type: :operation,
          description: operation.desc,
          transfer: operation.amount.in_euro.display,
          date: operation.c_at.strftime('%Y-%m-%d')
        }
    end

    merged = array_provisions + array_operations
    merged.sort_by { |key| key[:date] }.reverse
  end
end
