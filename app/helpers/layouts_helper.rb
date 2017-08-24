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

  def inside_layout(parent_layout='application')
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end
  
end
