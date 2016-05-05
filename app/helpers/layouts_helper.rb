module LayoutsHelper

  def is_menu_active?(item,default=false)

    if params[:user_info_edit_part].nil?
      if default
        return 'active'
      else
        return ''
      end
    end

    if Array === item
      item.map(&:to_s).include?(params[:user_info_edit_part]) ? 'active' : ''
    else
      params[:user_info_edit_part] ? (params[:user_info_edit_part] == item.to_s ? 'active' : '') : 'active'
    end

  end

end