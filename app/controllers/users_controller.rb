class UsersController < ApplicationController
  before_action :set_user_assets, only: [:show]

  def show; end

  private

  def set_user_assets
    @assets = current_user.assets_owned
  end
end
