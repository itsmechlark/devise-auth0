# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
