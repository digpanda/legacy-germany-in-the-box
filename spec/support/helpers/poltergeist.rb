module Helpers
  module Poltergeist
    def reload_page
      page.evaluate_script('window.location.reload();')
      # page.driver.browser.navigate.refresh <-- SELENIUM
    end

    def screenshot!
      page.save_screenshot("~/Desktop/file_#{Time.now.to_i}.png", full: true)
    end
  end
end
