# comicinfo-comic_vine

Looks up comic details in [Comic Vine](https://comicvine.gamespot.com), for the [comicinfo](https://github.com/veganstraightedge/comicinfo) gem.

`ComicInfo::ComicVine` is a metadata source: it searches Comic Vine for an issue, and returns what Comic Vine knows about the one picked as a `ComicInfo::Issue`. See [Looking Up Details in Online Databases](https://github.com/veganstraightedge/comicinfo/blob/main/doc/metadata-sources.md).

It's the Ruby counterpart of [ComicInfoComicVine.swift](https://github.com/veganstraightedge/ComicInfoComicVine.swift).

## Installation

```ruby
gem 'comicinfo-comic_vine'
```

## Usage

```ruby
require 'comicinfo/comic_vine'

comic_vine = ComicInfo::ComicVine.new api_key: 'your API key', user_agent: 'MyApp/1.0'

issue   = ComicInfo.load 'path/to/ComicInfo.xml'
matches = comic_vine.matches issue    # best first
found   = comic_vine.issue matches[0] # after a person picks one
updated = issue.with_blanks_filled_from found
```

- `matches` needs a Series and a Number; `missing_details` says so when either is blank.
- It searches every series whose name matches, so a recent series with a common name isn't missed, and ranks the matches by series name, then cover year.
- `issue` reads the issue and its series: title, cover year and month, publisher, issue count, summary (as plain text), credits by role, characters, teams, locations, story arcs, and the issue's Comic Vine page as its web link.
- A request Comic Vine refuses raises `ComicInfo::ComicVine::HTTPError` (with its `status`), and an error Comic Vine reports, such as an invalid API key, raises `ComicInfo::ComicVine::APIError` (with its `reason`). Both are `ComicInfo::ComicVine::Error`s.

## Terms

- An API key comes with a free Comic Vine account: <https://comicvine.gamespot.com/api/>.
- Comic Vine's data is for non-commercial use only, and whatever shows it must credit and link to Comic Vine (`comic_vine.name`, `comic_vine.home_url`).
- Comic Vine refuses generic HTTP clients, so `user_agent:` must name your app.

## Development

```sh
bin/setup         # bundle install
bundle exec rake  # specs and RuboCop
```

The specs answer every request from a local server with a recorded Comic Vine response from `spec/fixtures/`, so they need no key or network.

## License

[MIT](LICENSE.md)
