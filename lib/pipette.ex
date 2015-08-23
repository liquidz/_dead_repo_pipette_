defmodule Pipette do
  @moduledoc """
  new_data <- pipette(data, template)
  """

  defp identity(x), do: x

  @doc """
  Render a template file with `data`.

  ## Data
  Same as `build/2`.

  ## Options
  Same as `build/2`.

  ## Examples

      iex> File.read!("test/files/hello.txt")
      "hello, <%= msg %>\\n"
      iex> Pipette.render(%{template: "test/files/hello.txt", msg: "world"}, [])
      {%{msg: "world", template: "test/files/hello.txt"}, "hello, world"}

  """
  def render(data, options) do
    pre_fn  = Dict.get(options, :pre,  &identity/1)
    post_fn = Dict.get(options, :post, &identity/1)

    data = pre_fn.(data)
    {data, data |> render |> post_fn.()}
  end

  defp render(%{template: tmpl} = data) do
    tmpl
    |> EEx.eval_file(Dict.to_list(data))
    |> String.strip
  end

  @doc """
  Build text file from `data` and write.

  ## Data
  * `:template` - Path to template file.
  * `:destination` - Write built string to `destination`.

  ## Options
  * `:pre` - Function to hook a data before rendering.
  * `:post` - Function to hook a string before writing file.

  ## Examples

      iex> File.read!("test/files/hello.txt")
      "hello, <%= msg %>\\n"
      iex> Pipette.build(%{template: "test/files/hello.txt", destination: "test/files/world.txt", msg: "world"})
      :ok
      iex> File.read!("test/files/world.txt")
      "hello, world"

  """
  def build(data, options \\ []) do
    {%{destination: dest}, body} = render(data, options)
    File.write!(dest, body)
  end
end
