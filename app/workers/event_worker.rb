# we go through sidekiq to send all the API calls to KeenIO
# Even when it's not asynchronous, we go through the worker
# To avoid repeating ourselves
class EventWorker
  include Sidekiq::Worker

  def perform(stream, arguments)
    result = keen.publish(stream, arguments)
    raise Exception, result
    # geo may blow up because of some weird IP result
    # we ensure it does not block the system
  rescue Keen::HttpError => exception
    SlackDispatcher.new.error(exception)
  rescue Exception => exception
    SlackDispatcher.new.error(exception)
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
