class SpacesController < ApplicationController
  before_action :set_space, only: [:show, :update, :destroy]

  # GET /spaces
  def index
    @spaces = Space.all

    response_body = { sys: { type: 'Array' }, total: @spaces.count, skip: 0, limit: @spaces.count, items: @spaces }

    render json: response_body
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
