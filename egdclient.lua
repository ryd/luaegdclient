local socket = require("socket")
local string = require("string")
local base   = _G
module("egdclient")

config = config or {}
config.host = "localhost"
config.port = 8888

local egd_request

function egd_request(request)
    local tcp = socket.tcp()

    -- connect
    local status, err = tcp:connect(config.host, config.port, 20, false)
    if (status == nil) then
        return nil, err
    end

    -- send request
    local workload = string.char(request.code)
    if request.count then
        workload = workload .. string.char(request.count)
    end
    status, err = tcp:send(workload)
    if (status == nil) then
        return nil, err
    end

    -- got answer
    local data = nil
    data, err = tcp:receive(request.read)
    if (data == nil) then
        return nil, err
    end

    -- maybe read more data
    if request.length_byte then
        data, err = tcp:receive(data:byte(1))
    end

    -- close connection
    tcp:close()

    return data
end

function get_buffer()
    local response, err = egd_request({ code = 0, read = 4 })
    if err then
        return nil, err
    end

    -- big-endian converter for 4 bytes
    local number = 0
    for i=1,4,1 do
        number = number * 256 + response:byte(i)
    end

    return number
end

function get_pid()
    local response, err = egd_request({ code = 4, read = 1, length_byte = true})
    if err then
        return nil, err
    end

    return base.tonumber(response)
end

function read_nonblocking(count)
    -- between 1 and 255
    if count > 255 or count < 1 then
        count = 255
    end

    local response, err = egd_request({ code = 1, read = 1, length_byte = true, count = count})
    if err then
        return nil, err
    end

    return response
end

function read_blocking(count)
    -- between 1 and 255
    if count > 255 or count < 1 then
        count = 255
    end

    local response, err = egd_request({ code = 2, read = count, count = count})
    if err then
        return nil, err
    end

    return response
end

function write(bits, entopy)
    -- I have no chance to test it
    -- so I skip this part
    return nil, "not supported"
end


