<!--
SPDX-FileCopyrightText: 2021 Rosa Richter

SPDX-License-Identifier: MIT
-->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2021-09-11

### Added

- `mix licenses.lint` now accepts the `--reuse` for if you are following the [REUSE specification](https://reuse.software)
  and you want to check if your declared licenes match those in the `LICENSES/` directory.

### Changed

- All tasks no longer return error codes when licenses are not OSI-approved.
  That functionality now requires the `--osi` flag to be provided.

## [0.1.0] - 2021-09-10

### Added

- `mix licenses` - Summarize dependency licenses
- `mix licenses.explain` - Show unrecognized and non-approved licenses
- `mix licenses.lint` - Ensure a project has recognized license identifiers


[Unreleased]: https://git.sr.ht/~cosmicrose/hex_licenses/log
[0.2.0]: https://git.sr.ht/~cosmicrose/hex_licenses/refs/v0.2.0
[0.1.0]: https://git.sr.ht/~cosmicrose/hex_licenses/refs/v0.1.0
