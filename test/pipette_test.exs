defmodule PipetteTest do
  use ExUnit.Case
  import Mock
  doctest Pipette

  @test_tmpl "hello, <%= msg %>"
  @test_data %{
    template:    "hello.txt",
    destination: "world.txt",
    msg:         "world"
  }

  defp mock_read(expected) do
    [read!: fn _ -> expected end]
  end
  defp mock_write(expected) do
    [write!: fn (path, body) ->
        case expected do
          :path -> path
          :body -> body
          _     -> expected
        end
    end]
  end

  test_with_mock "simple render", File, [:passthrough], mock_read(@test_tmpl) do
    res = Pipette.render(@test_data, [])
    assert res == {@test_data, "hello, world"}
  end

  test_with_mock "render with pre", File, [:passthrough], mock_read(@test_tmpl) do
    pre = &Dict.put(&1, :msg, "pipette")
    res = Pipette.render(@test_data, pre: pre)
    assert res == {pre.(@test_data), "hello, pipette"}
  end

  test_with_mock "render with post", File, [:passthrough], mock_read(@test_tmpl) do
    post = &("[#{&1}]")
    res  = Pipette.render(@test_data, post: post)
    assert res == {@test_data, post.("hello, world")}
  end

  test_with_mock "simple build",
  File, [:passthrough], mock_read(@test_tmpl) ++ mock_write(:ok) do
    res = Pipette.build(@test_data)
    assert res == :ok
  end

  test_with_mock "build with pre",
  File, [:passthrough], mock_read(@test_tmpl) ++ mock_write(:path) do
    new_dest = "foo.txt"
    res      = Pipette.build(@test_data, pre: &Dict.put(&1, :destination, new_dest))
    assert res == new_dest
  end

  test_with_mock "build with post",
  File, [:passthrough], mock_read(@test_tmpl) ++ mock_write(:body) do
    post = &("[#{&1}]")
    res  = Pipette.build(@test_data, post: post)
    assert res == "[hello, world]"
  end
end
