local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local Functions = {

	['Shoot'] = function(player: Player, Tool: Tool, RootPosition: Vector3, EndPosition: Vector3)
		
		-- Calculate Raycast and Damage
		
		local Character = player.Character or player.CharacterAdded:Wait()
		
		local function GrabModel()
			local Model 

			for _, objects in pairs(Tool:GetChildren()) do
				if objects:GetAttribute("Type") == "Model" then
					Model = objects
					break
				end
			end

			return Model
		end
		
		local function CreateBlackList()
			local blackListTable = {}

			for _, objects in pairs(GrabModel():GetChildren()) do
				if not objects:IsA("Model") then
					table.insert(blackListTable, objects)
				else
					for _, Meshes in pairs(objects:GetChildren()) do
						table.insert(blackListTable, Meshes)
					end
				end
			end

			for _, parts in pairs(Character:GetChildren()) do
				table.insert(blackListTable, parts)
			end

			return blackListTable
		end

		
		local function VisualizeRayCast(startPos: Vector3, Direction)
			local Center = startPos + Direction/2
			local distance = Direction.Magnitude
			
			local Visual = Instance.new('Part',workspace)
			Visual.Anchored = true
			Visual.CanCollide = false
			Visual.Color = Color3.fromRGB(255,0,0)
			Visual.Material =  Enum.Material.Neon
			Visual.Transparency = 0.5
			
			Visual.CFrame = CFrame.new(Center, startPos)
			Visual.Size = Vector3.new(.25,.25, distance)
			
			Debris:AddItem(Visual, 1)
		end
		
		local maxRange = 100
		local Direction = ((EndPosition - RootPosition).Unit * maxRange)
		
		local Params = RaycastParams.new()
		Params.FilterDescendantsInstances = CreateBlackList()
		Params.FilterType = Enum.RaycastFilterType.Exclude
		Params.IgnoreWater = true
		
		local result = workspace:Raycast(RootPosition, Direction, Params)
		
		if result then
			print(result.Instance)
			local enemyCharacter = result.Instance.Parent
			if enemyCharacter:FindFirstChild('Humanoid') then
				enemyCharacter.Humanoid:TakeDamage(Tool:GetAttribute("Damage"))
			end
		end
		
		--VisualizeRayCast(RootPosition, Direction)
	end,
	
	["Print"] = function(player: Player, Message: string)
		print(Message)
	end,
	

	['Motor6D'] = function(player: Player, Tool: Tool, activate: boolean)

		local Character = player.Character or player.CharacterAdded:Wait()
		local Humanoid = Character:WaitForChild('Humanoid')
		local RootPart = Character:WaitForChild('HumanoidRootPart')
		
		local Model 
		local Handle 
		
		-- Find the Model
		
		for _, objects in pairs(Tool:GetChildren()) do
			if objects:GetAttribute("Type") == "Model" then
				Model = objects
				break
			end
		end
		
		-- Find the Handle
		
		for _, parts in pairs(Model:GetChildren()) do
			if parts:GetAttribute("Type") == "Handle" then
				Handle = parts
				break
			end
		end
		
		
		
		if not activate then
			local Motor6D_Destroy = RootPart:FindFirstChild("HandleMotor")
			if Motor6D_Destroy then
				Motor6D_Destroy:Destroy()
			end
		else
			local Motor6D

			if RootPart:FindFirstChild("HandleMotor") then
				Motor6D = RootPart:FindFirstChild("HandleMotor") 
			else
				Motor6D = Instance.new('Motor6D', RootPart)
				Motor6D.Part0 = RootPart
				Motor6D.Part1 = Handle
				
				if Model:GetAttribute("CFrame") then
					Motor6D.C0 = Model:GetAttribute("CFrame")
				end
				
				Motor6D.Name = "HandleMotor"
			end
		end
		
	end,	
}

return Functions
