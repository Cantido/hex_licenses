<!--
SPDX-FileCopyrightText: 2021 Rosa Richter

SPDX-License-Identifier: MIT
-->

# HexLicenses

A Mix tool to fetch the licenses of your dependences.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hex_licenses` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hex_licenses, "~> 0.1.0", only: [:dev], runtime: false}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hex_licenses](https://hexdocs.pm/hex_licenses).

## Usage

There is one mix task in this project:

```sh
mix licenses
```

That will print a summary of your dependencies and the licenses they are offered under.

[![asciicast](https://asciinema.org/a/434908.svg)](https://asciinema.org/a/434908)

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

Copyright 2020 Rosa Richter

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
