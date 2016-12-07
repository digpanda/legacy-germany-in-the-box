require 'rake'

module Helpers
  module Context

    module_function

    def create_categories!
      Rails.application.load_tasks
      Rake::Task["digpanda:remove_and_create_ui_categories"].invoke
      Rake::Task["digpanda:remove_and_create_ui_categories"].reenable
    end

  end
end
