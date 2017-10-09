class EventWorker
  include Sidekiq::Worker

  def perform(keen, stream, arguments)
    keen.publish(stream, arguments)
  end
end
