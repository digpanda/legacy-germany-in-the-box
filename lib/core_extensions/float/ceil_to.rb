module CoreExtensions
  module Float
    module CeilTo
      def ceil_to(decimals)
        (self * 10**decimals).ceil.to_f / 10**decimals
      end
    end
  end
end
