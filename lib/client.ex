defmodule Client do
    def runclient(arg) do  
        {:ok, addrs} = :inet.getif
        {inner_addrs, _, _} = Enum.at(addrs,0)
        {first, second, third, fourth} = inner_addrs
        ip = "#{first}.#{second}.#{third}.#{fourth}"
        
        #hack for windows ip address
        if ip == "127.0.0.1" do
            {:ok, addrs}= :inet.getif
            sec = Enum.at(addrs,1)
            {inner_addrs, _, _} = sec
            {first, second, third, fourth} = inner_addrs
            ip = "#{first}.#{second}.#{third}.#{fourth}"
        end
        
        IO.puts "Client IP: " <> ip

        name = StringGenerator.string_of_length(10) <> "@"
    
        Node.start (String.to_atom(name<>ip)) #this is the IP of the machine on which you run the code
        Node.set_cookie (:"cookiename")
        Node.connect(String.to_atom("serv1@"<>arg))
    
        #pid = Node.spawn( String.to_atom("serv@"<>arg), BITGENMODULE, :loop, [ ] );
        #send pid, {:message, "cln1@"<>ip};
    
    end
    
    def mine(k, clientmachine) do
        receive do
            #cores = :erlang.system_info(:schedulers_online)
            (str) -> Client.clientspawner(clientmachine, k, :erlang.system_info(:schedulers_online))
            #(str) -> StringGenerator.abc(clientmachine, k)
        end   
        mine(k, clientmachine)
    end

    def clientspawner(clientmachine, k, count) do
        if count>0 do
            prefix = "clnt" <> StringGenerator.string_of_length(4) <> " "
            pid = Node.spawn(String.to_atom(clientmachine), StringGenerator, :abc, [prefix, k]);
            send pid, {:message, "this is client spawner"};
            count=count-1
            clientspawner(clientmachine, k, count)
        end
    end

end