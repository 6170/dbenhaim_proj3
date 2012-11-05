class PostsController < ApplicationController
  load_and_authorize_resource
  def index
    @posts = Post.includes(:comments).order_by([:created_at, :desc])
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])
    @post.update_attributes(user_id: current_user.id, email: current_user.email)
    if @post.save
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(:comments_attributes => params[:comments_attributes])
      @post.save()
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    head :no_content
  end
end

# respond_to do |format|
#       format.json do
#         render :json => @posts.to_json(:include => { :comments => {  :include => {:comments => {} }  } })
#       end
#     end