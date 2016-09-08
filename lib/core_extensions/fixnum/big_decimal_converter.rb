module CoreExtensions
  module Fixnum
    module BigDecimalConverter
      def to_b
        BigDecimal.new(self.to_s)
      end
    end
  end
end
