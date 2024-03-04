class Api::V1::FoldersController < ApplicationController
  before_action :set_folder, only: %i[show update destroy]
  
  def index
    @folders = Folder.all
    render json: @folders, status: 200
  end

  def show
    if @folder
      render json: {**@folder.attributes.symbolize_keys, user: @folder.user}, status: 200
    else
      render json: "Folder not found"
    end
  end

  def create
    @folder = Folder.new(folders_params)
    
    if @folder.save
      render json: {**@folder.attributes.symbolize_keys, user: @folder.user}, status: 200
    else
      render json: {
        error: "Error Creating ..."
      }
    end
  end

  def update
    if @folder
      @folder.update(folders_params)
      # render json: {**@folder.attributes.symbolize_keys, user: @folder.user}, status: 200
      render json: @folder, status: 200
    else
      render json: "Folder not found"
    end
  end

  def destroy
    if @folder
      @folder.destroy
      render json: "Delete success", status: 200
    else
      render json: "Folder not found"
    end
  end
  
  private
  def set_folder
    @folder = Folder.find_by(id: params[:id])  
  end
  
  private
  def folders_params
    user = User.find_by(id: params[:user_id])
    params.require(:folder)
    .permit([
      :name,
      :path,
    ])
    .merge(user: user)
  end
end
