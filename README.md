Pipette
=======

[![Build Status](https://travis-ci.org/liquidz/pipette.svg?branch=master)](https://travis-ci.org/liquidz/pipette)
[![Hex.pm](https://img.shields.io/hexpm/v/pipette.svg)](https://hex.pm/packages/pipette)

## Installation

* mix.exs
```elixir
def deps do
  [{:pipette, "~> 0.0.1"}]
end
```

## Usage

* build
```elixir
iex> File.read!("hello.txt")
"hello, <%= msg %>\n"
iex> Pipette.build(%{template: "hello.txt", destination: "world.txt", msg: "world"})
:ok
iex> File.read!("world.txt")
"hello, world"
```
* pre hook
```elixir
iex> data = %{template: "hello.txt", destination: "world.txt", msg: "world"}
iex> Pipette.build(data, pre: &Dict.put(&1, :msg, "pipette"))
:ok
iex> File.read!("world.txt")
"hello, pipette"
```
* post hook
```elixir
iex> data = %{template: "hello.txt", destination: "world.txt", msg: "world"}
iex> Pipette.build(data, post: &("[#{&1}]")
:ok
iex> File.read!("world.txt")
"[hello, world]"
```

## License

Copyright (C) 2015 Masashi Iizuka([@uochan](http://twitter.com/uochan))

Distributed under the MIT License.
