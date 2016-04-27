class ISO4217::Currency
  def mongoize
    ISO4217::Currency.mongoize(self)
  end

  class << self
    def mongoize(currency)
      if currency.is_a?(self) && !currency.code.nil?
        currency.code
      elsif send(:valid_code?, currency)
        from_code(currency).code
      end
    end

    def demongoize(code)
      from_code(code)
    end

    def evolve(currency)
      mongoize(currency)
    end

    private

    def valid_code?(currency)
      currency.is_a?(String) && !ISO4217::Currency.from_code(currency).nil?
    end
  end
end
