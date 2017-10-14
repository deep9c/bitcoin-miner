defmodule KV do

  def hello do
    :world
  end
end


defmodule StringGenerator do
  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end

  def encrypt(prefix,len, counter, rand) do
    inputString = prefix <> rand <> Integer.to_string(counter)
    bitcoin = :crypto.hash(:sha256, inputString) |> Base.encode16
    # IO.puts bitcoin

    y = String.duplicate("0", len)
    if String.starts_with?(bitcoin, y) do
      IO.puts inputString <> "\t" <> bitcoin
    end
  end

  def abc(prefix, len) do
    counter=1
    rand = StringGenerator.string_of_length(8)
    loop(prefix, len, counter, rand)
  end
  
  def loop(prefix, len, counter, rand) do
    StringGenerator.encrypt(prefix, len, counter, rand)
    counter = counter+1
    loop(prefix, len, counter, rand)
  end

end
