
-- This loads the files in the engine, gearbox, fuel, and gun folders!
-- Go edit those files instead of this one.
-- Thanks ferv <3

AddCSLuaFile()

ACF.Weapons.Rack = ACF.Weapons.Rack or {}
ACF.Classes.Rack = ACF.Classes.Rack or {}

ACF.Weapons.Radar = ACF.Weapons.Radar or {}
ACF.Classes.Radar = ACF.Classes.Radar or {}

local Racks =           ACF.Weapons.Rack
local RackClasses =     ACF.Classes.Rack

local Radars =           ACF.Weapons.Radar
local RadarClasses =     ACF.Classes.Radar

-- setup base classes
local gun_base = {
	ent = "acf_gun",
	type = "Guns"
}

local rack_base = {
	ent =   "acf_rack",
	type =  "Rack"
}

local radar_base = {
	ent =   "acf_missileradar",
	type =  "Radar"
}

-- add gui stuff to base classes if this is client
if CLIENT then
	gun_base.guicreate = function(_, Table) ACFGunGUICreate(Table) end
	gun_base.guiupdate = function() return end

	radar_base.guicreate = function(_, Table) ACFRadarGUICreate(Table) end
	radar_base.guiupdate = function() return end
end

function ACF_DefineRack(ID, Data)
	Data.id = ID

	for K, V in pairs(rack_base) do
		if not Data[K] then
			Data[K] = V
		end
	end

	Racks[ID] = Data
end

function ACF_DefineRackClass(ID, Data)
	Data.id = ID

	RackClasses[ID] = Data
end

function ACF_DefineRadar(ID, Data)
	Data.id = ID

	for K, V in pairs(radar_base) do
		if not Data[K] then
			Data[K] = V
		end
	end

	Radars[ID] = Data
end

function ACF_DefineRadarClass(ID, Data)
	Data.id = ID

	RadarClasses[ID] = Data
end

local Weapons = list.GetForEdit("ACFEnts")
local Classes = list.GetForEdit("ACFClasses")

-- some factory functions for defining ents
function ACF_defineGunClass( ID, Data )
	Data.id = ID

	Classes.GunClass[ID] = Data
	ACF.Classes.GunClass[ID] = Data

	local Blacklist = Data.ammoBlacklist
	if Blacklist then
		for _, V in pairs(Blacklist) do
			local AmmoBlackList = ACF.AmmoBlacklist[V]

			AmmoBlackList[#AmmoBlackList + 1] = ID
		end
	end
end

function ACF_defineGun(ID, Data)
	Data.id = ID
	Data.round.id = ID

	for K, V in pairs(gun_base) do
		if not Data[K] then
			Data[K] = V
		end
	end

	Weapons.Guns[ID] = Data
	ACF.Weapons.Guns[ID] = Data
end

-- Getters for guidance names, for use in missile definitions.

local function GetAllInTableExcept(Table, List)
	for K, V in ipairs(List) do
		List[V] = K
		List[K] = nil
	end

	local Result = {}

	for K in pairs(Table) do
		if not List[K] then
			Result[#Result + 1] = K
		end
	end

	return Result
end

function ACF_GetAllGuidanceNames()
	local Result = {}

	for K in pairs(ACF.Guidance) do
		Result[#Result + 1] = K
	end

	return Result
end

function ACF_GetAllGuidanceNamesExcept(List)
	return GetAllInTableExcept(ACF.Guidance, List)
end

-- Getters for fuse names, for use in missile definitions.

function ACF_GetAllFuseNames()
	local Result = {}

	for K, _ in pairs(ACF.Fuse) do
		Result[#Result + 1] = K
	end

	return Result
end

function ACF_GetAllFuseNamesExcept(List)
	return GetAllInTableExcept(ACF.Fuse, List)
end

aaa_IncludeShared("acf/shared/missiles")
aaa_IncludeShared("acf/shared/guns")
aaa_IncludeShared("acf/shared/radars")

ACF.RoundTypes = list.Get("ACFRoundTypes")
ACF.IdRounds = list.Get("ACFIdRounds")	--Lookup tables so i can get rounds classes from clientside with just an integer
