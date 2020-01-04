class SyncController < ApplicationController

  def sync
    render json: ContentfulSyncService.new.initial_sync
  end

  def reset
  end
end
