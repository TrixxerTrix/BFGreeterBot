-->> CirnoRidingOnASlide Source Code
--> Please dont use this without my permission, you can take inspiration from the code, just dont use it.
local a = Instance.new("StringValue",game.Workspace)
a.Parent = workspace
a.Name = "ActiveZone"
--> print(a.Parent, a.Name) for debugging.

local pfs,plrs = game:GetService("PathfindingService"),game:GetService("Players")
local http,fs = game:GetService("HttpService"),game:GetService("FriendService")
local hrp,rs = plrs.LocalPlayer.Character.HumanoidRootPart,game:GetService("ReplicatedStorage")
local tpmode = false
local sayevent = rs.DefaultChatSystemChatEvents.SayMessageRequest
function pf(part: Vector3)
    local antisit
    plrs.LocalPlayer.Character.Humanoid.Sit = false
    local pos = part
    local path = pfs:CreatePath({AgentHeight = 5,AgentRadius=3,AgentCanJump = true});path:ComputeAsync(hrp.Position,pos)
    local pathfinding_fol = Instance.new("Folder",workspace)
    pathfinding_fol.Name = http:GenerateGUID(true)
    local wps = path:GetWaypoints()
    antisit = plrs.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
        if hrp.Parent.Humanoid.Sit == true then
            task.wait()
            plrs.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    for i, wp in next, wps do
        local part = Instance.new("Part")
        part.Shape,part.Material,part.Size = "Ball",Enum.Material.Neon,Vector3.new(0.6, 0.6, 0.6)
        part.Position,part.Anchored,part.CanCollide = wp.Position + Vector3.new(0,1.6,0),true,false
        part.Parent,part.Transparency = pathfinding_fol,0.6
        if i == 1 then
            part.Size = Vector3.new(1.2,1.2,1.2)
            part.Color = Color3.new(0,1,0)
        elseif i == #wps then
            part.Size = Vector3.new(1.2,1.2,1.2)
            part.Color = Color3.new(1,0,0)
        end
    end
    for i, wp in next, wps do
        if tpmode then
            hrp.CFrame = CFrame.new(wp.Position + Vector3.new(0,1.6,0))
            task.wait()
        else
            if wp.Action == Enum.PathWaypointAction.Jump then
                plrs.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            plrs.LocalPlayer.Character.Humanoid:MoveTo(wp.Position)
            plrs.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
        end
    end
    antisit:Disconnect()
    pathfinding_fol:Destroy()
    for i, v in next, workspace:GetChildren() do
        if v:IsA("Folder") and #v:GetChildren() == 0 then v:Destroy() end
    end
    return
end
function pft(table)
    if not typeof(table) == "table" then return end
    for i, v3 in next, table do pf(v3) end
    return
end
--> 5s 75
local beachzone = workspace:WaitForChild("Zones"):WaitForChild("Beach")
pcall(sayevent.FireServer, sayevent, "[LOCATION] Heading to \"Beach\" zone slide.", "All")
pf(beachzone.Entrance.Position)
fireproximityprompt(beachzone.Entrance.Beach)
task.wait(5)
pf(Vector3.new(-959.839, 17.9935, 8961.33))
local hum = hrp.Parent.Humanoid
local thej do
    for i, v in next, workspace:WaitForChild("SpecialSlides"):GetChildren() do
        if v.DataCost == 326 then
            thej = v
        end
    end
end
pcall(sayevent.FireServer, sayevent, "[STARTING] Sliding time!", "All")
repeat
    hum:MoveTo(Vector3.new(-959.317, 27.8613, 8953.01))
    hum.MoveToFinished:Wait()
    task.wait(0.5)
    fireproximityprompt(thej.Start.Slide)
    task.wait(7)
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(1/30)
    pf(Vector3.new(-959.839, 17.9935, 8961.33))
    task.wait(0.5)
until false
