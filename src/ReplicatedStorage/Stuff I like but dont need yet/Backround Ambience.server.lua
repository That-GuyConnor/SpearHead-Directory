-- Get the SoundService (this is crucial!)
local SoundService = game:GetService("SoundService")

-- Create the Sound object
local gunfireSound = Instance.new("Sound")
gunfireSound.SoundId = "rbxassetid://108602347894797"  -- Replace with your actual ID!
gunfireSound.Looped = true
gunfireSound.Volume = 0.2  -- Adjust for desired loudness
gunfireSound.Name = "PTSD"
-- Parent the sound to SoundService (this is where it belongs!)
gunfireSound.Parent = SoundService

-- Start playing the sound
gunfireSound:Play()