local Aria = require(game:GetService("ReplicatedStorage").Polarix.Modules.Util.Animations).new({})

local GlobalFunctions = {}

function GlobalFunctions.Animation.SetFolder(Folder: Folder)
	Aria:SetAnimationFolder(Folder)
end

function GlobalFunctions.Animation.Setup(Humanoid: Humanoid)
	Aria:Preload()
	Aria:Load(Humanoid)
end

function GlobalFunctions.Animation.GetAnimObject(nameOfAnimation: string)
	return Aria:GetAnim(nameOfAnimation)
end



return GlobalFunctions
