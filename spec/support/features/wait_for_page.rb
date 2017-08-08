module Helpers
  module Features
    module WaitForPage
      # we cannot find by current_url / path because the redirection are front-end based
      # therefore we need to check the new page by selector
      def wait_for_page(selector)
        # Timeout.timeout(Capybara.default_max_wait_time) do
        loop until page.find(selector)
        # end
      end
    end
  end
end
