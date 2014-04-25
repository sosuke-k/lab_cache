class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper
  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    require 'open-uri'
    uri = URI params[:url]
    source = open(uri).read
    obj = Readability::Document.new(source, encoding: 'utf-8')

    title = obj.title
    content_html = obj.content.encode('UTF-8')
    images = obj.images

    if  ( (images[0] =~ /^\//) == 0) # relative path
      images[0] = 'http://' + uri.host + images[0]
    elsif ( (images[0] =~ /^http/) != 0) # filename only
      images[0] = 'http://' + uri.host + uri.path + images[0]
    end

    twitter_id = params[:user][:quiche_twitter_id]
    image_url = params[:user][:quiche_twitter_image_url]

    if ( ( user = User.find_by(twitter_id: twitter_id) ) == nil )
      user = User.create({
        twitter_id: twitter_id,
        image_url: image_url
        })
    end

    if ( item = Item.find_by(title: title) ) # 既に読まれていた場合
      # binding.pry
    else
      @item = Item.new({
        title: title,
        url: params[:url],
        content: content_html,
        first_image_url: images[0],
        user_id: User.find_by(twitter_id: twitter_id).id
      })

      respond_to do |format|
        if @item.save
          format.json {
            render json: {
              action: 'add',
              result: 'success',
              content_html: re_arrange(content_html),
              first_image_url: @item.first_image_url
            }
          }
        else
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
    Reader.create({user: user, item: item}) # user を reader に追加
  end

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

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:title, :first_image_url, :user_id, :name, :content, :deleted_at)
    end
end
