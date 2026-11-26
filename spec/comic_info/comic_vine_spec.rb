RSpec.describe ComicInfo::ComicVine do
  subject(:comic_vine) { described_class.new api_key: 'test-key', user_agent: 'ComicInfoComicVineSpecs/1.0' }

  it 'has a version number' do
    expect(ComicInfo::ComicVine::VERSION).not_to be_nil
  end

  it 'is credited as Comic Vine' do
    expect(comic_vine.name).to eq 'Comic Vine'
    expect(comic_vine.home_url).to eq 'https://comicvine.gamespot.com/'
  end

  describe '#missing_details' do
    it 'is nothing when the issue has a series and a number' do
      issue = ComicInfo.load fixture_path('futuristic_tales_1.xml')

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
end
