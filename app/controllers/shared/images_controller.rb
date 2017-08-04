class Shared::ImagesController < ApplicationController
  attr_reader :image

  before_action :authenticate_user!
  before_action :set_image

  def destroy
    if image.destroy
      flash[:success] = 'The image was successfully destroyed.'
    else
      flash[:error] = "The image was not destroyed (#{image.errors.full_messages.join(', ')})"
    end

    redirect_to navigation.back(1)
  end

  private

    def set_image
      @image = Image.find(params[:id])
    end
end
