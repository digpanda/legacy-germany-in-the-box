module EditableHelper

  def editable_text(form, model, field)
    # `false` is a special case because some boolean can show up
    if model.send(field).present? || model.send(field) === false
      """
      <span class=\"js-editable-text\">
        #{model.send(field)}
      </span>
      """
    else
      """
      <span class=\"js-editable-text\">
        ---
      </span>
      """
    end
  end

  def editable_chosen_field(form, field, type, options)
    if type == :text_field
      editable_text_field(form, field)
    elsif type == :select
      editable_select(form, field, options)
    end
  end

  def editable_text_field(form, field)
    """
    <span class=\"js-editable-field\">
    #{form.text_field field, :autocomplete => "off"}
    </span>
    """
  end

  def editable_select(form, field, options)
    """
    <span class=\"js-editable-field\">
    #{form.select(field, options_for_select(*options))}
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

  def editable_field(model, path, field, type, options=nil)

    form_for model, url: path, method: :patch, html: {:class => '+inline'} do |form|
      """
      <span class=\"js-editable\">
        #{editable_text(form, model, field)}
        #{editable_chosen_field(form, field, type, options)}
        #{editable_click}
        #{editable_send}
      </span>
      """.html_safe
    end

  end
end
