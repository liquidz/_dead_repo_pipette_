defmodule Pipette do
  @moduledoc """
  new_data <- pipette(data, template)
  """

  defp identity(x), do: x

  @doc """
  Render a template file with `data`.
  Returns `{data, rendered_string}`, or `{:error, reason}` if an error occurs.

  ## Data
  Same as `build/2`.

  ## Options
  Same as `build/2`.

  ## Examples

      iex> File.read!("test/files/hello.txt")
      "hello, <%= @msg %>\\n"
      iex> Pipette.render(%{template: "test/files/hello.txt", msg: "world"}, [])
      {%{msg: "world", template: "test/files/hello.txt"}, "hello, world"}

  """
  def render(data, options) do
    pre_fn  = Dict.get(options, :pre,  &identity/1)
    post_fn = Dict.get(options, :post, &identity/1)

    data = pre_fn.(data)
    case render(data) do
      {:ok, body} -> {data, post_fn.(body)}
      error       -> error
    end
  end

  defp render(%{template: tmpl} = data) do
    case tmpl |> File.read do
      {:ok, body} -> {:ok, body |> EEx.eval_string(assigns: data) |> String.strip}
      error       -> error
    end
  end

  @doc """
  Build text file from `data` and write.
  Returns `:ok`, or `{:error, reason}` if an error occurs.

  ## Data
  * `:template` - Path to template file.
  * `:destination` - Write built string to `destination`.

  ## Options
  * `:pre` - Function to hook a data before rendering.
  * `:post` - Function to hook a string before writing file.

  ## Examples

      iex> File.read!("test/files/hello.txt")
      "hello, <%= @msg %>\\n"
      iex> Pipette.build(%{template: "test/files/hello.txt", destination: "test/files/world.txt", msg: "world"})
      :ok
      iex> File.read!("test/files/world.txt")
      "hello, world"

  """
  def build(data, options \\ []) do
    case render(data, options) do
      {%{destination: dest}, body} ->
        dir = Path.dirname(dest)
        unless File.dir?(dir) do
          File.mkdir_p!(dir)
        end
        File.write(dest, body)

      error ->
        error
    end
  end
end
