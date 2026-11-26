module ComicInfo
  class ComicVine
    # The people credited on an issue, by lowercase role.
    #
    # Comic Vine gives each person a comma-separated list of roles, such as "artist, writer".
    class Credits
      def initialize people
        @names_by_role = Hash.new { |hash, role| hash[role] = [] }

        people.each do |person|
          person[:role].to_s.split(',').each do |role|
            @names_by_role[role.strip.downcase] << person[:name]
          end
        end
      end

      # Everyone credited with any of the roles, each once, in order, joined with commas; nil when no one is
      def names *roles
        people = roles.flat_map { @names_by_role.fetch it, [] }.uniq

        people.join ', ' unless people.empty?
      end
    end
  end
end
