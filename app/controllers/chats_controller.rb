class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_chat, only: [:show, :edit, :update, :destroy]

  # GET /chats
  # GET /chats.json
  def index
    @chats = Chat.all
  end

  # GET /chats/1
  # GET /chats/1.json
  def show
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats
  # POST /chats.json
  def create
    @chat = Chat.new(chat_params)
    respond_to do |format|
      if @chat.save
        format.html { redirect_to @chat, notice: 'Chat was successfully created.' }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1
  # PATCH/PUT /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to @chat, notice: 'Chat was successfully updated.' }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  def destroy
    @chat.destroy
    respond_to do |format|
      format.html { redirect_to chats_url, notice: 'Chat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def chatsearch
    if (params[:folds] == "0")
      @chats = Chat.or({desc: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}).limit(50)
    else
      @i = params[:folds].to_i
      @chats = Chat.or({desc: /.*#{params[:keyword]}.*/i}, {name: /.*#{params[:keyword]}.*/i}).skip(@i*50).limit(50)
      # @products = Product.search(params[:keyword]).order("created_at DESC")
    end
    # @products << Product.where(name: params[:keyword])
    # @products << Product.where(category: params[:keyword])

    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @chat }
    end

  end


  def publicchats
    @chats = Chat.where(chat_type: 'public')
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @chat }
    end
  end

  def privatechats
    @chats = Chat.where(chat_type: 'private')
    respond_to do |format|
      format.html { render :index }
      format.json { render :index, status: :ok, location: @chat }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    @chat = Chat.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def chat_params
    params.require(:chat).permit(:name, :desc, :chat_type, :owner, :products_names => [], :products_imgs => [], :chatters => [], :products => [], :collections => [])
  end
end