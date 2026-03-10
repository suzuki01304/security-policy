# Changelog

All notable changes to this project will be documented in this file.

## [2.1.0] - 2026-03-10

### Added
- Memory classification system for credential handling
- Four-category classification: Preferences | Facts | Decisions | Lessons
- Enhanced credential reference patterns to prevent accidental exposure
- Storage guidelines for secure credential management

### Changed
- Improved credential handling rules with file permission requirements (600 for files, 700 for directories)
- Enhanced security audit instructions with classification-based approach
- Better documentation of credential storage locations

### Inspiration
This update was inspired by the [memory-hygiene](https://github.com/xdylanbaker/memory-hygiene) skill's vector database classification system. While memory-hygiene is designed for LanceDB vector storage, we adapted its classification principles to enhance our security policy's credential handling and memory management guidelines.

## [2.0.1] - 2026-03-10

### Changed
- Enhanced credential handling rules with permission requirements
- Added detailed storage locations and permission audit instructions

## [2.0.0] - 2026-03-10

### Changed
- Refactored to skill-creator spec v2.0.0
- Proper YAML frontmatter structure
- Organized scripts/ and references/ directories
- Complete anonymization of personal information

## [1.0.0] - Initial Release

### Added
- Initial security policy documentation
- Basic credential handling guidelines
