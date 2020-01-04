class ContentfulSyncService
  require 'net/http'

  def initial_sync(next_page_url = nil)
    uri      = URI.parse(current_url(next_page_url))
    response = Net::HTTP.get_response(uri)
    if response.code == '200'
      SyncUrl.destroy_all
      Space.destroy_all unless next_page_url.present?
      create_new_spaces(JSON.parse(response.body))
    else
      return false
    end
  end

  private

  def current_url(next_page_url)
    url = if next_page_url.present?
            next_page_url + "&access_token=#{Contentful::Application.credentials.contentful_access_token}"
          else
            "#{Contentful::Application.credentials.contentful_sync_url}?access_token=#{Contentful::Application.credentials.contentful_access_token}&initial=true"
          end
  end

  def create_new_spaces(data)
    items         = data['items']
    next_page_url = data['nextPageUrl']
    items.each do |item|
      Space.create(url: item)
    end

    if next_page_url.present?
      get_data(next_page_url)
    else
      SyncUrl.create(url: data['nextSyncUrl'])
      return true
    end
  end
end
