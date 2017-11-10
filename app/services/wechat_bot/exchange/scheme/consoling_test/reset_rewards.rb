# module WechatBot
#   module Exchange
#     module Scheme
#       class ConsolingTest < Base
#         class ResetRewards < Base
#
#           # valid_until -> { 7.days.from_now }
#
#           def request
#             'reset rewards'
#           end
#
#           def response
#             user.rewards.delete_all
#             messenger.text! 'Your rewards were erased.'
#           end
#         end
#       end
#     end
#   end
# end
