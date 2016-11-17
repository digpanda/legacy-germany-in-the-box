# module FormHelper
# I GAVE UP ON BUILDING THIS SYSTEM BUT KEEP IT FOR LEGACY PURPOSE IF I WANT TO TRY AGAIN
# - Laurent
#
#   # we use a homemade class to simply group the fields
#   # this is used in the variants system
#   def group_fields(form_field, limit, &block)
#     FieldsGrouper.new(form_field, limit).group(&block)
#   end
#
# end
#
# class FieldsGrouper
#
#   attr_reader :form_field, :limit
#
#   def initialize(form_field, limit)
#     @form_field = form_field
#     @limit = limit
#   end
#
#   def group(&block)
#     form.fields_for :options do |field_option|
#     yield(self)
#   end
#
#   def throw(&block)
#     limit.times do
#       yield
#     end
#   end
#
# end
