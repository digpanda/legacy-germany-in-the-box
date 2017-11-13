# will get all the valid subclasses of this class, ignoring the irrelevant ones
# NOTE : if you encounter difficulties to load subclasses, make sure you loaded them first
module WechatBot
  module Exchange
    module Utils
      class SubclassLoader
        attr_reader :mainclass

        def initialize(mainclass)
          @mainclass = mainclass
        end

        def perform

          valid_subclasses
        end

        private

        def valid_subclasses
          subclasses.select do |subclass|
            valid_subclass? subclass
          end
        end

        def subclasses
          constants.map(&const_get).grep(Class)
        end

        def const_get
          mainclass.method(:const_get)
        end

        def constants
          mainclass.constants
        end

        def valid_subclass?(subclass)
          subclass.to_s =~ /^(.*#{end_class}::[^::]+)$/ #subclass.to_s.include? "::#{end_class}"
        end

        def end_class
          mainclass.to_s.split('::').last
        end
      end
    end
  end
end
