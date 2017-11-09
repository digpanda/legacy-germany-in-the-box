module WechatBot
  module Exchange
    module Scheme
      class Semantic < Base
        extend Options

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
