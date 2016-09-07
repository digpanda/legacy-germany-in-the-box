module LayoutsHelper

  def menu_active?(path)
    return "" if @menu_active
    if url_for.index(path) == 0
      @menu_active = true
      "active"
    else
      ""
    end
  end

end
