class Admin::NotesController < ApplicationController

  load_and_authorize_resource
  before_action :set_note, :except => [:index, :create]

  layout :custom_sublayout

  attr_accessor :note, :notes

  def index
  end

  def show
  end

  def create
    note = Note.create(note_params)
    if note
      flash[:success] = "The note was created."
    else
      flash[:error] = "The note was not created (#{note.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  def update
    if note.update(note_params)
      flash[:success] = "The note was updated."
    else
      flash[:error] = "The note was not updated (#{note.errors.full_messages.join(', ')})"
    end
    redirect_to navigation.back(1)
  end

  private

  def set_note
    @note = Note.find(params[:id] || params[:note_id])
  end

  def note_params
    params.require(:note).permit(:order_id, :user_id, :message, :type).merge({:author_id => current_user.id})
  end

end
