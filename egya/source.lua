-- == Configurable Settings == --
local settings = {} -- Dont rename this to anything, just keep it as "settings" or the whole script will break.
settings.prefix = "!ask"
settings.afkclicktime = 120
settings.directory = "ellyasks/instances.json"
----------------------------------------
settings.chances = {
	["Yes"] = 100,
	["No"] = 100,
	["Unsure"] = 12.5,
	["baka"] = 9,
	["Maybe"] = 33,
	["Definitely not"] = 15,
	["Definitely"] = 15,
	["I CAN'T TAKE IT ANYMORE"] = 5,
	["Vine boom noise"] = 10,
	["That's mean :("] = 1,
	["monke"] = 3,
	["Dave"] = 1,
	["Bambi"] = 1,
	["Dave and Bambi"] = 0.5
}
----------------------------------------

-- == Main == --
local plrs,rs = game:GetService("Players"),game:GetService("ReplicatedStorage")
local http,tps = game:GetService("HttpService"),game:GetService("TeleportService") --/ "tps" is only used for rebranding to another server; see line 102
local saymsgevent = rs:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")

local delay,canbeused = {},true

local getitem = function()
	local sum = 0 
	for sn,c in next, settings.chances do 
		sum += c 
	end 
	local rn = Random.new():NextInteger(1,sum) 
	for sn,c in next, settings.chances do 
		if rn <= c then 
			return {sn,c}
		else rn -= c end
	end 
end

local setup = function(plr)
	if not plr:IsA("Player") then return end
	plr.Chatted:Connect(function(msg)
		local splitted,tosplit = msg:split(" "),"" 
		local blacklist = http:JSONDecode(readfile("ellyasks/blacklist.json"))
		if table.find(blacklist,plr.UserId) or table.find(delay,plr.UserId) or not canbeused then return end
		if splitted[1] == settings.prefix then
			do for i = 1, #splitted do
					if i ~= 1 then
						if i == #splitted then
							tosplit = tosplit .. splitted[i]
						else tosplit = tosplit .. splitted[i] .. " " end
					end
				end
				msg = tosplit
			end
			local instances = http:JSONDecode(readfile(settings.directory))
			local names = http:JSONDecode(readfile("ellyasks/names.json"))
			if instances[msg] then
				local dir = instances[msg]
				if plr.DisplayName:len() > 9 and not names[plr.UserId] then
					saymsgevent:FireServer(string.format("%s•, %s. (%s%%) (10 second cooldown)",names[plr.UserId] or plr.DisplayName:sub(1,10),dir[1],dir[2]),"All")
				else saymsgevent:FireServer(string.format("%s, %s. (%s%%) (10 second cooldown)",names[plr.UserId] or plr.DisplayName,dir[1],dir[2]),"All") end
			else
				local dir = getitem()
				instances[msg] = {dir[1],dir[2]}
				if plr.DisplayName:len() > 9 and not names[plr.UserId] then
					saymsgevent:FireServer(string.format("%s•, %s. (%s%%) (10 second cooldown)",names[plr.UserId] or plr.DisplayName:sub(1,10),dir[1],dir[2]),"All")
				else saymsgevent:FireServer(string.format("%s, %s. (%s%%) (10 second cooldown)",names[plr.UserId] or plr.DisplayName,dir[1],dir[2]),"All") end
				local defect = http:JSONEncode(instances)
				writefile(settings.directory,defect)
			end
			table.insert(delay,plr.UserId)
			task.spawn(function()
				task.delay(10,function()
					table.remove(delay,table.find(delay,plr.UserId))
				end)
			end)
			return		
		end
	end)
end

plrs.PlayerAdded:Connect(setup)
for i, v in next, plrs:GetPlayers() do
	if v ~= plrs.LocalPlayer then
		setup(v)
	end
end

coroutine.resume(coroutine.create(function()
	while canbeused do
		saymsgevent:FireServer("uhh to actually use me say \"!ask <message> \"","All")
		task.wait(120)
	end
end))

coroutine.resume(coroutine.create(function()
	while canbeused do
		local games,servers = http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/6238705697/servers/Public?sortOrder=Asc&limit=100")),{}
		for i, v in next, games.data do
			if typeof(v) == "table" and #plrs:GetPlayers() < v.playing and v.id ~= game.JobId then
				servers[#servers + 1] = v.id
			end
		end if #servers > 0 then
			if pick then
				canbeused = false
				saymsgevent:FireServer("There is a server bigger than this one!")
				task.wait(5)
				saymsgevent:FireServer("I have to go there now, see you there!")
				task.wait(3)
				tps:TeleportToPlaceInstance(6238705697,servers[Random.new():NextInteger(1, #servers)])
			else warn("> Could not find a server to serverhop to, trying again in 4 minutes.") end
		else warn("> Could not find a server to serverhop to, trying again in 4 minutes.") end
		task.wait(240)
	end
end))
