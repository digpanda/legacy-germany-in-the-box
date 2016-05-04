module LayoutsHelper

  def is_menu_active?(sym)
    params[:user_info_edit_part] ? (params[:user_info_edit_part] == sym.to_s ? 'active' : '') : 'active'
  end

end