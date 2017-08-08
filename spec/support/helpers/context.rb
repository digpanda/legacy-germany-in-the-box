require 'rake'

module Helpers
  module Context
    module_function

    def raw_post(action, params, body)
      @request.env['RAW_POST_DATA'] = body
      response = post(action, params)
      @request.env.delete('RAW_POST_DATA')
      response
    end

    def create_categories!
      Rails.application.load_tasks
      Rake::Task['digpanda:remove_and_create_ui_categories'].invoke
      Rake::Task['digpanda:remove_and_create_ui_categories'].reenable
    end
  end
end
