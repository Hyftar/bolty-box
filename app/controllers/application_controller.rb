class ApplicationController < ActionController::Base
  respond_to :html, :json
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  def redirect_unless_admin
    return if current_user.admin?
    flash[:alert] = 'Only admins can do that'
    redirect_to root_path
  end
end
