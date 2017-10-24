require 'cgi'
require 'digest/sha1'

# <xml><ToUserName><![CDATA[gh_c6ddf30d6707]]></ToUserName>
# <FromUserName><![CDATA[oHb0TxCVMzCxEjCV2I-8wu9Z74Yk]]></FromUserName>
# <CreateTime>1499777930</CreateTime>
# <MsgType><![CDATA[event]]></MsgType>
# <Event><![CDATA[SCAN]]></Event>
# <EventKey><![CDATA[1172017]]></EventKey>
# <Ticket><![CDATA[gQFN8DwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyVS1EQ3d2dFpjajQxdGtKSk5wY0sAAgTVsmRZAwSAOgkA]]></Ticket>
# </xml>
#
# Get notifications from Wechat when the referrer Qrcode has been scanned
class Api::Webhook::WechatController < Api::ApplicationController
  attr_reader :transmit_data

  skip_before_filter :verify_authenticity_token

  def index
    handle
  end

  def show
    handle
  end

  def create
    handle
  end

  # WARNING : Must stay public for throw_error to work well for now.
  def devlog
    @@devlog ||= Logger.new(Rails.root.join("log/wechat-webhook-#{Time.now.strftime('%Y-%m-%d')}.log"))
  end

  private

    def handle
      return if hook_activation?
      devlog.info 'Wechat started to communicate with us ...'

      unless valid_xml?
        throw_api_error(:bad_format, { error: 'Wrong format transmitted' }, :bad_request)
        return
      end

      devlog.info("Raw params : #{transmit_data}")
      slack.message("Raw params : #{transmit_data}")

      # insert and manage webhook cace
      if already_cached?
        return end_process
      end

      # message handling
      if text?
        if text_callback.success?
          return end_process
        else
          return throw_api_error(:bad_format, { error: text_callback.error }, :bad_request)
        end
      end

      # event handling
      if event?
        if event_callback.success?
          return end_process
        else
          return throw_api_error(:bad_format, { error: event_callback.error }, :bad_request)
        end
      end

      return end_process
    end

    def end_process
      devlog.info 'End of process.'
      render text: 'success'
    end

    # this is sent multiple times by the webhook, we protect multiple answers
    # we encrypt it beforehand for better processing / search / confidentiality
    def already_cached?
      if WebhookCache.cached?(cache_key)
        devlog.info('Data were already processed.')
        slack.message('Data were already processed.')
        true
      else
        WebhookCache.create!(key: cache_key, section: :wechat)
        false
      end
    end

    def cache_key
      @cache_key ||= Digest::SHA1.hexdigest("#{transmit_data}")
    end

    def event_callback
      WechatBot::Event.new(user, event, event_key).dispatch
    end

    def text_callback
      WechatBot::Text.new(user, content).dispatch
    end

    def wechat_user_solver
      @wechat_user_solver ||= WechatUserSolver.new(provider: :wechat, openid: openid).resolve
    end

    def user
      @user ||= begin
        if wechat_user_solver.success?
          wechat_user_solver.data[:customer]
        end
      end
    end

    def openid
      transmit_data['FromUserName']
    end

    def text?
      transmit_data['MsgType'] == 'text'
    end

    def event?
      transmit_data['MsgType'] == 'event'
    end

    def content
      transmit_data['Content']
    end

    def event
      transmit_data['Event']&.downcase
    end

    def event_key
      transmit_data['EventKey']&.downcase
    end

    def transmit_data
      @transmit_data ||= body&.[]('xml')
    end

    def body
      @body ||= Hash.from_xml(request.body.read)
    end

    def valid_xml?
      body
      true
    rescue REXML::ParseException
      false
    end

    def hook_activation?
      if params[:echostr]
        slack.message "[Webhook] Our Wechat Webhook is now verified / activated (echostr `#{params[:echostr]}`)."
        devlog.info 'End of process.'
        render text: "#{params[:echostr]}"
        true
      else
        false
      end
    end
end
