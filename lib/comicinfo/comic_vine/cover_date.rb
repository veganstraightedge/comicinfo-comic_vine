module ComicInfo
  class ComicVine
    # A cover date such as "2007-10-01", as a year and month.
    #
    # The day is left out: Comic Vine writes the 1st when it only knows the month.
    class CoverDate
      def initialize text
        @parts = text.to_s.split '-'
      end

      # The year, or nil when there isn't one
      def year
        year = Integer @parts[0], 10, exception: false if @parts.length >= 2

        year if year&.between? 1000, 9999
      end

      # The month, 1 to 12, or nil when there isn't one
      def month
        month = Integer @parts[1], 10, exception: false if @parts.length >= 2

        month if month&.between? 1, 12
      end
    end
  end
end
