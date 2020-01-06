class SyncController < ApplicationController

  def sync
    render json: ContentfulSyncService.new.sync
  end

  def initial_sync
    render json: ContentfulSyncService.new.initial_sync
  end
end
