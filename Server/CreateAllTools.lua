local PlayerService = game:GetService("Players")
local SKR_ENUMS = require(game:GetService("ReplicatedStorage").Seeker.Modules.GlobalFunctions.Enums)

local function InitializeTool(player: Player, tool: Tool)
	local SKR_SETTINGS = require(tool:WaitForChild('SKR_SETTINGS'))
	local SKR_ANIMS = require(tool:WaitForChild('SKR_ANIMS'))
	
	local OrderFolder = Instance.new('Folder', player)
	OrderFolder.Name = "Order"
	
	local ToolOrder = Instance.new('IntValue', OrderFolder)
	ToolOrder.Name = tool.Name
	ToolOrder.Value = SKR_SETTINGS.Order
	
	local hasDuplicate = false
	for _, intValue in ipairs(OrderFolder:GetChildren()) do
		if intValue:IsA('IntValue') and intValue.Value == SKR_SETTINGS.Order then
			hasDuplicate = true
			break
		end
	end

	if hasDuplicate then
		print("Order already has been specified")
	end
	
	local NewSKRTool = Instance.new('Tool', player:WaitForChild('Backpack'))
	NewSKRTool.Name = tool.Name
	NewSKRTool.RequiresHandle = false
	NewSKRTool.CanBeDropped = false
	NewSKRTool:SetAttribute("MouseIcon", SKR_SETTINGS.Cursor_Icon)
	
	local GunModel = SKR_SETTINGS.Model:Clone()
	GunModel.Parent = NewSKRTool
	GunModel:SetAttribute("Type", "Model")
	
	if SKR_SETTINGS.CFRAME_INITIAL then
		GunModel:SetAttribute("CFrame", SKR_SETTINGS.CFRAME_INITIAL)
	end
	
	if SKR_SETTINGS.Damage then
		NewSKRTool:SetAttribute("Damage", SKR_SETTINGS.Damage)
	end
	
	if SKR_SETTINGS.Ammo then
		local CurrentAmmo = Instance.new('IntValue', NewSKRTool)
		CurrentAmmo.Name = "Ammo"
		CurrentAmmo.Value = SKR_SETTINGS.Ammo
		
		local MaxAmmo = Instance.new('IntValue', NewSKRTool)
		MaxAmmo.Name = "MaxAmmo"
		MaxAmmo.Value = SKR_SETTINGS.Ammo
		
	end
	
	local AnimFolder = Instance.new('Folder', NewSKRTool)
	AnimFolder.Name = "Animations"
	
	if SKR_SETTINGS.FiringType == SKR_ENUMS.FiringTypes.SemiAuto then
		local SemiScript = game:GetService("ReplicatedStorage").SKR_SHARED.SemiScript:Clone()
		SemiScript.Parent = NewSKRTool
		SemiScript.Enabled = true
	end
	
	
	for name, animationValues in pairs(SKR_ANIMS) do
		local AnimationObject = Instance.new('Animation', AnimFolder)
		AnimationObject.AnimationId = animationValues
		AnimationObject.Name = name
	end
	
	
	tool:Destroy() -- Delete Tool Config Settings.
	
end

function playerJoined(player: Player)
	player.CharacterAdded:Connect(function()
		print(player.Name, "Has Joined!") -- Debugging purposes.

		local Backpack = player:WaitForChild('Backpack')

		for _, tools in pairs(Backpack:GetChildren()) do
			InitializeTool(player, tools)
		end
	end)
end


PlayerService.PlayerAdded:Connect(playerJoined)

for _, player in pairs(PlayerService:GetPlayers()) do
	spawn(function() playerJoined(player) end)
end
