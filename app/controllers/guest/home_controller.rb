class Guest::HomeController < ApplicationController

  before_action :admin_redirection

  def show
  end

  private

  def admin_redirection
    if identity_solver.potential_admin?
      redirect_to edit_admin_account_path
    end
  end

end
