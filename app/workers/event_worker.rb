class EventWorker
  include Sidekiq::Worker

  def perform(stream, arguments)
    result = keen.publish(stream, arguments)
    SlackDispatcher.new.message("ASYNC RESULT #{result}")
  end

  private

    def keen
      @keen ||= Keen::Client.new(
        'project_id': ENV['keen_project_id'],
        'write_key': ENV['keen_write_key'],
        'read_key': ENV['keen_read_key'],
      )
    end
end
