class SpacesController < ApplicationController
  before_action :set_space, only: [:show, :update, :destroy]

  # GET /spaces
  def index
    skip = params[:skip].try(:to_i) || 0
    limit = params[:limit].try(:to_i) || 100
    @spaces = Space.order_by('createdAt': :asc).limit(limit).offset(skip)

    response_body = { sys: { type: 'Array' }, total: @spaces.count, skip: skip, limit: limit, items: @spaces }

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
