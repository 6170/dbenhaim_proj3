class CommentsController < ApplicationController
  load_and_authorize_resource
  def index
    @comments = Comment.includes(:comments).order_by([:created_at, :desc])
    render json: @comments
  end

  def show
    @comment = Comment.find(params[:id])
    render json: @comment
  end

  def new
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @comment = Comment.new(content: params[:content])
    @comment.update_attributes(user_id: current_user.id, email: current_user.email)
    if params[:type] == "comment"
      @comment.update_attributes(parent_id: params[:parent_id])
      parent_comment = Comment.find(params[:parent_id])
      parent_comment.comments << @comment
      parent_comment.save
    elsif params[:type] == "post"
      @comment.update_attributes(threaded_comment_polymorphic_id: params[:parent_id], threaded_comment_polymorphic_type: params[:type], post_id: params[:parent_id])
    end

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(:votes => params[:votes], :vote_ids => params[:voter_ids])
      @comment.save()
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    head :no_content
  end
end

# respond_to do |format|
#       format.json do
#         render :json => @posts.to_json(:include => { :comments => {  :include => {:comments => {} }  } })
#       end
#     end