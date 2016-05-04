module LayoutsHelper

  def is_menu_active?(item)

    if Array === item
      item.map(&:to_s).include?(params[:user_info_edit_part]) ? 'active' : ''
    else
      params[:user_info_edit_part] ? (params[:user_info_edit_part] == item.to_s ? 'active' : '') : 'active'
    end

  end

end