class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  # def create
  #   @item = Item.new(item_params)

  #   respond_to do |format|
  #     if @item.save
  #       format.html { redirect_to @item, notice: 'Item was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @item }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def create
    require 'open-uri'
    source = open(params[:url]).read
    obj = Readability::Document.new(source, encoding: 'utf-8')

    title = obj.title
    content_html = obj.content.encode('UTF-8')
    images = obj.images

    @item = Item.new({
      title: title,
      url: params[:url],
      content: content_html,
      first_image_url: images[0],
      user_id: User.find_by(last_name: params[:user][:last_name]).id
    })

    respond_to do |format|
      if @item.save
        format.json {
          render json: {
            action: 'add',
            result: 'success',
            user: 'user',
            micropost_id: 1,
            content_html: content_html
          }
        }
      else
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :first_image_url, :user_id, :name, :content, :deleted_at)
    end
end
