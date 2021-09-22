<!--
SPDX-FileCopyrightText: 2021 Rosa Richter

SPDX-License-Identifier: MIT
-->

# HexLicenses

[![Hex.pm](https://img.shields.io/hexpm/v/hex_licenses)](https://hex.pm/packages/hex_licenses/)
[![builds.sr.ht status](https://builds.sr.ht/~cosmicrose/hex_licenses.svg)](https://builds.sr.ht/~cosmicrose/hex_licenses?)
[![liberapay goals](https://img.shields.io/liberapay/goal/rosa.svg?logo=liberapay)](https://liberapay.com/rosa)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg)](https://github.com/RichardLitt/standard-readme)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.1-4baaaa.svg)](code_of_conduct.md)

A Mix tool to fetch the licenses of your dependences.

## Installation

The package can be installed by adding `hex_licenses` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hex_licenses, "~> 0.3", only: [:dev], runtime: false}
  ]
end
```

You can also install it as an archive to have the task handy without another dependency on your project:

```sh
mix archive.install hex hex_licenses
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
The docs can be found at [https://hexdocs.pm/hex_licenses](https://hexdocs.pm/hex_licenses).

## Usage

There are a few mix tasks in this project.

`mix licenses` will print a summary of your dependencies and the status of their licenses.
License IDs defined by the package should be an identifier on the [SPDX License List](https://spdx.org/licences).

```
$ mix licenses
Dependency  Status
ex_doc      all valid
httpoison   all valid
poison      all valid
```

`mix licenses.explain` will print the dependencies that have unidentifiable licenses.
You can also pass the `--osi` flag to all these tasks in order to ensure all licenses are approved by the [Open Source Initiative](https://opensource.org).

```
$ mix licenses.explain --osi
dependency_a has 1 unsafe licenses:
 - "MIT License" is not an SPDX ID.
dependency_b has 1 unsafe licenses:
 - "WTFPL" is not OSI-approved.
```

Lastly, `mix licenses.lint` will check the package info in your own project,
and returns an error code to your shell if the ID is not found.

```
$ mix licenses.lint
This project has 1 unsafe licenses:
 - "badid" is not an SPDX ID
```

## Roadmap

- ~~Summary of dependency licenses~~
- ~~Feedback on specific license problems~~
- ~~Lint license field in current project~~
- ~~Check if license list matches all licenses in the `LICENSES` dir (as part of the [REUSE specification](https://reuse.software))~~
- ~~Split out OSI check into an `--osi` flag in case you don't care about OSI approval~~
- ~~Read dependencies directly from `mix.lock` so we have exact version numbers~~
- ~~Check `deps/` directory to read licenses directly from the `mix.exs` of dependencies~~
- Read license IDs from an `.approved-licenses` file to specify the licenses you support, and fail all others

## Similar Projects

These tools also help you deal with licenses.
Please feel free to add your own to this list!

- [`reuse`](https://reuse.software) - helps your project follow the REUSE 3.0 Specification
- [`sbom`](https://hex.pm/packages/sbom) - generates a software bill-of-materials of your dependencies in CycloneDX format

## Maintainer

This project was developed by [Rosa Richter](https://about.me/rosa.richter).
You can get in touch with her on [Keybase.io](https://keybase.io/cantido).

## Thanks

Thanks to my coworker Mark Kanof for suggesting the idea.

## Contributing

Questions and pull requests are more than welcome.
I follow Elixir's tenet of bad documentation being a bug,
so if anything is unclear, please [file an issue](https://todo.sr.ht/~cosmicrose/hex_licenses) or ask on the [mailing list]!
Ideally, my answer to your question will be in an update to the docs.

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for all the details you could ever want about helping me with this project.

Note that this project is released with a Contributor [Code of Conduct].
By participating in this project you agree to abide by its terms.

## License

MIT License

Copyright 2021 Rosa Richter

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[mailing list]: https://lists.sr.ht/~cosmicrose/hex_licenses
