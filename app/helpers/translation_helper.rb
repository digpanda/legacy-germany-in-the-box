class TranslatorField
  LANGUAGES = [:de, :'zh-CN']
  class << self

    def translate_fields(form, field, &block)
      form.fields_for "#{field}_translations" do |form_field|
        LANGUAGES.each do |language|
          yield(TranslatorFieldMapping.new(form, form_field, field, language))
        end
      end
    end

  end
end

class TranslatorFieldMapping

  attr_reader :form, :form_field, :field, :language

  def initialize(form, form_field, field, language)
    @form = form
    @form_field = form_field
    @field = field
    @language = language
  end

  def text_area(*args)
    arguments = {:value => object_field[language]}.merge(*args)
    form_field.text_area(language, arguments)
  end

  def object_field
    form.object.send("#{field}_translations")
  end

end

module TranslationHelper

  def translation_js(slug, scope=nil)
    content_tag(:div, nil, :class => "js-translation", :data => {
      :slug => slug.to_s,
      :scope => scope.to_s,
      :content => I18n.t(slug, scope: scope)
    })
  end

  def translate_fields(form, field, &block)
    TranslatorField.translate_fields(form, field, &block)
  end

end
