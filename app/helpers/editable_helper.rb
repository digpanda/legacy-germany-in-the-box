module EditableHelper

  def editable_text(form, model, field)
    """
    <span class=\"js-editable-text\">
      #{model.send(field)}
    </span>
    """
  end

  def editable_text_field(form, model, field)
    """
    <span class=\"js-editable-field\">
    #{form.text_field field}
    </span>
    """
  end

  def editable_click
    """
    <span class=\"js-editable-click\">
    <a href=\"#\"><i class=\"fa fa-edit tooltipster\" title=\"Edit the field\"></i></a>
    </span>
    """
  end

  def editable_send
    """
    <span class=\"js-editable-submit\">
    <button type=\"submit\" class=\"+clear-button\"><i class=\"fa fa-check-circle tooltipster\" title=\"Update the field\"></i></button>
    </span>
    """
  end

  def editable_field(model, field, type, path)

    form_for model, url: path, method: :patch, html: {:class => '+inline'} do |form|
      """
      <span class=\"js-editable\">
        #{editable_text(form, model, field)}
        #{editable_text_field(form, model, field)}
        #{editable_click}
        #{editable_send}
      </span>
      """.html_safe
    end

  end
end
