require 'nokogiri'
require_relative 'cover_date'
require_relative 'credits'
require_relative 'plain_text'

module ComicInfo
  class ComicVine
    # A Comic Vine issue and its volume, as a ComicInfo::Issue.
    #
    # The issue is built from ComicInfo XML with only the fields Comic Vine knows, so
    # ComicInfo::Issue#with_blanks_filled_from keeps what a comic already has.
    class FoundIssue
      # - issue: Comic Vine's issue detail
      # - volume: Comic Vine's detail for the issue's volume
      def initialize issue:, volume:
        @issue  = issue
        @volume = volume
      end

      def to_issue
        ComicInfo.load(xml)
                 .with_characters(names(@issue[:character_credits]))
                 .with_locations(names(@issue[:location_credits]))
                 .with_teams(names(@issue[:team_credits]))
      end

      private

      # ComicInfo XML with every field Comic Vine knows, by element name
      def xml
        document = Nokogiri::XML::Document.new
        root     = document.create_element 'ComicInfo'

        fields.each { |element, value| root.add_child document.create_element(element, value.to_s) }
        document.root = root

        document.to_xml
      end

      def fields
        credits    = Credits.new @issue[:person_credits].to_a
        cover_date = CoverDate.new @issue[:cover_date]
        summary    = PlainText.new(@issue[:description]).text || PlainText.new(@issue[:deck]).text

        {
          'Colorist'    => credits.names('colorist', 'colourist'),
          'Count'       => count,
          'CoverArtist' => credits.names('cover'),
          'Editor'      => credits.names('editor'),
          'Inker'       => credits.names('inker', 'artist'),
          'Letterer'    => credits.names('letterer'),
          'Month'       => cover_date.month,
          'Number'      => present(@issue[:issue_number]),
          'Penciller'   => credits.names('penciler', 'penciller', 'artist'),
          'Publisher'   => present(@volume.dig(:publisher, :name)),
          'Series'      => present(@volume[:name] || @issue.dig(:volume, :name)),
          'StoryArc'    => present(names(@issue[:story_arc_credits]).join(', ')),
          'Summary'     => summary,
          'Title'       => present(@issue[:name]),
          'Web'         => present(@issue[:site_detail_url]),
          'Writer'      => credits.names('writer'),
          'Year'        => cover_date.year
        }.compact
      end

      # The volume's issue count, or nil when Comic Vine doesn't know it
      def count
        count = @volume[:count_of_issues]

        count if count.to_i.positive?
      end

      # The names of the characters, teams, locations, or story arcs Comic Vine credits
      def names(references) = references.to_a.filter_map { it[:name] }

      # The text, trimmed, or nil when it's blank
      def present text
        trimmed = text.to_s.strip

        trimmed unless trimmed.empty?
      end
    end
  end
end
