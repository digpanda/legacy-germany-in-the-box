class WechatBot
  class Exchange < WechatBot::Base
    class Scheme < WechatBot::Exchange
      class Semantic < Scheme
        # semantic is a test text to make sure the semantic API works alright
        def request
          'semantic'
        end

        def response
          WechatApiSemantic.new(user, "查一下明天从北京到上海的南航机票").resolve
        end
      end
    end
  end
end