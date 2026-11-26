# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-11-26

### Added
- `ComicInfo::ComicVine`, a metadata source for [Comic Vine](https://comicvine.gamespot.com). `matches(issue)` finds the issue with the comic's number in every series whose name matches, ranked by series name then cover year. `issue(match)` reads the picked issue and its series into a `ComicInfo::Issue`: title, cover year and month, publisher, issue count, summary as plain text, credits by role, characters, teams, locations, story arcs, and its Comic Vine page
- `ComicInfo::ComicVine::HTTPError` and `ComicInfo::ComicVine::APIError`: an HTTP error status, or an error Comic Vine reports itself, such as an invalid API key
