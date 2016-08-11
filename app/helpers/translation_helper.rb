module TranslationHelper

  def translation_js(slug, scope=nil)
    content_tag(:div, nil, :class => "js-translation", :data => {
      :slug => slug.to_s,
      :scope => scope.to_s,
      :content => I18n.t(slug, scope: scope)
    })
  end

end
