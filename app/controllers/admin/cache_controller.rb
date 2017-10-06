# manage the rails cache
class Admin::CacheController < ApplicationController
  def destroy
    Rails.cache.clear
    flash[:success] = "Cache was globally reset"
    redirect_to navigation.back(1)
  end
end
