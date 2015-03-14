class PostsController < ApplicationController
  before_action :not_logged_in?, only: [:new, :create, :edit, :update]
  before_action :current_user_is_post_owner?, only: [:edit, :update]

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id

    if @post.save
      params[:subs_list].each do |sub_id|
        PostSub.new(sub_id: sub_id, post_id: @post.id).save!
      end  
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end


  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :author_id)
  end
end
