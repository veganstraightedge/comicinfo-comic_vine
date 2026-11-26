RSpec.describe ComicInfo::ComicVine do
  subject(:comic_vine) do
    described_class.new api_key:    ComicVineServer::API_KEY,
                        base_url:   RSpec.configuration.comic_vine_server.base_url,
                        user_agent: ComicVineServer::USER_AGENT
  end

  let(:issue) { ComicInfo.load fixture_path('futuristic_tales_1.xml') }

  it 'has a version number' do
    expect(ComicInfo::ComicVine::VERSION).not_to be_nil
  end

  it 'is credited as Comic Vine' do
    expect(comic_vine.name).to eq 'Comic Vine'
    expect(comic_vine.home_url).to eq 'https://comicvine.gamespot.com/'
  end

  describe '#missing_details' do
    it 'is nothing when the issue has a series and a number' do
      expect(comic_vine.missing_details(issue)).to be_nil
    end

    it 'asks for a series and a number when either is blank' do
      no_series = ComicInfo.load fixture_path('number_only.xml')
      no_number = ComicInfo.load fixture_path('series_only.xml')
      blank     = ComicInfo.load fixture_path('blank_number.xml')

      expect(comic_vine.missing_details(no_series)).to eq 'Comic Vine needs a Series and a Number to search for.'
      expect(comic_vine.missing_details(no_number)).to eq 'Comic Vine needs a Series and a Number to search for.'
      expect(comic_vine.missing_details(blank)).to eq 'Comic Vine needs a Series and a Number to search for.'
    end
  end

  describe '#matches' do
    it 'is the numbered issue in every found series, once' do
      matches = comic_vine.matches issue

      expect(matches.length).to eq 1
      match = matches.first
      expect(match).to be_a ComicInfo::Match
      expect(match.id).to eq '140529'
      expect(match.heading).to eq "Cory Doctorow's Futuristic Tales of the Here and Now (2007) #1"
      expect(match.series).to eq "Cory Doctorow's Futuristic Tales of the Here and Now"
      expect(match.number).to eq '1'
      expect(match.title).to eq "Anda's Game"
      expect(match.cover_date).to eq '2007-10-01'
      expect(match.details).to eq 'IDW Publishing · Cover date 2007-10-01'
      expect(match.site_url).to eq 'https://comicvine.gamespot.com/cory-doctorows-futuristic-tales-of-the-here-and-no/4000-140529/'
    end
  end
end
