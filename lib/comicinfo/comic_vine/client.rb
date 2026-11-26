require 'json'
require 'net/http'
require 'uri'
require_relative 'errors'

module ComicInfo
  class ComicVine
    # Calls the Comic Vine API with one API key.
    #
    # Results are Comic Vine's JSON, parsed with symbol keys. See
    # https://comicvine.gamespot.com/api/documentation
    class Client
      # The fields asked for whenever a volume is read
      VOLUME_FIELDS = 'count_of_issues,id,name,publisher,site_detail_url,start_year'.freeze

      # The most volumes one list request returns
      VOLUME_LIST_LIMIT = 100

      def initialize api_key:, base_url:, user_agent:
        @api_key    = api_key
        @base_url   = base_url
        @user_agent = user_agent
      end

      # The series whose names match query, best first; Comic Vine stops at 10
      def search_volumes query
        get 'search/', field_list: VOLUME_FIELDS,
                       query:,
                       resources:  'volume'
      end

      # Up to 100 volumes whose names contain name, newest first.
      #
      # Wider than #search_volumes, which can leave a recent series of a common name ("Archie") out.
      def list_volumes name
        # The filter syntax separates filters with commas, so a name's own commas are left out of it.
        filter_name = name.tr ',', ' '

        get 'volumes/', field_list: VOLUME_FIELDS,
                        filter:     "name:#{filter_name}",
                        limit:      VOLUME_LIST_LIMIT,
                        sort:       'start_year:desc'
      end

      # The issues numbered number in any of the volumes
      def find_issues number:, volume_ids:
        volumes = volume_ids.join '|'

        get 'issues/', field_list: 'cover_date,id,issue_number,name,site_detail_url,volume',
                       filter:     "volume:#{volumes},issue_number:#{number}"
      end

      # One issue, credits and all
      def issue(id) = get "issue/4000-#{id}/"

      # One volume: its publisher, start year and issue count
      def volume(id) = get "volume/4050-#{id}/", field_list: VOLUME_FIELDS

      private

      # Calls one API resource and returns its results
      def get path, parameters = {}
        uri       = URI.join @base_url, path
        uri.query = URI.encode_www_form parameters.merge(api_key: @api_key, format: 'json').sort

        response = Net::HTTP.get_response uri, 'User-Agent' => @user_agent
        raise HTTPError, response.code.to_i unless response.is_a? Net::HTTPOK

        body = JSON.parse response.body, symbolize_names: true
        # The status is read first: an error response's results are an empty list, whatever was asked for.
        raise APIError, body[:error] unless body[:status_code] == 1

        body[:results]
      end
    end
  end
end
