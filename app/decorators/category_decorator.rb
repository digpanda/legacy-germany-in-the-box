class CategoryDecorator < Draper::Decorator

  delegate_all
  decorates :category

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
