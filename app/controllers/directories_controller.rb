class DirectoriesController < ApplicationController
  before_action :set_user_directories, only: [:index]
  before_action :set_share_directories, only: [:share]

  before_action :set_parent_directory_id, only: [:new]

  before_action :set_directory, only: %i[show edit update destroy]
  before_action :set_add_to_share_directory, only: %i[add_to_share_new add_to_share_create]

  before_action :set_children_directories, only: %i[show]
  before_action :can_user_browse?, only: %i[show]
  before_action :can_user_edit?, only: %i[edit update destroy add_to_share_new add_to_share_create]

  # GET /directories
  # GET /directories.json
  def index; end

  def share; end

  def add_to_share_new
    # HACK: A bit hacky (non-elegant) way to do things.. but it works.
    @shared_users = User.where(id: @directory.shared_with)
    @other_users = User.where.not(id: @shared_users + [@directory.owner])
  end

  def add_to_share_create
    add_to_share_params # Uncertain if this actually does anything..
    @user = User.find(params[:user_id])
    respond_to do |format|
      if params[:share] == 't'
        @directory.shared_with << @user
        format.html { redirect_to directory_add_to_share_url(@directory), notice: "Shared with #{@user.full_name} successfully." }
      else
        @directory.shared_with.delete(@user)
        format.html { redirect_to directory_add_to_share_url(@directory), notice: "Unshared with #{@user.full_name} successfully." }
      end
    end
  end

  # GET /directories/1
  # GET /directories/1.json
  def show; end

  # GET /directories/new
  def new
    @directory = Directory.new
    @parent_directory = params[:directory]
  end

  # GET /directories/1/edit
  def edit; end

  # POST /directories
  # POST /directories.json
  def create
    @directory = Directory.new(directory_params)

    respond_to do |format|
      if @directory.save
        format.html { redirect_to @directory, notice: 'Directory was successfully created.' }
        format.json { render :show, status: :created, location: @directory }
      else
        format.html { render :new }
        format.json { render json: @directory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /directories/1
  # PATCH/PUT /directories/1.json
  def update
    respond_to do |format|
      if @directory.update(directory_params)
        format.html { redirect_to @directory, notice: 'Directory was successfully updated.' }
        format.json { render :show, status: :ok, location: @directory }
      else
        format.html { render :edit }
        format.json { render json: @directory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /directories/1
  # DELETE /directories/1.json
  def destroy
    @directory.destroy
    respond_to do |format|
      format.html { redirect_to directories_url, notice: 'Directory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_share_directories
    @directories =
      if current_user.admin?
        Directory.where(parent: nil)
      else
        Directory.find_by_sql("
          SELECT *
          FROM directories
          WHERE
            directory_id IS NULL AND
            (
              public = 't' OR
              user_id = #{current_user.id} OR
              id IN
              (
                SELECT directory_id
                FROM directories_users
                WHERE user_id = #{current_user.id}
              )
            )
        ")
      end
  end

  def set_user_directories
    @directories = Directory.where(user: current_user, parent: nil)
  end

  def set_parent_directory_id
    @parent_directory_id = params[:parent_id]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_directory
    @directory = Directory.find(params[:id])
  end

  def set_add_to_share_directory
    @directory = Directory.find(params[:directory_id])
  end

  def add_to_share_params
    params.require(:user_id)
    params.permit(:share)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def directory_params
    params.require(:directory).permit(:name, :public, :user_id, :directory_id)
  end

  # Must be ran after set_directory
  def set_children_directories
    @directories = @directory.children_shared_with(current_user)
  end

  def can_user_browse?
    redirect_to root_path, alert: 'Unauthorized' unless current_user.allowed_to_browse?(@directory)
  end

  def can_user_edit?
    redirect_to root_path, alert: 'Unauthorized' unless current_user.owner?(@directory)
  end
end
