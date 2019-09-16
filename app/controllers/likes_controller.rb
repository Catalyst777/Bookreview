class LikesController < ApplicationController

  def create
    @like = Like.new(
      user_id: @current_user.id,
      post_id: params[:post_id]
    )
    @like.save
    redirect_to("/posts/#{params[:post_id]}")
  end

  def destroy
    @like = Like.find_by(
      # params_hash = post_params,
      # params_hash['user_id'] = @current_user.id,
      user_id: @current_user.id,
      post_id: params[:post_id]
    )
    @like.destroy
    redirect_to("/posts/#{params[:post_id]}")
  end

end
