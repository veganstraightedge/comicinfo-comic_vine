require 'webrick'

# Answers Comic Vine API requests with the recorded responses in spec/fixtures, as Comic Vine would.
#
# A request without the test key gets Comic Vine's "Invalid API Key" response, and one without the
# test User-Agent is refused, so a passing spec shows both are sent.
class ComicVineServer
  API_KEY    = 'test-key'.freeze
  USER_AGENT = 'ComicInfoComicVineSpecs/1.0'.freeze

  # The fixture file each API path is answered with
  FIXTURES = {
    '/api/issue/4000-140529/' => 'issue_detail.json',
    '/api/issues/'            => 'issues_list.json',
    '/api/search/'            => 'search_volumes.json',
    '/api/volume/4050-23437/' => 'volume_detail.json',
    '/api/volumes/'           => 'volumes_list.json'
  }.freeze

  def initialize fixtures_directory:
    @fixtures_directory = fixtures_directory
    @server = WEBrick::HTTPServer.new AccessLog:   [],
                                      BindAddress: '127.0.0.1',
                                      Logger:      WEBrick::Log.new(File::NULL),
                                      Port:        0
    @server.mount_proc('/') { |request, response| answer request, response }
  end

  def base_url = "http://127.0.0.1:#{port}/api/"

  def start
    @thread = Thread.new { @server.start }
  end

  def stop
    @server.shutdown
    @thread.join
  end

  private

  def port = @server.listeners.first.addr[1]

  def answer request, response
    return refuse response, status: 403 unless request['User-Agent'] == USER_AGENT
    return respond response, fixture: 'invalid_key.json' unless authorized? request

    fixture = FIXTURES[request.path]
    return refuse response, status: 404 unless fixture

    respond response, fixture:
  end

  def authorized?(request) = request.query['format'] == 'json' && request.query['api_key'] == API_KEY

  def refuse response, status:
    response.status = status
  end

  def respond response, fixture:
    path = File.join @fixtures_directory, fixture

    response.status          = 200
    response['Content-Type'] = 'application/json'
    response.body            = File.read path
  end
end
