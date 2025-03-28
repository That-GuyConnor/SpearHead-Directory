local wepStats = {}

--< Weapon type >--
wepStats.weaponType = "Gun"
wepStats.projectile = "Bullet" -- Projectile models can be put in the Projectiles folder, if a model isn't found then default bullets are used.

wepStats.magType = 3
--[[ Ammo 
1 = This gun is magazine fed.
2 = This gun must have bullets inserted manually. (Shotguns, revolvers, etc)
3 = This gun can have bullets inserted manually, but also has clips.
If you want the gun's capacity to be higher than its clip size, add a setting called wepStats.clipSize.
2 and 3 will use their reload anim for shell insertion.
3 requires a clipReloadAnim animation setting.
]]

wepStats.operationType = 3
--[[ V Operation Type Guide V
1 = Gun can be reloaded with the bolt closed, chambering is only necessary when there's no round in the chamber.
2 = The bolt should be opened before reloading if the gun is empty.
3 = The bolt should always be opened before reloading.
4 = This gun doesn't have a bolt, it's a rocket launcher or a laser gun or smth.
]]

--< Gun settings >--
wepStats.fireRate = 150
wepStats.muzzleChance = 5 -- Number from 0-10 that determines how often the muzzle will flash when firing
wepStats.muzzleVelocity = 750 -- this stat uses meters per second
wepStats.aimSpeed = 0.3 -- 0-1 how much should the aim speed be multiplied by
wepStats.gunLength = 5.3 -- How close you can get to a surface before the viewmodel moves back
wepStats.maxPushback = 1.5 -- How far can the viewmodel move backwards until the gun is blocked

wepStats.fireSwitch = {
	false, -- Semi
	false, -- Auto
	false, -- Burst
	true -- Manual (bolt/pump action)
}
wepStats.fireMode = 4 -- Default mode from the above table
wepStats.burstNumber = 3 -- If this gun can fire in bursts, what should the shot limit be?
wepStats.burstFireRate = nil -- Use this if you want a separate burst fire rate, leave it as nil if you want to use the regular fire rate

wepStats.spread = 0 -- Adds some random variation to the bullet direction
wepStats.shotgun = false
wepStats.shotgunPellets = 10 -- If shotgun is true, how many pellets should be fired at once?

wepStats.aimFovMin = 20
wepStats.aimTime = 0.7

wepStats.suppressionLevel = 2 -- How much should this gun suppress people?

wepStats.holster = true -- Add gun models to the your character when they aren't equipped
wepStats.holsterPart = "Torso" -- The body part to attach the gun model to
wepStats.holsterPosition = CFrame.new(1.244, -0.912, 0.574) * CFrame.Angles(math.rad(-21),math.rad(4),math.rad(6))

wepStats.calcEjectionForce = function()
	return Vector3.new(
		math.random(50,100) / 10, -- Side to side
		math.random(200,250) / 10, -- Up
		math.random(50,100) / 10 -- Front
	)
end

wepStats.ADSEnabled = { -- Ignore this setting if not using an ADS Mesh
	true, -- Enabled for primary sight
	false -- Enabled for secondary sight (T)
}

-- Damage
wepStats.damage = {
	Head = 150,
	Torso = 50,
	Other = 30, -- Default damage if body part is not included
}

-- Tracers
wepStats.tracers = false
wepStats.tracerTiming = 4 -- Every x number of shots will be a tracer
wepStats.tracerColor = Color3.fromRGB(255, 55, 55)

-- Ammo
wepStats.ammoType = "7.62×54mmR" -- Gun shell models can be found in ReplicatedStorage > SPH_Assets > Shells
wepStats.shellEject = true -- Should this gun eject shells?
wepStats.magazineCapacity = 5 -- Max ammo that can go in a mag
wepStats.clipSize = 5
wepStats.arcadeAmmo = true -- Don't disable this until the new ammo system is added
wepStats.startAmmoPool = 40 -- How much ammo should the gun start with?
wepStats.maxAmmoPool = 40 -- How much ammo can this gun hold?

wepStats.infiniteAmmo = false
wepStats.startChambered = true -- Start with a round in the chamber?

-- Physics
wepStats.bulletDrop = true -- Bullet drop based on workspace.Gravity
wepStats.bulletForce = 300 -- If a bullet hits something unanchored, this force is applied

-- Viewmodel
wepStats.viewmodelOffset = CFrame.new(0,0.2,-0.3) -- Where should the viewmodel be placed in reference to the camera
wepStats.serverOffset = CFrame.new(0,0,0) -- Where should the viewmodel be placed in reference to the player's head

-- Animation
wepStats.idleAnim = "BoltRifle_Idle" -- Animations are located in ReplicatedStorage > SPH_Assets > Animations
wepStats.sprintAnim = "Rifle_Sprint"
wepStats.reloadAnim = "BoltRifle_BulletInsert"
wepStats.clipReloadAnim = "BoltRifle_ClipInsert"
wepStats.boltChamber = "BoltRifle_Chamber" -- Plays if the bolt is closed
wepStats.boltOpen = "BoltRifle_BoltOpen"
wepStats.boltClose = "BoltRifle_BoltClose" -- Plays if the bolt is open
wepStats.equipAnim = "Rifle_Equip"
wepStats.patrolAnim = "Rifle_Sprint"
wepStats.holdUpAnim = "Rifle_Neutral"
wepStats.holdDownAnim = nil
wepStats.switchAnim = "Rifle_Switch"

wepStats.reloadSpeedModifier = 0.8 -- 1 = Normal speed, higher = faster, lower = slower

wepStats.rigParts = {"Mag","Bolt","Clip","Bullet"} -- These parts will have their welds replaced with Motor6Ds in case they need to be animated
wepStats.fireMoveParts = {} -- These parts will move when firing

wepStats.boltDist = 0.45 -- Distance the bolt will move when firing (Make this number negative for open bolt guns!)
wepStats.emptyLockBolt = true -- Lock the bolt back after firing last round
wepStats.emptyCloseBolt = false -- Close the bolt if the player tries to fire with no bullet in the chamber
wepStats.autoChamber = false -- Chamber the gun after reloading if needed

-- Camera recoil
wepStats.recoil = {
	vertical = 2, -- Vertical recoil
	horizontal = 1, -- Horizontal recoil
	camShake = 3, -- Camera shake
	damping = 1, -- How "springy" should the recoil be
	speed = 10, -- How quickly the recoil force will be recovered from
	aimReduction = 2 -- Recoil is divided by this when aiming
}

-- Gun recoil
wepStats.gunRecoil = {
	vertical = 10, -- Vertical recoil
	horizontal = 1, -- Horizontal recoil
	damping = 3, -- How "springy" should the recoil be
	speed = 5, -- How quickly the recoil force will be recovered from
	punchMultiplier = 0.5, -- How much the gun moves back during recoil
}

return wepStats
