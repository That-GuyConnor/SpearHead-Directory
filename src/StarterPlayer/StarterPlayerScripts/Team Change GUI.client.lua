local repStorage = game:GetService('ReplicatedStorage')
local players = game:GetService('Players')
local teams = game:GetService('Teams')

local team1 = teams:WaitForChild('Alpha')
local team2 = teams:WaitForChild('Bravo')
local choosingTeam = teams:WaitForChild('Command')

local chooseEvent = repStorage:WaitForChild('ChooseTeam')
local plr = players.LocalPlayer
local screenGui = repStorage:WaitForChild('ScreenGui')

screenGui.ResetOnSpawn = false
screenGui.Parent = plr:WaitForChild("PlayerGui")

local function showPicker()
	if plr.Team == choosingTeam then
		screenGui.Enabled = true
	else
		screenGui.Enabled = false
	end
end

showPicker()

plr:GetPropertyChangedSignal('Team'):Connect(showPicker)

local blueButton = screenGui.Frame.AlphaButton
local redButton = screenGui.Frame.BravoButton

blueButton.MouseButton1Click:Connect(function()
	chooseEvent:FireServer(team1)
end)

redButton.MouseButton1Click:Connect(function()
	chooseEvent:FireServer(team2)
end)