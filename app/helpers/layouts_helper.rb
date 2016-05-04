module LayoutsHelper

  def is_menu_active?(sym)

    if Array === sym
      sym.map(&:to_s).include?(params[:user_info_edit_part]) ? 'active' : ''
    else
      params[:user_info_edit_part] ? (params[:user_info_edit_part] == sym.to_s ? 'active' : '') : 'active'
    end

  end

end