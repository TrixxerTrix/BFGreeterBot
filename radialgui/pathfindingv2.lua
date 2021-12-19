while not _G.rad do
  task.wait()
end
local pf = {}
pf.__index = pf
local pfs,plrs = game:GetService("PathfindingService"),game:GetService("Players")
local http,fs = game:GetService("HttpService"),game:GetService("FriendService")
local hrp,rs = plrs.LocalPlayer.Character.HumanoidRootPart,game:GetService("ReplicatedStorage")
local rad = _G.rad

function pf:pf(part: Vector3)
    local gui = rad.newgui()
    local radobj = rad.new(gui.Progress, nil, {
	    BackgroundTransparency = 0.8,
	    BackgroundColor = Color3.fromRGB(0, 0, 0),
	    BackgroundType = "TransAndColor",
	    ProgressTransparency = 0,
	    ProgressColor = Color3.fromRGB(255, 255, 255)
    });
    radobj.Config.ImageColor = Color3.fromRGB(255, 255, 255);
    radobj.Config.ImageId = "6553408336";
    radobj:update()

    task.wait(1)
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
    local number = 1
    for i = 1, #wps do number += 1 end
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
        if wp.Action == Enum.PathWaypointAction.Jump then
            plrs.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        plrs.LocalPlayer.Character.Humanoid:MoveTo(wp.Position)
        plrs.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
        task.spawn(function()
            radobj:tween((i/#wps)*100,0.25)
        end)
    end
    antisit:Disconnect()
    pathfinding_fol:Destroy()
    task.spawn(function()
        gui.Progress:TweenPosition(UDim2.new(0.067,0,1.15,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,1)
        task.wait(3)
        radobj:set(100)
        gui:Destroy()
    end)
    for i, v in next, workspace:GetChildren() do
        if v:IsA("Folder") and #v:GetChildren() == 0 then v:Destroy() end
    end
    return
end
function pf:pft(table)
    if not typeof(table) == "table" then return end
    for i, v3 in next, table do pf(v3) end
    return
end

_G.pf = setmetatable({}, pf)
