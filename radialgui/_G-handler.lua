local rad,tween,run = {},game:GetService("TweenService"),game:GetService("RunService")
rad.__index = rad

function rad.new(io,ni,op)
	local self = setmetatable({},rad)
	self.Progress,self.Config = 0,{}
	local conf = self.Config
	conf.ImageColor,conf.ImageId,conf.ImageTransparency = Color3.new(1,1,1),ni or "6553408336",0
	conf.FlipProgress,conf.BackgroundTransparency,conf.BackgroundType = false,op.BackgroundTransparency or 0.8,op.BackgroundType or "TransAndColor"
	conf.BackgroundColor,conf.ProgressTransparency,conf.ProgressColor = op.BackgroundColor or Color3.new(),op.ProgressTransparency or 0,op.ProgressColor or Color3.new(1,1,1)
	
	self.ColorSequenceColor = ColorSequence.new({ColorSequenceKeypoint.new(0,conf.ProgressColor),ColorSequenceKeypoint.new(0.5,conf.ProgressColor),ColorSequenceKeypoint.new(0.501,conf.BackgroundColor),ColorSequenceKeypoint.new(1,conf.BackgroundColor)})
	self.NumberSequenceTrans = NumberSequence.new({NumberSequenceKeypoint.new(0,conf.ProgressTransparency),NumberSequenceKeypoint.new(0.5,conf.ProgressTransparency),NumberSequenceKeypoint.new(0.501,conf.BackgroundTransparency),NumberSequenceKeypoint.new(1,conf.BackgroundTransparency)})
	self.Instance = io
	return self
end

function rad.update(self)
	local percent = math.clamp(self.Progress * 3.6,0,360)
	local f1,f2 = self.Instance.Frame1.ImageLabel,self.Instance.Frame2.ImageLabel
	
	f1.UIGradient.Rotation = self.Config.FlipProgress == false and math.clamp(percent,180,360) or 180 - math.clamp(percent,0,180)
	f2.UIGradient.Rotation = self.Config.FlipProgress == false and math.clamp(percent,0,180) or 180 - math.clamp(percent,180,360)
	f1.ImageColor3 = self.Config.ImageColor
	f2.ImageColor3 = self.Config.ImageColor
	f1.ImageTransparency = self.Config.ImageTransparency
	f2.ImageTransparency = self.Config.ImageTransparency
	f1.Image = "rbxassetid://" .. self.Config.ImageId
	f2.Image = "rbxassetid://" .. self.Config.ImageId
	
	if self.Config.BackgroundType == "Color" then
		f1.UIGradient.Color = self.ColorSequenceColor
		f2.UIGradient.Color = self.ColorSequenceColor
		f1.UIGradient.Transparency = NumberSequence.new(0)
		f2.UIGradient.Transparency = NumberSequence.new(0)
	elseif self.Config.BackgroundType == "Trans" then
		f1.UIGradient.Transparency = self.NumberSequenceTrans
		f2.UIGradient.Transparency = self.NumberSequenceTrans
		f1.UIGradient.Color = ColorSequence.new(Color3.new(1,1,1))
		f2.UIGradient.Color = ColorSequence.new(Color3.new(1,1,1))
	elseif self.Config.BackgroundType == "TransAndColor" then
		f1.UIGradient.Transparency = self.NumberSequenceTrans
		f2.UIGradient.Transparency = self.NumberSequenceTrans
		f1.UIGradient.Color = self.ColorSequenceColor
		f2.UIGradient.Color = self.ColorSequenceColor
	else
		self.Config.BackgroundType = "Trans"
		error("Unknown Type. Only 3 available: “Trans”, “Color” and “TransAndColor”, changing to “Trans”.")
	end
end

function rad.set(self, new)
	self.Progress = new
	self:update()
end

function rad.tween(self, new, tt)
	local info = TweenInfo.new(tt or 1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local progobj = Instance.new("NumberValue")
	progobj.Value = self.Progress
	local t = tween:Create(progobj,info,{Value = new or 100})
	local connection = run.Heartbeat:Connect(function()
		self.Progress = progobj.Value
		self:update()
	end)
	t:Play()
	t.Completed:Wait()
	connection:Disconnect()
	progobj:Destroy()
	self.Progress = new
end

function rad.newgui()
    local gui = game:GetObjects("rbxassetid://8290893906")[1]
	gui.Parent = game:GetService("CoreGui")
    return gui
end

_G.rad = setmetatable({},rad)
