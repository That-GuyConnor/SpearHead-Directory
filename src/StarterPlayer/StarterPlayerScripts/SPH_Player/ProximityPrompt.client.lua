local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local config = require(game:GetService("ReplicatedStorage").SPH_Assets.GameConfig)

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local canView = script.CanView

local PickUpUI = player.PlayerGui:WaitForChild("SPH_UI").PickUpUI

local tweenTime = 0.2
local delayTime = 0.05

local function ShowPrompt(promptPart)
	if canView.Value and char and char.Humanoid.Health > 0 then
		local newUI = promptPart.PromptUI
		local input = newUI.Main.Input
		local pressSquare = newUI.Main.Input.Key.Frame

		-- Enable prompt
		newUI.Enabled = true

		-- Play opening animation
		pressSquare.BackgroundTransparency = 0
		newUI.Main.Size = UDim2.fromScale(0,0)
		newUI.Main.White.BackgroundTransparency = 0
		newUI.Main.Input.Frame.Visible = false
		newUI.Main.Input.Key.Visible = false

		for _, element in ipairs(input:GetChildren()) do
			if element:IsA("TextLabel") then
				element.Visible = false
			end
		end


		TweenService:Create(newUI.Main,TweenInfo.new(tweenTime),{Size = UDim2.fromScale(1,0.05)}):Play()

		task.wait(tweenTime + delayTime)

		TweenService:Create(newUI.Main,TweenInfo.new(tweenTime),{Size = UDim2.fromScale(1,1)}):Play()
		TweenService:Create(newUI.Main.White,TweenInfo.new(tweenTime),{BackgroundTransparency = 1}):Play()
		newUI.Main.Input.Frame.Visible = true
		newUI.Main.Input.Key.Visible = true

		for _, element in ipairs(input:GetChildren()) do
			if element:IsA("TextLabel") then
				element.Visible = true
			end
		end
	end
end

local function HidePrompt(promptPart)
	local newUI = promptPart.PromptUI
	local input = newUI.Main.Input
	local pressSquare = newUI.Main.Input.Key.Frame
	pressSquare.BackgroundTransparency = 1

	-- Play closing animation
	TweenService:Create(newUI.Main,TweenInfo.new(tweenTime),{Size = UDim2.fromScale(1,0.05)}):Play()
	TweenService:Create(newUI.Main.White,TweenInfo.new(tweenTime),{BackgroundTransparency = 0}):Play()

	newUI.Main.Input.Frame.Visible = false
	newUI.Main.Input.Key.Visible = false

	for _, element in ipairs(input:GetChildren()) do
		if element:IsA("TextLabel") then
			element.Visible = false
		end
	end

	task.wait(tweenTime + delayTime)

	TweenService:Create(newUI.Main,TweenInfo.new(tweenTime),{Size = UDim2.fromScale(0,0.05)}):Play()

	task.wait(tweenTime)

	-- Disable prompt
	newUI.Enabled = false
end

local function SetupPrompt(prompt)
	local proxPrompt:ProximityPrompt = prompt:FindFirstChildWhichIsA("ProximityPrompt")
	local config = proxPrompt.SPH_PromptConfig
	local proxTypeValue = config:GetAttribute("ProxType") -- Use GetAttribute

	local newUI = script[proxTypeValue]:Clone()
	newUI.Name = "PromptUI"
	newUI.Parent = prompt
	newUI.Enabled = false
	newUI.Main.HoldBar.Visible = proxPrompt.HoldDuration > 0
	newUI.Main.HoldBar.Bar.Size = UDim2.fromScale(0,1)

	local input = newUI.Main.Input

	if proxTypeValue == "Kit" then
		-- Get KitName attribute from the KitGiver PART
		local kitGiverPart = prompt.Parent
		local kitNameAttribute = kitGiverPart:GetAttribute("KitName")

		-- CORRECT PATH: Access through newUI
		local kitNameLabel = newUI.Main.Input.KitName

		-- Set the TextLabel's text. Use a default if KitName is missing.
		if kitNameAttribute then
			kitNameLabel.Text = kitNameAttribute
		else
			kitNameLabel.Text = "Kit" -- Default text
		end
		newUI.Main.Input.Key.KeyText.Text = UIS:GetStringForKeyCode(proxPrompt.KeyboardKeyCode)

		-- --- Get and Display Description ---
		local descriptionAttribute = kitGiverPart:GetAttribute("Description")
		local descriptionLabel = newUI.Main.Input.Remaining -- CORRECTED PATH

		if descriptionAttribute then
			descriptionLabel.Text = descriptionAttribute
		else
			descriptionLabel.Text = "No description available." -- Default text
		end
		-- --- END OF DESCRIPTION SECTION ---

	elseif proxTypeValue == "ArcadeAmmoRefill" then
		newUI.Main.Input.Key.KeyText.Text = UIS:GetStringForKeyCode(proxPrompt.KeyboardKeyCode)
		newUI.Main.Input.AmmoType.Text = config.AmmoType.Value
		if config.InfAmmo.Value then
			newUI.Main.Input.AmmoPool.Text = "INF"
		else
			newUI.Main.Input.AmmoPool.Text = config.AmmoPool.Value.." / "..config.AmmoPool.MaxValue
			config.AmmoPool.Changed:Connect(function()
				newUI.Main.Input.AmmoPool.Text = config.AmmoPool.Value.." / "..config.AmmoPool.MaxValue
			end)
		end
	elseif proxTypeValue == "GunGiver" then
		newUI.Main.Input.Key.KeyText.Text = UIS:GetStringForKeyCode(proxPrompt.KeyboardKeyCode)
		local gunName = proxPrompt:FindFirstChildWhichIsA("Tool").Name
		newUI.Main.Input.GunName.Text = gunName
		if config.InfGuns.Value then
			newUI.Main.Input.Remaining.Text = "INF"
		elseif config.GunPool.MaxValue > 1 then
			newUI.Main.Input.Remaining.Text = config.GunPool.Value.." / "..config.GunPool.MaxValue.." REMAINING"
			config.GunPool.Changed:Connect(function()
				newUI.Main.Input.Remaining.Text = config.GunPool.Value.." / "..config.GunPool.MaxValue.." REMAINING"
			end)
		else
			newUI.Main.Input.Remaining.Text = ""
		end
	end

	newUI.Enabled = true -- Enable UI after setup

	-- Set up key press animations (KEEP THIS SECTION)
	local pressSquare = newUI.Main.Input.Key.Frame
	local pressAnim = TweenService:Create(pressSquare, TweenInfo.new(0.3), {
		BackgroundTransparency = 0.7,
		Size = UDim2.fromScale(1, 1)
	})
	local releaseAnim = TweenService:Create(pressSquare, TweenInfo.new(0.1), {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0, 0)
	})

	-- Prompt is a press prompt
	if proxPrompt.HoldDuration <= 0 then
		proxPrompt.Triggered:Connect(function()
			pressSquare.Size = UDim2.fromScale(1, 1)
			pressSquare.BackgroundTransparency = 0.7
		end)
		proxPrompt.TriggerEnded:Connect(function()
			releaseAnim:Play()
		end)

		-- Prompt is a hold prompt
	else
		local bar = newUI.Main.HoldBar.Bar
		local barAnim = TweenService:Create(bar, TweenInfo.new(proxPrompt.HoldDuration, Enum.EasingStyle.Linear), {
			Size = UDim2.fromScale(1, 1)
		})
		local barReset = TweenService:Create(bar, TweenInfo.new(0.1), {Size = UDim2.fromScale(0, 1)})

		-- Play anim
		proxPrompt.PromptButtonHoldBegan:Connect(function()
			pressAnim:Play()

			barReset:Pause()
			bar.Size = UDim2.fromScale(0, 1)
			barAnim:Play()
		end)

		-- Stop anim
		proxPrompt.PromptButtonHoldEnded:Connect(function()
			releaseAnim:Play()
			pressSquare.Size = UDim2.fromScale(0, 0)

			barAnim:Pause()
			barReset:Play()
		end)
	end
end

-- Wrap the event connections in a function and call it after getting the service
local function setupPromptEvents()
	local proxPromptService = game:GetService("ProximityPromptService") -- Get the service *INSIDE* the function.

	proxPromptService.PromptShown:Connect(function(prompt)
		if prompt:FindFirstChild("SPH_PromptConfig") then
			if not prompt.Parent:FindFirstChild("PromptUI") then
				SetupPrompt(prompt.Parent)
			end
			ShowPrompt(prompt.Parent)
		elseif PickUpUI:FindFirstChild("ItemName") and prompt.Parent.Parent:FindFirstChild("PickupHighlight") then
			prompt.Parent.Parent.PickupHighlight.Enabled = true
			PickUpUI.Visible = true
			PickUpUI.ItemName.Text = "["..string.upper(config.pickupKey[1].Name).."] ".. prompt.Parent.Parent.Name

			local tool = prompt.Parent.Parent:FindFirstChildWhichIsA("Tool")
			if tool and tool:FindFirstChild("SPH_Weapon") then
				local wepStats = require(tool.SPH_Weapon.WeaponStats)
				PickUpUI.ItemName.Text = PickUpUI.ItemName.Text.. " ".. wepStats.ammoType
			end
		end
	end)

	proxPromptService.PromptHidden:Connect(function(prompt)
		if prompt:FindFirstChild("SPH_PromptConfig") then
			if not prompt.Parent:FindFirstChild("PromptUI") then
				SetupPrompt(prompt.Parent)
			end
			HidePrompt(prompt.Parent)
		elseif prompt.Parent and prompt.Parent.Parent:FindFirstChild("PickupHighlight") then
			prompt.Parent.Parent.PickupHighlight.Enabled = false
			PickUpUI.Visible = false
		else
			PickUpUI.Visible = false
		end
	end)
end
-- Call setup events
setupPromptEvents()

-- Get new caracter
player.CharacterAdded:Connect(function(newChar:Model)
	local humanoid = newChar:WaitForChild("Humanoid")
	char = newChar
	PickUpUI = player.PlayerGui:WaitForChild("SPH_UI").PickUpUI

	local proxPromptService = game:GetService("ProximityPromptService")
	proxPromptService.Enabled = true

	humanoid.Died:Connect(function()
		proxPromptService.Enabled = false
	end)
end)