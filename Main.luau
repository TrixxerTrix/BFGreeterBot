local rs,plrs = game:GetService("ReplicatedStorage"),game:GetService("Players")
local folprefix = "GeforceGTXUserIds"
local fol = makefolder(folprefix)
local function getfollowers(userid)
	if syn and syn.request then
		local response = syn.request(
			{
				Url = string.format("https://friends.roblox.com/v1/users/%s/followers/count",userid or 1),
				Method = "GET",
				Headers = {["Content-Type"] = "application/json"},
				Body = game:GetService("HttpService"):JSONDecode({["trix_trix_trix_trix"] = "lolthisdoesnothing"})
			}
		)
		return game:GetService("HttpService"):JSONDecode(response.Body).count
	else return "ERROR > Executor is not synapse! (syn or syn.request not detected)" end
end
local function sayreq(msg) rs:WaitForChild("DefaultChatSystemChatEvents",1):WaitForChild("SayMessageRequest"):FireServer(msg or "Template","All") end
local function getstr(length)
	local chrset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	local rstr = {} for int = 1, length or 16 do
		local rn = math.random(1,#chrset)
		rstr[#rstr + 1] = string.sub(chrset,rn,rn)
	end
	return table.concat(rstr)
end
local function gotocframe(cframe)
	workspace:WaitForChild(plrs:GetNameFromUserIdAsync(plrs.LocalPlayer.UserId),1).HumanoidRootPart.CFrame = cframe
end

local function logplruuii(tplr,chatmsg)
	local plr = plrs:WaitForChild(tplr,1)
	if not plr or not plr:IsA("Player") then return end
	local msgs = {"Dont worry, you're not the only one.","Have fun.","Reisen for the win.","ely","Among us isn't funny.","Only a spoonful.","No mercy.","[[BIG SHOT]]!","mario is not ok","Yub."}
	if not isfile(string.format("%s/%s.cfg",folprefix,plr.UserId)) then
		local str = getstr(8)
		writefile(string.format("%s/%s.cfg",folprefix,plr.UserId),string.format("%s",str))
		if chatmsg then sayreq(string.format("Hello, %s. [%s] You've been logged. %s",plr.DisplayName,str,msgs[math.random(1,#msgs)])) end
	else
		local str = readfile(string.format("%s/%s.cfg",folprefix,plr.UserId))
		if chatmsg then sayreq(string.format("Hello, %s. [%s] Your UUII has been.. Loaded?",plr.DisplayName,str)) end
	end
end

local tolog = {} do 
	for i, v in next, plrs:GetPlayers() do table.insert(tolog,v.UserId) end
end
local dontlog = {3333294}
wait()
for i, v in next, tolog do
	if plrs:WaitForChild(plrs:GetNameFromUserIdAsync(tonumber(v)),1) and not table.find(dontlog,plrs:GetNameFromUserIdAsync(tonumber(v))) then
		local plr = plrs:WaitForChild(plrs:GetNameFromUserIdAsync(tonumber(v)),1)
		if plr.CurrentLocation.Value == "None" or nil then
			gotocframe(workspace:WaitForChild(plrs:GetNameFromUserIdAsync(tonumber(v),1)).HumanoidRootPart.CFrame)
			task.spawn(function()
				delay(0.12,function()
					plrs.LocalPlayer.Character.HumanoidRootPart.Anchored = true
				end)
			end)
		end
		logplruuii(plr.Name,true)
		wait(5)
		sayreq(string.format("Account creation date: %s",os.date("%x",(os.time() - plr.AccountAge * 86400))))
		local friends,followers = nil,getfollowers(v) do
			local name = plrs:GetNameFromUserIdAsync(tonumber(v))
			local function iterpagei(ps)
				return coroutine.wrap(function()
					local pagenum = 1
					while true do
						for _, item in ipairs(ps:GetCurrentPage()) do
							coroutine.yield(item, pagenum)
						end
						if ps.IsFinished then break end
						ps:AdvanceToNextPageAsync()
						pagenum += 1
					end
				end)
			end
			local usernames = {} do
				for item, pagenum in iterpagei(plrs:GetFriendsAsync(v)) do
					table.insert(usernames,item.Username)
				end
			end
			friends = #usernames
		end
		wait()
		sayreq(string.format("Number of friends and followers: %s and %s",friends,followers))
		wait(5)
		plrs.LocalPlayer.Character.HumanoidRootPart.Anchored = false
		wait(0.05)
	end
end
sayreq("Finished logging. Moving onto next server.")
plrs.LocalPlayer.OnTeleport:Connect(function(state)
	if state == Enum.TeleportState.InProgress and syn then
		syn.queue_on_teleport([[
            repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character ~= nil
            wait(5)
            game:GetService("ReplicatedStorage").UIRemotes.SetColl:FireServer()
            wait(2)
            game:GetService("ReplicatedStorage").ChangeChar:FireServer("Elly (PC98)")
            wait(2)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/TrixxerTrix/GeforceGTX/main/Main.luau",true))()
        ]])
	end
end)
wait(10)
local x = {}
for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
	if type(v) == "table" and v.id ~= game.JobId then
		x[#x + 1] = v.id
	end
end
if #x > 0 then
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
else
	sayreq("oops we couldnt find a server")
end
