# OLD WAY
# <%= form.fields_for :desc_translations do |trans_field| %>
#   <div class="col-md-5">
#     <%= trans_field.text_area :de, :value => form.object.desc_translations[:de], :class => 'form-control', :required => true %>
#     <div class="help-block with-errors"></div>
#   </div>
#   <div class="col-md-5">
#     <%= trans_field.text_area :'zh-CN', :value => form.object.desc_translations[:'zh-CN'], :class => 'form-control', :required => true %>
#     <div class="help-block with-errors"></div>
#   </div>
# <% end %>
#
# NEW WAY
# <%= translate_fields form, :desc do |form_field| %>
#   <div class="col-md-5">
#     <%= form_field.text_area :class => 'form-control', :required => true %>
#     <div class="help-block with-errors"></div>
#   </div>
# <% end %>
class FieldsTranslator
  LANGUAGES = [:de, :'zh-CN'].freeze

  class << self

    # we target the specific `field_for` specific to MongoID
    # this is the equivalent to something like `form.fields_for :desc_translations do |form_field|`
    # then we yield each translation result using the mapper
    def translate_fields(form, field, &block)
      form.fields_for "#{field}_translations" do |form_field|
        LANGUAGES.each do |language|
          yield FieldsMapper.new(form, form_field, field, language)
        end
      end
    end

  end

end

class FieldsMapper
  attr_reader :form, :form_field, :field, :language

  # we need those datas to compose the form_field call
  def initialize(form, form_field, field, language)
    @form = form
    @form_field = form_field
    @field = field
    @language = language
  end

  # this method will call dynamically any form related methods
  # such as `text_field`, `text_area`
  # we then add up the language specifications
  # and the added options sent from the view
  def method_missing(method, *args)
    arguments = {:value => object_field[language]}.merge(*args)
    form_field.send(method, language, arguments)
  end

  def object_field
    form.object.send("#{field}_translations")
  end

end
