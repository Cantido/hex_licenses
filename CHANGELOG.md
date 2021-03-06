<!--
SPDX-FileCopyrightText: 2021 Rosa Richter

SPDX-License-Identifier: MIT
-->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.3] - 2021-09-22

### Fixed

- No longer crashes when a license is marked as deprecated

## [0.3.2] - 2021-09-22

### Fixed

- No longer throws a `FunctionClauseError` when the target project has a non-Hex dependency [#2].
- No longer throws a `MatchError` when the target project does not have `:package` or `:licenses` defined.

[#2]: https://github.com/Cantido/hex_licenses/issues/2

## [0.3.1] - 2021-09-19

### Fixed

- No longer throws a `Code.LoadError` when trying to find the cached licenses file [#1].

[#1]: https://github.com/Cantido/hex_licenes/issues/1

## [0.3.0] - 2021-09-14

### Added

- All tasks now accept the `--update` flag to pull down a fresh copy of the license list,
  instead of using the version checked into this repo.

### Changed

- No longer makes HTTP calls to Hex and SPDX, and instead uses locally-available information.
- `httpoison` and `poison` deps are now optional, since using `--update` is optional.

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
[0.3.3]: https://git.sr.ht/~cosmicrose/hex_licenses/refs/v0.3.3
[0.3.2]: https://git.sr.ht/~cosmicrose/hex_licenses/refs/v0.3.2
[0.3.1]: https://git.sr.ht/~cosmicrose/hex_licenses/refs/v0.3.1
[0.3.0]: https://git.sr.ht/~cosmicrose/hex_licenses/refs/v0.3.0
[0.2.0]: https://git.sr.ht/~cosmicrose/hex_licenses/refs/v0.2.0
[0.1.0]: https://git.sr.ht/~cosmicrose/hex_licenses/refs/v0.1.0
