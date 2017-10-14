defmodule Server do

    def runserver(k) do    
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
        
        IO.puts "Server IP: " <> ip

        Node.start(String.to_atom("serv1@"<>ip))
        Node.set_cookie(Node.self(), :"cookiename")

        cores = :erlang.system_info(:schedulers_online)
        miner(k,String.to_atom("serv1@"<>ip),cores)
        #pid_miner = Node.spawn( String.to_atom("serv1@"<>ip), Server, :miner, [k,String.to_atom("serv1@"<>ip),cores] );
        pid_listner = Node.spawn( String.to_atom("serv1@"<>ip), Server, :clientdetect, [k,0] );

    end
    
    def miner(k,servermachine,count) do
        if count>0 do
            prefix = "dmitra17;"
            #prefix = StringGenerator.string_of_length(4) <> " "
            pid = Node.spawn(servermachine, StringGenerator, :abc, [prefix, k]);
            send pid, {:message, "this is server spawner"};
            count=count-1
            miner(k,servermachine,count)
        end
        
        #StringGenerator.abc("servdeep",k)
        #miner(k)
    end
    
    def clientdetect(k, count)  do
        #IO.puts "miner"  
        clientmachine = Enum.at(Node.list ,count)
        #IO.puts clientmachine
        if length(Node.list)>count do
            pid = Node.spawn(Enum.at(Node.list ,count), Client, :mine, [k, Atom.to_string(Enum.at(Node.list ,count))] );
            send pid, {:message, "this is server"};
            count = count+1
        end
        clientdetect(k, count)
    end

    


end