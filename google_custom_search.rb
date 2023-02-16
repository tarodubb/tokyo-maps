require 'google/apis/customsearch_v1'
require 'googleauth'

class GoogleCustomSearch
  def initialize(api_key, cse_id)
    @api_key = api_key
    @cse_id = cse_id
    @service = Google::Apis::CustomsearchV1::CustomsearchService.new
    @service.key = api_key
  end

  def find_image(query)
    results = @service.list_cses(q: query, cx: @cse_id, search_type: 'image')

    if results.items.present?
      results.items.first.link
    else
      nil
    end
  end
end
