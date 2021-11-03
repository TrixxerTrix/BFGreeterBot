local rs,plrs = game:GetService("ReplicatedStorage"),game:GetService("Players")
local folprefix = "GeforceGTXUserIds"
local fol = makefolder(folprefix)
local function sayreq(msg) rs:WaitForChild("DefaultChatSystemChatEvents",1):WaitForChild("SayMessageRequest"):FireServer(msg or "Template","All") end
local function getstr(length)
	local chrset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	local rstr = {} for int = 1, length or 16 do
		local rn = math.random(1,#chrset)
		rstr[#rstr + 1] = string.sub(chrset,rn,rn)
	end
	return table.concat(rstr)
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
wait()
plrs.LocalPlayer.Character.HumanoidRootPart.Anchored = true
for i, v in next, tolog do
    if plrs:WaitForChild(plrs:GetNameFromUserIdAsync(tonumber(v)),1) then
        local plr = plrs:FindFirstChild(plrs:GetNameFromUserIdAsync(tonumber(v)))
        local cfr = plr.Character.HumanoidRootPart.CFrame
        plrs.LocalPlayer.Character.HumanoidRootPart.CFrame = cfr
        logplruuii(plr.Name,true)
        wait(5)
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
        ]])
    end
end)
plrs.LocalPlayer.Character.HumanoidRootPart.Anchored = false
wait(10)
local servers,teleport = {},game:GetService("TeleportService")
for i, v in next, game:GetService("HttpService"):JSONDecode(game:HttpGet(string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100")).data) do
    if typeof(v) == "table" and v.id ~= game.JobId then
        servers[#servers+1] = v.id
    end
end
if #servers >= 1 then
    teleport:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
else sayreq("oops we couldnt find a server, rejoining server lol");wait(5);teleport:TeleportToPlaceInstance(game.PlaceId,game.JobId) end
