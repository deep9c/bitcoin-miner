defmodule KVTest do
  use ExUnit.Case
  doctest KV

  test "greets the world" do
    assert KV.hello() == :world
  end
end

defmodule KVTest1 do
  use ExUnit.Case
  doctest StringGenerator

  test "test" do
    StringGenerator.loop(4)
  end
end