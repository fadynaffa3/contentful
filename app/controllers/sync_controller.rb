class SyncController < ApplicationController
  require 'net/http'

  def sync
    get_data
  end

  def reset
  end

  private

  def get_data
    uri = URI.parse("#{Contentful::Application.credentials.contentful_sync_url}?access_token=#{Contentful::Application.credentials.contentful_access_token}&initial=true")
    response = Net::HTTP.get_response(uri)
    Space.destroy_all
    data = JSON.parse(response.body)
    items = data['items']
    items.each do |item|
      Space.create(item)
    end
  end
end
