class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required
  skip_before_action :login_required, only: [:new, :about, :create], raise: false
  before_action :current_user

  def about
    render about_path
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to new_user_path unless current_user
  end
end
