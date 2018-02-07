require 'fileutils'
require 'json'

class WechatReferrerQrcode < BaseService
  attr_reader :referrer

  def initialize(referrer)
    @referrer = referrer
  end

  def resolve
    if already_stored?
      return_with(:success, local_file: local_file, remote_call: false)
    else
      remote_qrcode
    end
  end

  # we try to the referrer qrcode in 3 steps
  def remote_qrcode
    @remote_qrcode ||= begin
      return return_with(:error, 'Access token is wrong') if access_token_gateway['errcode']
      return return_with(:error, 'Access ticket is wrong') if access_ticket_gateway['errcode']
      return return_with(:error, 'Access qrcode is wrong') if access_qrcode_gateway['errcode']

      remote_to_local!
      return_with(:success, local_file: local_file, remote_call: true)
    end
  end

  private

    # we call the API and store it within our local directory
    def remote_to_local!
      FileUtils::mkdir_p "#{Rails.root}/public/uploads/referrer/qrcode"
      File.open(local_file, 'wb') do |file|
        file.write(access_qrcode)
      end
    end

    # does it already exist ?
    def already_stored?
      File.exist?(local_file)
    end

    def local_file
      @local_file ||= begin
        "#{Rails.root}/public/uploads/referrer/qrcode/#{referrer.reference_id}.jpg"
      end
    end

    # this will return a raw image you can stream freely
    def access_qrcode
      access_qrcode_gateway
    end

    def access_token
      access_token_gateway['access_token']
    end

    def access_ticket
      access_ticket_gateway['ticket']
    end

    def access_qrcode_gateway
      @access_qrcode_gateway ||= Parser.get qrcode_url
    end

    def access_ticket_gateway
      @access_ticket ||= begin
        if Rails.env.production?
          permanent_qrcode
        else
          temporary_qrcode
        end
      end
    end

    def permanent_qrcode
      Parser.post_json ticket_url,
        "action_name": 'QR_LIMIT_STR_SCENE',
        "action_info": {
          "scene": {
            "scene_str": "#{extra_data.to_json}"
          }
        }
    end

    def temporary_qrcode
      Parser.post_json ticket_url,
        "expire_seconds": 604800,
        "action_name": 'QR_STR_SCENE',
        "action_info": {
          "scene": {
            "scene_str": "#{extra_data.to_json}"
          }
        }
    end

    def extra_data
      {
        referrer: {
          reference_id: referrer.reference_id
        }
      }
    end

    # NOTE : we could remove the access token because it was abstracted somewhere else already
    def access_token_gateway
      @access_token_gateway ||= Parser.get_json weixin_access_token_url
    end

    def qrcode_url
      "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{access_ticket}"
    end

    def ticket_url
      "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{access_token}"
    end

    def weixin_access_token_url
      "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{Rails.application.config.wechat[:username_mobile]}&secret=#{Rails.application.config.wechat[:password_mobile]}"
    end
end
