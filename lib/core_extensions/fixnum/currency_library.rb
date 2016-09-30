module CoreExtensions
  module Fixnum
    module CurrencyLibrary
      def in_euro
        Currency.new(self, 'EUR')
      end
      def in_yuan
        Currency.new(self, 'CNY')
      end
    end
  end
end
