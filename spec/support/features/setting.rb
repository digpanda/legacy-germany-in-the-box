module Helpers
  module Features
    module Setting
      module_function

      def logistic!(partner: :mkpost)
        ::Setting.delete_all
        ::Setting.create!(logistic_partner: partner)
      end
    end
  end
end
