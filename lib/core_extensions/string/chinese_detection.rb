module CoreExtensions
  module String
    module ChineseDetection
      def chinese?
        (self =~ /\p{Han}/).is_a? Integer
      end
    end
  end
end
