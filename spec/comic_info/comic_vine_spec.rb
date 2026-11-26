RSpec.describe ComicInfo::ComicVine do
  subject(:comic_vine) { described_class.new api_key: 'test-key', user_agent: 'ComicInfoComicVineSpecs/1.0' }

  it 'has a version number' do
    expect(ComicInfo::ComicVine::VERSION).not_to be_nil
  end

  it 'is credited as Comic Vine' do
    expect(comic_vine.name).to eq 'Comic Vine'
    expect(comic_vine.home_url).to eq 'https://comicvine.gamespot.com/'
  end
end
