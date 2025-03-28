local materialAssignments = {
	[Enum.Material.Neon] = "Metal";
	[Enum.Material.Grass] = "Ground";
	[Enum.Material.Ground] = "Ground";
	[Enum.Material.Glass] = "Glass";
	[Enum.Material.CorrodedMetal] = "Metal";
	[Enum.Material.Ice] = "Glass";
	[Enum.Material.Mud] = "Ground";
	[Enum.Material.Sand] = "Ground";
	[Enum.Material.Snow] = "Ground";
	[Enum.Material.Wood] = "Wood";
	[Enum.Material.Metal] = "Metal";
	[Enum.Material.Water] = "Water";
	[Enum.Material.ForceField] = "Metal";
	[Enum.Material.Foil] = "Metal";
	[Enum.Material.Carpet] = "Fabric";
	[Enum.Material.Fabric] = "Fabric";
	[Enum.Material.Marble] = "Stone";
	[Enum.Material.Rubber] = "Fabric";
	[Enum.Material.Asphalt] = "Stone";
	[Enum.Material.Glacier] = "Stone";
	[Enum.Material.Granite] = "Stone";
	[Enum.Material.Leather] = "Fabric";
	[Enum.Material.Plaster] = "Stone";
	[Enum.Material.Plastic] = "Stone";
	[Enum.Material.Pavement] = "Stone";
	[Enum.Material.Cardboard] = "Ground";
	[Enum.Material.Limestone] = "Stone";
	[Enum.Material.Sandstone] = "Stone";
	[Enum.Material.LeafyGrass] = "Ground";
	[Enum.Material.WoodPlanks] = "Wood";
	[Enum.Material.Cobblestone] = "Stone";
	[Enum.Material.CrackedLava] = "Stone";
	[Enum.Material.CeramicTiles] = "Stone";
	[Enum.Material.DiamondPlate] = "Metal";
	[Enum.Material.RoofShingles] = "Stone";
	[Enum.Material.ClayRoofTiles] = "Stone";
	[Enum.Material.Concrete] = "Stone";
	[Enum.Material.Rock] = "Stone";
	[Enum.Material.SmoothPlastic] = "Stone";
	[Enum.Material.Salt] = "Stone";
	[Enum.Material.Brick] = "Stone";
	[Enum.Material.Slate] = "Stone";
	[Enum.Material.Basalt] = "Stone";
	[Enum.Material.Pebble] = "Stone";
}
 
local GetMaterialType = function(material)
	return materialAssignments[material] or "Stone"
end

return GetMaterialType
