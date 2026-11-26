module ComicInfo
  class ComicVine
    # Why a Comic Vine request failed
    class Error < ComicInfo::Error; end

    # Comic Vine answered with an HTTP error status, such as 403 or 503
    class HTTPError < Error
      attr_reader :status

      def initialize status
        @status = status
        super("Comic Vine answered with HTTP status #{status}.")
      end
    end

    # Comic Vine answered with an error of its own, such as "Invalid API Key"
    class APIError < Error
      attr_reader :reason

      def initialize reason
        @reason = reason
        super("Comic Vine said: #{reason}.")
      end
    end
  end
end
