require 'comicinfo'
require_relative 'comic_vine/version'

module ComicInfo
  # Looks up comic details in Comic Vine, https://comicvine.gamespot.com
  #
  #   comic_vine = ComicInfo::ComicVine.new api_key: key, user_agent: 'MyApp/1.0'
  #   matches    = comic_vine.matches issue
  #   found      = comic_vine.issue matches.first
  #   updated    = issue.with_blanks_filled_from found
  #
  # Comic Vine's terms: non-commercial use only, and whatever shows its data links back to it.
  # An API key comes with a free account: https://comicvine.gamespot.com/api/
  class ComicVine
    BASE_URL = 'https://comicvine.gamespot.com/api/'.freeze

    # - api_key: the account's Comic Vine API key
    # - user_agent: names the app, such as "MyApp/1.0". Comic Vine refuses generic HTTP clients
    # - base_url: where the API is, for testing against a server of your own
    def initialize api_key:, user_agent:, base_url: BASE_URL
      @api_key    = api_key
      @base_url   = base_url
      @user_agent = user_agent
    end

    def name     = 'Comic Vine'
    def home_url = 'https://comicvine.gamespot.com/'
  end
end
