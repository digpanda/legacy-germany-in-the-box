class CategoryDecorator < Draper::Decorator

  delegate_all
  decorates :category

  def shops
    @shops = Shop.all.map { |s| [s.id, s] }.to_h
    @shops = Product.only(:shop_id).where(:category_ids => self.id ).to_a.map { |p| @shops[p.shop_id] }
  end

=begin
  def navigation_tree
    children.inject("") do |memo, child| # We should refacto this code and put the HTML in a view
      memo << "<li class=\"dir\"><a href=\"#\">#{child.name}</a>"
      memo << "<ul>#{child.decorate.draw_tree}</ul>" if child.children.any?
      memo << "</li>"
    end.html_safe
  end
=end
=begin
  def navigation_tree

    children.inject("") do |memo, child| # We should refacto this code and put the HTML in a view

      memo << "<li class=\"dir\"><a href=\"#\">#{child.name}</a>"
      memo << "<ul>#{child.decorate.draw_tree}</ul>" if child.children.any?
      memo << "</li>"

    end.html_safe

  end
=end

end
