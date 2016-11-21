module Helpers
  module Context

    # def use_development_database!
    #   unless $dev_database_on
    #     require 'rake'
    #     Rails.application.load_tasks
    #     Rake::Task["digpanda:remove_and_create_complete_sample_data"].invoke
    #     $dev_datavase_on = true
    #   end
    # end

    def create_ui_categories!
      unless Category.first
        require 'rake'
        Rails.application.load_tasks
        Rake::Task["digpanda:remove_and_create_ui_categories"].invoke
      end
    end

  end
end
