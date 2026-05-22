# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.2.0] - 2026-05-21

### Added
- Test recipient mapping file (`test/test-recipient-mapping.json`) for tracking test data
- 15 new political example emails from real-world samples

### Changed
- Updated all test email examples with unique recipient names and ProtonMail addresses

### Removed
- Old timestamped test email files

## [2.1.0] - 2026-05-21

### Changed
- Added @ prefix to political campaign language patterns for better specificity (standwith*, winbackthe*, defendthe*, takebackthe*)

## [2.0.0] - 2026-05-09

### Changed
- Removed overly broad patterns (support*, team*, elect*, defeat*)
- Separated into reject vs fileinto actions
- Moved election year patterns to Tier 2

[Unreleased]: https://github.com/bencouture/bens-political-spam-sieve/compare/v2.2.0...HEAD
[2.2.0]: https://github.com/bencouture/bens-political-spam-sieve/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/bencouture/bens-political-spam-sieve/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/bencouture/bens-political-spam-sieve/releases/tag/v2.0.0
