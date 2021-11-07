--############################################
-- bf greeter bot lol
-- dont distribute to anybody (PLSS)
-- only works with synapse
-- 1.0c
--############################################

if not (syn and syn.request) then --[[not synapse or sw]] error("Your executor is not Synapse or ScriptWare!") end
--/ services
local plrs,rs = game:GetService("Players"),game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")

repeat task.wait() until game:IsLoaded() and plrs.LocalPlayer.Character ~= nil
local localplr = plrs.LocalPlayer

--/ functions
local cmdsdelay = false
local sayreq,gotocframe = function(msg)
	rs:WaitForChild("DefaultChatSystemChatEvents",1):WaitForChild("SayMessageRequest"):FireServer(msg,"All"); return "✓ - Said message in chat"
end,function(cframe) plrs.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe; return end
local setupplr = function(plr)
	if not plr:IsA("Player") then return end
	plr.Chatted:Connect(function(msg)
		if string.sub(msg,1,5) == "/say " then
			if #string.sub(msg,6,msg-5)<= 35 and not string.sub(msg,1,5) ~= "/say " then
				sayreq("Say Request by @%s > %s",plr.Name,string.sub(msg,6,#msg-5))
			else sayreq(string.format("Error > @%s Your message is over 35 characters! Try again with a shorter message.",plr.Name)) end
		end
		if string.sub(msg,1,14) == "/randomnumber " then
			sayreq("Random Number by @%s > %s",plr.Name,math.random(-100,100))
		end
		if msg == "/cmds" then
			if not cmdsdelay then
				cmdsdelay = true
				sayreq("Commands");wait()
				sayreq("/say [string] → Says a message (MUST BE UNDER 35 CHARACTERS)");wait(1)
				sayreq("/randomnumber → Says a random number between -100 and 100");wait(1)
				sayreq("/changechar [string] → Changes into that character. (WIP)")
			end
		end
	end)
end

--/ main script LOL!!!
plrs.PlayerAdded:Connect(function(p)
	repeat task.wait() until p.Character ~= nil
	gotocframe(p.Character.HumanoidRootPart.CFrame)
	setupplr(p)
	sayreq(string.format("hi %s!!! enjoy your time in this server :))",p.Name))
	return
end) do for i, v in next, plrs:GetPlayers() do if v ~= localplr then setupplr(v)  end end end

plrs.PlayerRemoving:Connect(function(p)
	sayreq(string.format("bye %s!!! see you later :wave:",p.Name))
	return
end)localplr.Idled:Connect(function()
	
end)

sayreq(string.format("i say hello to the %s people in this server!! :))",#plrs:GetPlayers()));wait(2)
sayreq("say /cmds in chat to understand my commands ( i only have 2 rn broo )")
