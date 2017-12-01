# frozen_string_literal: true

require 'byebug'

class RegistrationsController < Devise::RegistrationsController
  before_action :redirect_unless_admin, only: %i[new create edit update]
  skip_before_action :require_no_authentication

  private

  def sign_up_params
    params.require(:user).permit(:given_name, :last_name, :admin, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:given_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
end
