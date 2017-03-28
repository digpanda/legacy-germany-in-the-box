module Helpers
  module Poltergeist

    def reload_page
      page.evaluate_script("window.location.reload()")
      # page.driver.browser.navigate.refresh <-- SELENIUM
    end

  end
end
