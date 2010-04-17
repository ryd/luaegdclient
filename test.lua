local egdclient = require("egdclient")

--egdclient.config.host  = 'localhost'
--egdclient.config.port  = 2020

function p(description, result) 
    print('#### ' .. description .. ' ####')
    if result == nil then
        print("nil")
    else
        print(result)
    end
end

p('get_pid',  egdclient.get_pid())
p('get_buffer',  egdclient.get_buffer())
p('read nonblocking 250',  string.len(egdclient.read_nonblocking(250)))
p('get_buffer',  egdclient.get_buffer())
p('read blocking 250',  string.len(egdclient.read_blocking(250)))
p('get_buffer',  egdclient.get_buffer())


