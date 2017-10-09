# we go through sidekiq to send all the API calls to KeenIO
# Even when it's not asynchronous, we go through the worker
# To avoid repeating ourselves
class EventWorker
  include Sidekiq::Worker

  def perform(stream, arguments)
    SlackDispatcher.new.message("what the shit")
    result = keen.publish(stream, arguments)
    raise Exception
    SlackDispatcher.new.message("RESULT OF SIDEKIQ PERF : #{result}")
    # geo may blow up because of some weird IP result
    # we ensure it does not block the system
  rescue Keen::HttpError => exception
    SlackDispatcher.new.message("shit happened")
  rescue Exception => exception
    SlackDispatcher.new.message("RESULT #{result}")
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
