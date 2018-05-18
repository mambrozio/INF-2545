local tossam = require("tossam") 

local exit = false
while not(exit) do
    local mote = tossam.connect {
      protocol = "sf",
      host     = "localhost",
      port     = 9002,
      nodeid   = 1
    }
    
	if not(mote) then
	    print("Connection error!");
	    return(1);
    end

	mote:register [[ 
	  nx_struct msg_serial [145] { 
		nx_uint16_t type;
		nx_uint16_t source;
		nx_uint16_t target;
		nx_uint16_t node;
		nx_uint16_t temp;
	  }; 
	]]

	while (mote) do

		local stat, msg, emsg = pcall(function() return mote:receive() end) 
		--print(stat, msg, emsg)
		if stat then
			if msg then
				print("------------------------------") 
				print("msgID: "..msg.type, "Source: ".. msg.source, "Target: ".. msg.target) 
				print("n:", msg.node)
				print("t:", msg.temp)
			else
				if emsg == "closed" then
					print("\nConnection closed!")
					exit = true
					break 
				end
			end
		else
			print("\nreceive() got an error:"..msg)
			exit = true
			break
		end
	end

	mote:unregister()
	mote:close() 

end

