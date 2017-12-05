class DirectoriesController < ApplicationController
  before_action :set_user_directories, only: [:index]
  before_action :set_share_directories, only: [:share]

  before_action :set_parent_directory_id, only: [:new]

  before_action :set_directory, only: %i[show edit update destroy]
  before_action :set_children_directories, only: %i[show]
  before_action :can_user_browse?, only: %i[show]
  before_action :can_user_edit?, only: %i[edit update destroy]

  # GET /directories
  # GET /directories.json
  def index; end

  def share; end

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
        dir_shared_with_user =
          ActiveRecord::Base
          .connection
          .execute(
            "SELECT directory_id
            FROM directories_users
            WHERE user_id=#{current_user.id}"
          ).map { |x| x['directory_id'] }
        Directory
          .where(user: current_user, parent: nil)
          .or(Directory.where(public: true, parent: nil))
          .or(Directory.where(id: dir_shared_with_user, parent: nil))
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
