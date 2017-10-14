defmodule Detection do
    def main(args) do
        if is_integer(args) do  #List.first(args)
            Server.runserver(args)

        else
            Client.runclient(args)
        end

        receive do
            {:st} -> IO.puts ""
        end

    end
end