# Changelog

All notable changes to this project will be documented in this file.

## [2.2.0] - 2026-03-10

### Added
- **Risk Classification System** inspired by dependency-auditor
  - Low Risk: Read operations, local analysis
  - Medium Risk: Configuration changes, environment variables
  - High Risk: External API calls, public publishing
  - Critical Risk: Credential leaks, system-level operations
- **Security Audit Scripts** inspired by git-secrets-scanner
  - `scripts/credential-scanner.sh` - Scan workspace for credential leaks
  - `scripts/permission-audit.sh` - Audit file permissions compliance
  - `scripts/security-report.sh` - Generate comprehensive security reports
- **Metrics & KPIs** inspired by dependency-auditor
  - Credential security score
  - Permission compliance percentage
  - Security incident response time
  - Audit coverage rate
- **Emergency Response Procedures**
  - Credential leak response workflow
  - Permission anomaly remediation
  - Security incident escalation

### Changed
- Enhanced credential handling documentation with practical examples
- Improved security policy structure with actionable guidelines
- Added configuration file templates for custom security rules

### Inspiration
This update was inspired by [dependency-auditor](https://clawhub.com/skills/dependency-auditor) and [git-secrets-scanner](https://clawhub.com/skills/git-secrets-scanner). We adapted their comprehensive audit systems, risk classification frameworks, and practical tooling approach to enhance our security policy implementation.

## [2.1.0] - 2026-03-10

### Added
- Memory classification system inspired by memory-hygiene's vector database design
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
