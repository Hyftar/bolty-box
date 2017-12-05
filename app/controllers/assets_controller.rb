class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy, :download]
  before_action :can_user_use?, only: [:show, :download]
  before_action :can_user_edit?, only: [:edit, :update, :destroy]
  before_action :set_directory, only: [:new]

  # GET /assets
  # GET /assets.json
  def index
    @assets = Asset.all
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  def download
    send_file(
      @asset.file.path,
      filename: @asset.file_file_name,
      type: @asset.file_content_type
    )
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(asset_params)

    respond_to do |format|
      if @asset.save
        format.html { redirect_to @asset, notice: 'Asset was successfully created.' }
        format.json { render :show, status: :created, location: @asset }
      else
        format.html { render :new }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assets/1
  # PATCH/PUT /assets/1.json
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset }
      else
        format.html { render :edit }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to assets_url, notice: 'Asset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def can_user_edit?
      redirect_to root_path, alert: 'Unauthorized' unless current_user.owner?(@asset.parent)
    end

    def can_user_use?
      redirect_to root_path, alert: 'Unauthorized' unless current_user.allowed_to_browse?(@asset.parent)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Asset.find(params[:id])
    end

    def set_directory
      @directory_id = params[:directory_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.require(:asset).permit(:directory_id, :file)
    end
end
