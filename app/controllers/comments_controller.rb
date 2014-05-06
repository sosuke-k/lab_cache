class CommentsController < ApplicationController
  def create
    @comment = User.first.comments.build(item_id: params[:comment][:item_id].to_i, content: params[:comment][:content])
    if @comment.save
      # alert 'item created!'
    else
      @comment_items = []
      # render 'static_pages/home'
    end
      redirect_to '/items'
  end

  private

    def comment_params
      params.require(:comment).permit(:content,:item_id)
    end
end
