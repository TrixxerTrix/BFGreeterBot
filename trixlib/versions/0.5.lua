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
local animationcache,curanim = {},0
function util.getnamefromid(id)
	if typeof(id) == "string" then
		id = tonumber(id)
	end
	if not typeof(id) == ("string" or "number") then return "Not a valid type" end
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

function util.gets(name: string)
	if servicecache[name] then
		return servicecache[name]
	end
	--------------------------------------
	servicecache[name] = game:GetService(name) or game:FindService(name) or game:FindFirstChildOfClass(name) or game:FindFirstChild(name) or game
	return servicecache[name]
end

--------------------------------------

function util.getrstring(length: number?, seed: number?, charset: string?)
	length = tonumber(string.format("%0i", length or 8))
	charset = charset or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	seed = seed or Random.new():NextInteger(-2147483648,2147483647)
	--------------------------------------
	return string.sub(string.gsub(string.rep(".", length),".",function()
		local char = Random.new(seed):NextInteger(1, #charset)
		return string.sub(charset, char, char)
	end),1,length)
end

--------------------------------------

function util.saveanim(anim: Animation)
	curanim += 1
	animationcache[curanim] = util.gets("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(anim)
	util.gets("StarterGui"):SetCore("SendNotification",{Text = "Set [" .. curanim .. "] to \"" .. anim:GetFullName() .. "\""; Duration = 10; Title = "Saved Animation"})
end

function util.getanim(index: number)
	local sgui = util.gets("StarterGui")
	return animationcache[index] or {Play = function()
			sgui:SetCore("SendNotification",{Text = "Invalid Animation"; Duration = 5; Title = "Error"})
		end, Stop = function()
			sgui:SetCore("SendNotification",{Text = "Invalid Animation"; Duration = 5; Title = "Error"})
		end, Pause = function()
			sgui:SetCore("SendNotification",{Text = "Invalid Animation"; Duration = 5; Title = "Error"})
		end
	}
end

--------------------------------------


util.important = {}
function util.important.clearcaches()
	table.clear(namecache)
	table.clear(servicecache)
	table.clear(animationcache)
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
