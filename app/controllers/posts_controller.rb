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
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
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
    # @post = Post.new(post_params)
    @post = Post.new(post_params, user_id: @current_user.id)
    # @post = Post.new(description: params[:description], user_id: @current_user.id)

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

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to post_path
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
