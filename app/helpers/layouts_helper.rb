module LayoutsHelper
  # def title(page_title)
  #   content_for :title, page_title.to_s
  # end

  def menu_active?(path)
    return '' if @menu_active
    if url_for.index(path) == 0
      @menu_active = true
      'active'
    else
      ''
    end
  end

  def inside_layout(parent_layout = 'application')
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end

  def solve_logo
    return "/images/logos/germany-in-the-box-resellers.svg" if referrer?
    return @customization.logo.url if @customization&.logo&.present?

    "/images/logos/germany-in-the-box.svg"
  end

  def solve_title
    return @customization.title if @customization&.title&.present?
  end
end
