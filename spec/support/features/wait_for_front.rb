module Helpers
  module Features
    module WaitForFront
      def wait_for_redirection
        binding.pry
        origin_path = page.current_path
        Timeout.timeout(Capybara.default_max_wait_time) do
          loop until finished_all_redirection_activity?(origin_path)
        end
      end

      def finished_all_redirection_activity?(origin_path)
        puts "#{page.current_path}"
        puts "#{page.driver.request.env['HTTP_REFERER']}"
        puts "---"
        page.current_path != origin_path
      end
    end
  end
end
