require 'nokogiri'

module ComicInfo
  class ComicVine
    # An HTML fragment, such as an issue's description, as plain text with its whitespace collapsed
    class PlainText
      # Elements whose text reads as separate from what's around them
      BLOCK_ELEMENTS = %w[
        address article aside blockquote br dd div dl dt figcaption figure footer
        h1 h2 h3 h4 h5 h6 header hr li main nav ol p pre section table td th tr ul
      ].freeze

      def initialize html
        @html = html.to_s
      end

      # The text, or nil when there is none
      def text
        fragment = Nokogiri::HTML5.fragment @html
        fragment.css(*BLOCK_ELEMENTS).each { it.add_next_sibling Nokogiri::XML::Text.new(' ', fragment.document) }
        text = fragment.text.split.join ' '

        text unless text.empty?
      end
    end
  end
end
