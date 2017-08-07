module TranslationHelper

  def translation_js(slug, scope=nil)
    content_tag(:div, nil, :class => "js-translation", :data => {
      :slug => slug.to_s,
      scope: scope.to_s,
      :content => I18n.t(slug, scope: scope)
    })
  end

  # we use a homemade class to communicate the instructions and turn it
  # into an improved text_field, text_area while keeping the HTML inside the view
  def translate_fields(form, field, &block)
    FieldsTranslator.translate_fields(form, field, &block)
  end

end
