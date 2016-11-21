module Helpers
  module Context
    
    def create_ui_categories!
      unless Category.first
        require 'rake'
        Rails.application.load_tasks
        Rake::Task["digpanda:remove_and_create_ui_categories"].invoke
      end
    end

  end
end
