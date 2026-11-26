require 'comicinfo'
require_relative 'comic_vine/client'
require_relative 'comic_vine/errors'
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
      @client = Client.new(api_key:, base_url:, user_agent:)
    end

    def name     = 'Comic Vine'
    def home_url = 'https://comicvine.gamespot.com/'

    # What the issue still needs before it can be searched for, or nil
    def missing_details issue
      return if present(issue.series) && present(issue.number)

      'Comic Vine needs a Series and a Number to search for.'
    end

    # The issues with the issue's number in every series whose name matches its series, best first.
    #
    # Comic Vine's search finds the best few series, and its list finds up to 100 more, newest first,
    # so a recent series of a common name isn't missed.
    def matches issue
      searched = client.search_volumes issue.series
      listed   = client.list_volumes issue.series

      volumes_by_id = (searched + listed).uniq { it[:id] }.to_h { [it[:id], it] }
      searched_ids  = searched.map { it[:id] }.uniq
      listed_ids    = listed.map { it[:id] }.uniq - searched_ids

      # The issues list stops at 100 results, so the search's few, best series are asked about apart
      # from the list's many, and first.
      found = [searched_ids, listed_ids].reject(&:empty?).flat_map do |volume_ids|
        client.find_issues number: issue.number, volume_ids:
      end

      matches = found.uniq { it[:id] }.map do |found_issue|
        volume = volumes_by_id[found_issue.dig(:volume, :id)]

        match_for found_issue, volume:
      end

      issue.rank matches
    end

    private

    attr_reader :client

    # One issue from the issues list, in its volume, as a match
    def match_for found, volume:
      series      = found.dig(:volume, :name) || volume&.dig(:name) || ''
      start_year  = present volume&.dig(:start_year)
      year        = start_year ? " (#{start_year})" : ''
      cover_date  = "Cover date #{present(found[:cover_date]) || 'unknown'}"
      publisher   = present volume&.dig(:publisher, :name)
      details     = [publisher, cover_date].compact.join ' · '

      Match.new cover_date: found[:cover_date],
                details:,
                heading:    "#{series}#{year} ##{found[:issue_number]}",
                id:         found[:id].to_s,
                number:     found[:issue_number],
                series:,
                site_url:   found[:site_detail_url],
                title:      present(found[:name])
    end

    # The text, trimmed, or nil when it's blank
    def present text
      trimmed = text.to_s.strip

      trimmed unless trimmed.empty?
    end
  end
end
