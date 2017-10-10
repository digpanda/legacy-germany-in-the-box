# we go through sidekiq to send all the API calls to Slack
# Even when it's not asynchronous, we go through the worker
# To avoid repeating ourselves
class SlackWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'one_at_a_time'

  WEBHOOK_URL = 'https://hooks.slack.com/services/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'.freeze
  CHANNEL = '#notifs'.freeze
  USERNAME = 'Lorenzo Schaffnero'.freeze

  def perform(end_message)
    slack.ping end_message
  end

  private

  def slack
    @slack ||= Slack::Notifier.new WEBHOOK_URL, channel: CHANNEL, username: USERNAME
  end
end
