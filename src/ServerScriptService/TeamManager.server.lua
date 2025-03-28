local repStorage = game:GetService('ReplicatedStorage')
local players = game:GetService('Players')
local teams = game:GetService('Teams')

local team1 = teams:WaitForChild('Bravo') -- Assuming Bravo is Red/Team 1 visually
local team2 = teams:WaitForChild('Alpha') -- Assuming Alpha is Blue/Team 2 visually
local choosingTeam = teams:WaitForChild('Command')

local chooseEvent = repStorage:WaitForChild('ChooseTeam')

-- Define the maximum allowed player difference between teams
local MAX_TEAM_DIFFERENCE = 2

local function onEvent(playerFrom, teamChosen)
	-- Ensure the player isn't already on the team they are trying to join
	if playerFrom.Team == teamChosen then
		print(playerFrom.Name .. " is already on team " .. teamChosen.Name)
		return -- Do nothing if already on the chosen team
	end

	-- Handle choosing the 'Command' team (usually for returning to selection)
	if teamChosen == choosingTeam then
		playerFrom.Team = choosingTeam
		if playerFrom.Character then
			playerFrom.Character:Destroy() -- Force respawn in neutral spawn
		else
			-- If player has no character (maybe initial join failed?), load them into choosing team spawn
			playerFrom:LoadCharacter()
		end
		return -- Exit function after setting to choosing team
	end

	-- --- Team Balancing Logic ---
	local team1Players = team1:GetPlayers()
	local team2Players = team2:GetPlayers()
	local count1 = #team1Players
	local count2 = #team2Players

	local canJoinTeam = false

	-- Check if the chosen team is team1 (Bravo)
	if teamChosen == team1 then
		-- Check if adding a player to team1 would exceed the max difference
		-- Formula: (Prospective Team1 Count) - (Team2 Count) <= Max Difference
		if (count1 + 1) - count2 <= MAX_TEAM_DIFFERENCE then
			canJoinTeam = true
		else
			print(playerFrom.Name .. " cannot join Bravo. Difference too large.")
			-- Optional: Send a message back to the player explaining why
			-- e.g., using another RemoteEvent:FireClient(playerFrom, "TeamFull")
		end

		-- Check if the chosen team is team2 (Alpha)
	elseif teamChosen == team2 then
		-- Check if adding a player to team2 would exceed the max difference
		-- Formula: (Prospective Team2 Count) - (Team1 Count) <= Max Difference
		if (count2 + 1) - count1 <= MAX_TEAM_DIFFERENCE then
			canJoinTeam = true
		else
			print(playerFrom.Name .. " cannot join Alpha. Difference too large.")
			-- Optional: Send a message back to the player explaining why
		end
	else
		-- Handle cases where an unexpected team object was sent (though unlikely with current client script)
		warn("Player", playerFrom.Name, "tried to join unexpected team:", teamChosen)
		return
	end
	-- --- End Balancing Logic ---

	-- If the balance check allows the player to join
	if canJoinTeam then
		playerFrom.Team = teamChosen
		playerFrom:LoadCharacter() -- Respawn the player onto their new team
		print(playerFrom.Name .. " joined team " .. teamChosen.Name)
	else
		-- If they couldn't join, they remain on their current team.
		-- The print statement above already notified the server console.
		-- No action needed here unless you want to send client feedback.
		-- For example: repStorage.TeamJoinFailedEvent:FireClient(playerFrom, "That team is currently full due to team balance.")
	end
end

local function onPlayerJoined(player)
	-- Set player initially to the choosing team
	player.Team = choosingTeam
	player:LoadCharacter() -- Load character initially in the choosing area

	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild('Humanoid')
		humanoid.Died:Once(function()
			-- Check if they are on a playable team before auto-respawning
			if player.Team == team1 or player.Team == team2 then
				task.wait(players.RespawnTime)
				-- Double check character hasn't changed (e.g. player left)
				if player.Character == character and player.Parent then
					player:LoadCharacter()
				end
				-- Else: If they died on the 'Command' team, they stay dead until they pick a team again
			end
		end)
	end)

	--- OPTIONAL, UNCOMMENT THE CODE BELOW IF YOU WANT TO ALLOW PLAYERS TO SWITCH TEAMS WHILE PLAYING!
	--[[
	player.Chatted:Connect(function(message)
		if string.lower(message) == "/pickteam" or string.lower(message) == "/jointeam" then -- Example commands
			-- Use the onEvent function to handle moving them back to the choosing team
			onEvent(player, choosingTeam)
		end
	end)
	]]
end

chooseEvent.OnServerEvent:Connect(onEvent)
players.PlayerAdded:Connect(onPlayerJoined)

-- Handle players leaving to maintain balance accuracy (though GetPlayers updates automatically)
players.PlayerRemoving:Connect(function(player)
	-- No specific action needed here for balancing logic itself,
	-- as GetPlayers() won't include the removed player.
	-- Just good practice to be aware of this event.
end)