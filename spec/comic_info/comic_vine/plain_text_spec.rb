RSpec.describe ComicInfo::ComicVine::PlainText do
  it 'is the text without its markup, whitespace collapsed' do
    plain_text = described_class.new "<i>For  12-year-old</i>\n<b>Anda</b>"

    expect(plain_text.text).to eq 'For 12-year-old Anda'
  end

  it 'keeps blocks apart' do
    plain_text = described_class.new '<h2>Story</h2><p>One.</p><ul><li>Two</li><li>Three</li></ul>Four<br>Five'

    expect(plain_text.text).to eq 'Story One. Two Three Four Five'
  end

  it 'keeps inline markup inside a word together' do
    plain_text = described_class.new '<p>Fahren<em>heit</em>s</p>'

    expect(plain_text.text).to eq 'Fahrenheits'
  end

  it 'is nothing when there is no text' do
    expect(described_class.new(nil).text).to be_nil
    expect(described_class.new('<p> </p>').text).to be_nil
  end
end
