module("ss", package.seeall)


-- Project Source serverside functionality


reset = function () -- Set some default values. Definitely needs looking at and refining.
	send("firstaid reporting on")
	send("firstaid health 82")
	send("firstaid mana 82")
	send("firstaid forcehealth 65")
	send("firstaid forcemana 80")
	send("firstaid anabiotic health 75")
	send("firstaid anabiotic mana 75")
	send("firstaid vitals priority mana")
	send("firstaid stop mana below 55")
	send("firstaid curing on")
	send("firstaid heal health on")
	send("firstaid heal mana on")
	send("firstaid use anabiotic on")
	send("firstaid auto stand on")
	send("firstaid auto wake on")
	send("firstaid use tree on")
	send("firstaid use focus on")
	send("firstaid use endgame on")
	send("firstaid use insomnia on")
	send("firstaid use clot on")
	send("firstaid clot above 55")
	send("firstaid clot at 100")
	send("firstaid stupidity double on")
	send("firstaid adder 4")
	send("firstaid precache 3")
	send("firstaid on")
	send("firstaid cureset new slowcuringmode")
	send("firstaid cureset new general")
	send("firstaid cureset new genericpve")
	send("firstaid cureset new shaman")
	send("firstaid cureset new praenomen")
	send("firstaid cureset new sentinel")
	send("firstaid cureset new syssin")
	send("firstaid cureset new wayfarer")
end	