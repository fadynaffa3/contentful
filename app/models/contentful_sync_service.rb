class ContentfulSyncService
  require 'net/http'

  def initial_sync(next_page_url = nil)
    uri      = URI.parse(current_initial_sync_url(next_page_url))
    response = Net::HTTP.get_response(uri)
    if response.code == '200'
      SyncUrl.destroy_all
      Space.destroy_all unless next_page_url.present?
      create_new_space_entries(JSON.parse(response.body))
    else
      puts response
      return false
    end
  end

  def sync(next_page_url = nil)
    return false unless SyncUrl.last.present?

    uri      = URI.parse(current_sync_url(next_page_url))
    response = Net::HTTP.get_response(uri)
    if response.code == '200'
      update_space_entries(JSON.parse(response.body))
    else
      puts response
      return false
    end
  end

  private

  def current_initial_sync_url(next_page_url)
    url = if next_page_url.present?
            next_page_url + "&access_token=#{Contentful::Application.credentials.contentful_access_token}"
          else
            "#{Contentful::Application.credentials.contentful_sync_url}" +
              "#{Contentful::Application.credentials.contentful_space_id}" +
              "/sync?access_token=#{Contentful::Application.credentials.contentful_access_token}" +
              "&initial=true"
          end
  end

  def current_sync_url(next_page_url)
    url = (next_page_url.present? ? next_page_url : SyncUrl.last.url) + "&access_token=#{Contentful::Application.credentials.contentful_access_token}"
  end

  def create_new_space_entries(data)
    items         = data['items']
    next_page_url = data['nextPageUrl']
    items.each do |item|
      id = item['sys']['id']
      Space.create(data: item, id: id)
    end

    if next_page_url.present?
      initial_sync(next_page_url)
    else
      SyncUrl.create(url: data['nextSyncUrl'])
      return true
    end
  end

  def update_space_entries(data)
    items         = data['items']
    next_page_url = data['nextPageUrl']
    items.each do |item|
      id = item['sys']['id']
      Space.where(id: id).first_or_create.update(data: item)
    end

    if next_page_url.present?
      sync(next_page_url)
    else
      SyncUrl.create(url: data['nextSyncUrl'])
      return true
    end
  end
end
