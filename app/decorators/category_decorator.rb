class CategoryDecorator < Draper::Decorator

  include Imageable

  delegate_all
  decorates :category

  def draw_tree


=begin
    children.each_with_object({}) do |child, memo|
      memo[:name] = child.children.any? ? child.decorate.draw_tree : {}
    end
=end

    children.inject("") do |memo, child| # We should refacto this code and put the HTML in a view

      memo << "<li class=\"dir\"><a href=\"#\">#{child.name}</a>"
      memo << "<ul>#{child.decorate.draw_tree}</ul>" if not child.children.empty?
      memo << "</li>"

    end.html_safe

  end


end
