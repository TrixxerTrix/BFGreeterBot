--[[
 _____     _      _   _ _   _ _     
 |_   _| __(_)_  _| | | | |_(_) |___ 
   | || '__| \ \/ / | | | __| | / __|
   | || |  | |>  <| |_| | |_| | \__ \
   |_||_|  |_/_/\_\\___/ \__|_|_|___/
                                     
2021© | made by trixx_tr™ | made for modification

]]--

-- ! WARNING !
-- Dont modify anything under here unless you know what you are doing! You could break things!

local util = {} 
util.__index = util

local namecache,servicecache = {},{}
function util.getnamefromid(id: number | string): string
	if typeof(id) == "string" then
		id = tonumber(id)
	end
	--------------------------------------
	local success,name = pcall(function()
		return util.gets("Players"):GetNameFromUserIdAsync(id)
	end)
	if success and namecache[name] then
		return namecache[name]
	end
	--------------------------------------
	if not success then
		return "Name not found"
	end
	return name
end

--------------------------------------

function util.gets(name: string): Instance | DataModel
	if servicecache[name] then
		return servicecache[name]
	end
	--------------------------------------
	servicecache[name] = game:GetService(name) or game:FindService(name) or game:FindFirstChildOfClass(name) or game:FindFirstChild(name) or game
	return servicecache[name]
end

--------------------------------------

function util.getrstring(length: number?, seed: number?, charset: string?): string
	length = tonumber(string.format("%0i",length or 8))
	charset = charset or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	--------------------------------------
	local toreturn = ""
	for i = 1, (length or 8) do
		local rng = Random.new(seed or Random.new():NextInteger(-2147483648,2147483647)):NextInteger(1,string.len(charset))
		toreturn = string.format("%s%s",toreturn,string.sub(charset,rng,rng))
	end
	--------------------------------------
	return toreturn
end

--------------------------------------

util.important = {}
function util.important.clearcaches()
	table.clear(namecache)
	table.clear(servicecache)
	return true
end

function util.important.kill()
	task.spawn(function()
		table.clear(util)
		_G.t_utils,shared.t_utils = nil,nil
	end)
end

--------------------------------------

shared.t_utils = setmetatable(util,{})
_G.t_utils = shared.t_utils
return util
