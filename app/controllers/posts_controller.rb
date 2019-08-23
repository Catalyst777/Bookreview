class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.html 
      format.csv { send_data @posts.generate_csv, filename: "posts-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def confirm_new
    @post = Post.new(post_params)
    render :new unless @post.valid?
  end

  def update
    @post.update!(post_params)
    redirect_to posts_url, notice: "レビュー「#{@post.name}」を更新しました。"
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "レビュー「#{@post.name}」を削除しました。"
  end

  def create
    @post = Post.new(post_params)
    
    if params[:back].present?
      render :new
      return
    end

    if @post.save
      redirect_to @post, notice: "レビュー「#{@post.name}を登録しました。」"
    else
      render :new
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:name, :description, :image)
  end
  
  def set_post
    @post = Post.find(params[:id])
  end
end
