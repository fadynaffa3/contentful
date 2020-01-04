class SpacesController < ApplicationController
  before_action :set_space, only: [:show, :update, :destroy]

  # GET /spaces
  def index
    @spaces = Space.all

    render json: @spaces
  end

  # GET /spaces/1
  def show
    render json: @space
  end

  # POST /spaces
  def create
    @space = Space.new(space_params)

    if @space.save
      render json: @space, status: :created, location: @space
    else
      render json: @space.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /spaces/1
  def update
    if @space.update(space_params)
      render json: @space
    else
      render json: @space.errors, status: :unprocessable_entity
    end
  end

  # DELETE /spaces/1
  def destroy
    @space.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space
      @space = Space.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def space_params
      params.require(:space).permit(:company_name, :description)
    end
end
