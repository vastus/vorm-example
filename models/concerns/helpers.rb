module Helpers
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def check_ownership!
    if params[:id] != session[:user_id].to_s
      redirect to(url("/login"))
    end
  end

  def admin?
    current_user && current_user.role?(:admin)
  end
end

