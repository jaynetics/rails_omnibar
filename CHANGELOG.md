# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- using arrow keys wraps around the list

### Fixed

- restored support for clicking result items

## [1.5.1] - 2024-01-25

### Fixed

- help entries for search items with custom finders

## [1.5.0] - 2024-01-25

### Added

- `RailsOmnibar::add_webadmin_items`

## [1.4.0] - 2023-01-31

### Added

- `RailsOmnibar::auth=` for fine-grained authorization
- `RailsOmnibar::html_url` for rendering in SPAs

### Fixed

- double execution of commands / queries

## [1.3.2] - 2023-01-27

### Fixed

- long results overflowing

## [1.3.1] - 2023-01-27

### Fixed

- hotkeys (e.g. CMD+K) were not properly overridden in firefox

## [1.3.0] - 2023-01-27

### Added

- result icons
- suggested results feature

## [1.2.0] - 2023-01-23

### Added

- highlighting for matching letters in fuzzy search

### Fixed

- duplicate items on rails' hot reload
- lack of pre-selected result in some cases

## [1.1.0] - 2023-01-23

### Added

- support for returning an Array of items from `itemizer:`

## [1.0.0] - 2023-01-22

Initial release.
