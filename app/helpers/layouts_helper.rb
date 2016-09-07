module LayoutsHelper

  def menu_active?(path)
    if url_for.index(path) == 0
      "active"
    else
      ""
    end
  end

end
