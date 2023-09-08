# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Support DevContainers
- Test against Ruby 3.2
### Changed
- Use Python 3.8 for codespell
- Bump rubocop-shopify to v2.14
- Bump changelog-enforcer to v3
### Fixed
- Fixes rubocop lint
- CI/CD workflow

## [1.0.0-rc.10] - 2022-05-26
### Changed
- Improved caching of requests to Auth0.

## [1.0.0-rc.9] - 2022-05-25
### Fixed
- Loading user's permissions above 100 limit.

## [1.0.0-rc.8] - 2022-05-19
### Fixed
- Match user identity when retrieving user permission.

## [1.0.0-rc.7] - 2022-05-19
### Fixed
- Release RC7

## [1.0.0-rc.6] - 2022-05-19
### Added
- Cache scopes

## [1.0.0-rc.5] - 2022-03-30
### Fixed
- Include missing controllers on build gem

## [1.0.0-rc.4] - 2022-03-30
### Fixed
- Ensure to keep auth0_id updated.
- Load user's permissions using email instead of auth0_id.

## [1.0.0-rc.3] - 2022-03-18
### Fixed
- Include permissions to scopes for can? and cannot?

## [1.0.0-rc.2] - 2022-03-16
### Added
- Fixes gem build

## [1.0.0-rc.1] - 2022-03-16
### Added
- Supports Bearer Authorization using Auth0 JWT & Access Tokens
- Auto create authorized user when not found
- Restrict user model to only certain email domains 
