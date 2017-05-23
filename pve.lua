module("pve", package.seeall)


-- Project Source PvE Functions

mobs_by_area = {
	ayhesa_cliffs = {
		"a Spellshaper Archon",
		"a Spellshaper Master",
		"a Spellshaper Adept",
	},

	arurer_haven = {
	},

	asper = {
	},

	azdun_dungeon = {
		"a medium pulsating spider",
		"a goblin miner",
		"a goblin mule",
		"a goblin soldier",
		"a goblin foreman",
	},

	arbothia = {
	},

	ashtan_bog = {
	},

	alaqsii_inlet = {
	},

	birka_mire = {
		"a bihrkaen ambusher",	
		"a horrifying bihrkaen",
		"a grotesque snapping turtle",
		"a mire hound",
		"a mire pup",
		"a slender mud adder",
		"a suffering Nerok",
	},

	black_keep = {
	},

	barony_of_dun_valley = {
	},

	bloodwood = {
		"a distressed spirit",
		"a lingering spirit",
		"a wailing spirit",
	},

	bastion_of_illdon = {
		"a rabid plant",
		"a rabid hound",
		"a shadowy, mindless demon",
		"a nightmare shadow",
		"a mutated experiment",
		"a trapped soul",
		"a young, Tsol'aa bandit",
		"a burly, Dwarven explorer",
	},

	caverns_of_mor = {
		"a vampiric sentry",
		"a vampiric warrior",
		"a stench-ridden ghoul",
		"a robed, skeletal lich",
		"a ravenous, shadowy ghast",
		"a skeletal warrior",
		"a shadow-clad lich",
		"Andrenus, a ghostly spirit",
		"Aclyr, the vampiric general",
	},

	chapel_garden = {
	},

	court_of_the_consortium = {
	},

	caverns_of_telfinne = {
	},

	dolbodi_campsite = {
		"a great white stag",
		"a burly lumberjack",
		"a brawny hunter",
		"a slender forager",
		"a lithe buckawn",
		"a grizzly foreman",
		"Hrungwil, the Dolbodi lumberjack",
		"Perine, Dolbodi forager",
	},

	djeir = {
	},

	drakuum = {
		"a misty apparition",
	},

	dungeon_of_the_beastlords = {
	},

	dakhota_hills = {
	},

	eastern_itzatl_rainforest = {
	},

	feral_caves = {
		"a gigantic green blob",
	},

	festering_wastes = {
	},

	fengard_keep = {
		"an ogre berserker",
		"a vicious horned garwhol",
		"a massive argobole",
		"a fiery phenkyre",
		"a pious invoker",
		"a brawny glaive knight",
		"a radiant lumore",
		"a pungent lichosphere",
		"a horrid basilwyrm",
		"a shrieking grimshrill",
		"an ethereal construct",
	},

	forgotten_dome = {
		"a gibbering kelki reaver",
		"a deformed kelki ravener",
		"a mutated kelki ravager",
		"a vile kelki prowler",
	},

	halls_of_tornos = {
	},

	hashan = {
	},

	iernian_fracture = {
	},

	isle_of_ollin = {
	},

	ilhavon_forest = {
	},

	kalydian_forest = {
		"a ravenous squirrel",
		"a rabid rabbit",
		"a gaunt elk",
	},

	khauskin_mines = {
		"a soft-shelled klikkin",
		"a grotesque fangtooth",
		"a vampiric blood guard",
		"a vampiric blood sentry",
		"a burly Dwarven miner",
		"a statuesque Dwarven guard",
		"a powerful Dwarven warrior",
		"a stout Dwarven man",
		"a stocky Dwarven woman",
		"a Dwarven girl",
		"Khuldar, the bartender",
		"Khabarak, the jeweler",
		"Gordak, Leader of Khauskin",
		"Belok, the mining chief",
	},

	liruma_scrublands = {
	},

	lich_gardens = {
		"a guardian wraith",
		"a monstrous Infernal guard",
		"a dark Cabalist scholar",
		"a studious lich scientist",
		"a student of the lich",
		"a half-mindless Mhun monk",
		"a mindless experiment",
		"a tattered Bahkatu experiment",
		"a towering Atabahi general",
	},

	moghedu = {
		"a Mhun bodyguard",
		"the Mhun Captain of the Guard",
		"a master Mhun miner",
		"a Mhun warrior",
		"a Mhun guard",
		"a Mhun miner",
	},

	morgun_forest = {
	},

	mamashi_tunnels = {
	},

	mamashi_grasslands = {
	},

	mannaseh_swamp = {
	},

	["the Maghuir Fissure"] = {
		"an amorphous black umbra",
		"a darkly robed priest",
	},

	mhojave_desert = {
	},

	naljin_depths = {
	},

	raugol_fissure = {
	},

	ruins_of_farsai = {
	},

	ruins_of_masilia = {
		"Fermian, excavation foreman",
		"Head Archeologist, Dolus",
		"Halim, the bartender",
		"a drunken archeologist",
		"a drunken excavator",
		"a Dwarven archeologist",
		"a Dwarven excavator",
		"a Masilidean etherealist",
		"a Masilidean physicalist",
		"a Masilidean mentalist",
		"a Masilidean focus",
		"a corrupted hackle",
		"a ravenous locust",
		"a mutated hare",
	},

	rebels_ridge = {
	},

	riparium = {
	},

	raim_vale = {
	},

	salma_settlement = {
		"a Salmati warrior",
		"a Salmati guard",
		"a robust blacksmith",
		"an engrossed scholar",
		"a wild-eyed scientist",
		"an ordinary woman",
		"an unclean miner",
		"a busy mage",
		"a common man",
		"a bemused artist",
		"a wealthy merchant",
		"Linette, the Salmati Architect",
		"Dima, Captain of the Salmati Guard",
		"Kyros, the Salmati leader",
	},

	siroccian_tunnels = {
	},

	siroccian_mountains = {
	},

	southern_tundra = {
	},

	scidve = {
	},

	shattered_vortex = {
		"a withered crone",
		"a sharp-toothed gremlin",
		"a bubonis",
		"a chaos orb",
		"a humbug",
		"a chaos hound",
		"a chimera",
		"a chaos storm",
		"a pathfinder",
		"a minion of chaos",
		"a dervish",
		"a bloodleech",
		"an ethereal firelord",
		"a warped turtle",
		"a soulmaster",
		"a warped indorani",
		"a strained indorani",
		"a crazed indorani",
		"a sciomancer mage",
		"a reinforcement warrior of the aztob",
		"a chaos worm",
		"a petrified treant",
	},

	tarean_ice_caverns = {
	},

	["The village of Bihrkaen"] ={
		"a purple speckled dildo"
	}

	tiyen_esityi = {
		"a crazed Nazetu cutter",
		"the creature beneath Tiyen Esityi",
		"Tirahl the Necromancer",
		"a ball of chitinous legs",
		"a mutated Nazetu intercessor",
		"insubstantial whispers",
		"Lieutenant Chiakhi",

	--non-aggressive
		"a supply officer",
		"a cancerous stallion",
		"a Nazetu captain",
		"a bound shade",
		"a Nazetu halberdier",
		"a deformed Nazetu priest",
		"a Nazetu crossbowman",
		"a Nazetu necromancer",
		"a Nazetu provost",
		"a tangible malevolence",
		"a Nazetu corrupter",
		"a victimised intruder",
		"a massive, sacred serpent",
	},

	temple_of_ati = {
	},

	torturers_caverns = {
		"a rank ghoul",
		"Kerr'ach, the Lich",
		"a maggot-ridden skeleton",
		"a vampiric overseer",
		"a flesh golem sentry",
		"a hulking ghast",
		"a blood construct",
		"a vile inquisitor",
		"Tuera, the torturer",
		"a scheming terramancer",
	},

	three_rock_outpost = {
		"the cave bear, White Ghost",
		"an enormous Troll bandit",
		"a shifty bandit",
		"a huge, scarred wildcat",
		"a wildcat kitten",
		"a mountain wildcat",
		"a long-haired buffalo",
		"a beautiful wild horse",
	},

	temple_of_sonn = {
	},

	tainhelm = {
	},

	tcanna_island = {
		"a brown and tan python",
		"a blue crab",
		"a box jellyfish",
		"a Troll guard",
		"a tailless Rajamala",
		"a Horkvali butcher",
		"a Troll cook",
		"an Atavian slave",
		"a pathetic slave",
		"a Nazetu officer",
		"a black and white badger",
		"a ragged coyote",
		"a spotted jaguar",
		"a gray wolf",
		"a lithe cougar",
		"a black bear",
		"a spotted jaguar",
		"a white-tailed deer",
		"an enormous elephant",
		"a spotted leopard",
		"a striped tiger",
		"a howler monkey",
		"a large capybara",
		"a small ocelot",
		"a water buffalo",
	},

	volcano = {
	},

	village_of_torston = {
	},

	vilimo_fields = {
	},

	western_tundra = {
	},

	western_itzatl_rainforest = {
	},

	xaanhal = {
		"a cautious Xorani guard",
		"a merciless Xorani warrior",
		"a wiry Xorani guard",
		"a suspicious Xorani patrol",
		"Caelakan, an arrogant prince",
		"a bejeweled Xorani harem girl",
		"an arrogant Xorani master at arms",
		"a willowy nest guardian",
	}
}


function init()
	local delay = tempTimer(0.1, [[pve:get_mobs()]])
end
 

function get_mobs()
	local area = gmcp.Room.Info.area
	local mobs = pve.mobs_by_area[area]

	tmp.to_bash = {}

	for k, v in pairs(tmp.roomitems) do
		if next(tmp.roomitems) then
			if table.contains(mobs, v.name) then
				table.insert(tmp.to_bash, v.id)
				mmp.stop()
			else
				local delay = tempTimer(0.1, [[genrun:continue()]])
			end
		end	
	end

	if not tmp.bash_target_acquired then
		local delay = tempTimer(0.1, [[tmp.target = (next(tmp.to_bash) and tmp.to_bash[1] or "Nothing")]])
		tmp.bash_target_acquired = true
	end
end


function bash()
	local delay = tempTimer(0.1, [[send("combo "..tmp.target.." sdk ucp ucp")]])
end