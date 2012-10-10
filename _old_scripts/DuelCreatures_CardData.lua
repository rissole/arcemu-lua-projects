--Initialising card data table
--item id
----1 = name
----2 = class (MONSTER|MAGIC|TRAP)
----3 = element (DARK|EARTH|FIRE|LIGHT|WATER|WIND)
----4 = stars
----5 = displayid
----6 = type (BEAST|DEMON|DRAGONKIN|ELEMENTAL|HUMANOID|MECHANICAL|UNDEAD)
----7 = description
----8 = attack points
----9 = defense points
CardData = {}

CardData[70002] = {"Kobold Vermin","MONSTER","DARK",3,10913,"HUMANOID",
"Kobold are small creatures; the vermin the lowest of workers that reside in mines.", 600, 500}

CardData[70003] = {"Gift of the Night Elf","TRAP","LIGHT",-1,-1,-1,
"Increases your Life Points by 300 for each monster on the field.", -1, -1}

CardData[70004] = {"Nether Hole","MAGIC","DARK",-1,-1,-1,
"Destroys all monsters on the field.", -1, -1}

------------

function AllCards_OnGossip(pItem, event, player)
	local entry = pItem:GetEntryId()
	local name = CardData[entry][1]
	local class = CardData[entry][2]
	local element = CardData[entry][3]
	local stars = CardData[entry][4]
	local type = CardData[entry][6]
	local desc = CardData[entry][7]
	local atk = CardData[entry][8]
	local def = CardData[entry][9]

	pItem:GossipCreateMenu(70001,player,0)
	if (class == "MONSTER") then
		pItem:GossipMenuAddItem(10,name,0,0)
		pItem:GossipMenuAddItem(10,stars.." stars",1,0)
		pItem:GossipMenuAddItem(10,class.." CARD",2,0)
		pItem:GossipMenuAddItem(10,element.." - "..type,3,0)
		pItem:GossipMenuAddItem(7,desc,4,0)
		pItem:GossipMenuAddItem(9,"Attack: "..atk,5,0)
		pItem:GossipMenuAddItem(9,"Defense: "..def,6,0)
	elseif (class == "MAGIC" or class == "TRAP") then
		pItem:GossipMenuAddItem(10,name,0,0)
		pItem:GossipMenuAddItem(10,class.." CARD",0,0)
		pItem:GossipMenuAddItem(10,element,0,0)
		pItem:GossipMenuAddItem(7,desc,0,0)
	end
	pItem:GossipSendMenu(player)
end

for k,v in pairs(CardData) do
	RegisterItemGossipEvent(k,1,"AllCards_OnGossip")
end
