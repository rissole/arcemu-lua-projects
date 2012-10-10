---------------------------
----MODIFY STARTS HERE-----
---------------------------

local DOME_ENTRY = 10 --the game object dome that surrounds players
local MIMI_ENTRY = 24437 --replace with entries
local GAREN_ENTRY = 514
local YUNA_ENTRY = 515

local trialsDb = {} --no modify
trialsDb[MIMI_ENTRY] = {} --no modify
trialsDb[GAREN_ENTRY] = {} --no modify
trialsDb[YUNA_ENTRY] = {} --no modify
trialsDb[MIMI_ENTRY].senseiString = "a" --no modify
trialsDb[GAREN_ENTRY].senseiString = "b" --no modify
trialsDb[YUNA_ENTRY].senseiString = "c" --no modify

--------------------------------------------------------
--Settings. If you need any more per-trainer customisation, let me know.
--Methinks Yuna will need some custom-overrides at points in the code, ill handle that when it comes.

trialsDb[MIMI_ENTRY].rank = 1 --rank they train from
trialsDb[GAREN_ENTRY].rank = 1
trialsDb[YUNA_ENTRY].rank = 2

trialsDb[MIMI_ENTRY].preReqQuest = 0 --the quest ID that has to be turned in before the fight
trialsDb[GAREN_ENTRY].preReqQuest = 20
trialsDb[YUNA_ENTRY].preReqQuest = 0 --you can make it 0 if no quest is pre-required.

trialsDb[MIMI_ENTRY].reqKills = 0 --kills needed for the rank
trialsDb[GAREN_ENTRY].reqKills = 100
trialsDb[YUNA_ENTRY].reqKills = 500

trialsDb[MIMI_ENTRY].wrongRankId = 1 --npc_text entry for Talking to when they are the wrong rank. ex. "I'm sorry, $N, but I only train Rank 1 Ronin."
trialsDb[GAREN_ENTRY].wrongRankId = 1
trialsDb[YUNA_ENTRY].wrongRankId = 1
trialsDb[MIMI_ENTRY].alreadyDefeatedId = 2 --npc_text entry for Talking to whoever after they've already beaten. ex. "You've already beaten me, perhaps try Garen."
trialsDb[GAREN_ENTRY].alreadyDefeatedId = 2
trialsDb[YUNA_ENTRY].alreadyDefeatedId = 2
trialsDb[MIMI_ENTRY].readyToStartId = 3 --npc_text entry for Talking to whoever when you have enough kills. ex. "You've done well, $N. Just say the word and we'll begin."
trialsDb[GAREN_ENTRY].readyToStartId = 3
trialsDb[YUNA_ENTRY].readyToStartId = 3
trialsDb[MIMI_ENTRY].notEnoughKillsId = 4 --npc_text entry for Talking to whoever when you don't have enough kills. ex. "Remember $N, 100 slain warriors until I'll train you."
trialsDb[GAREN_ENTRY].notEnoughKillsId = 4
trialsDb[YUNA_ENTRY].notEnoughKillsId = 4

---------------------------
--DO NOT MODIFY PAST HERE--...except maybe some messages.
---------------------------

--[[-----------------------
----------NOTES------------
---------------------------

trial info
An npc will mark where each Master will move to upon initiating the trial. You must place them, and also add them to DB.
Each waypoint npc should be named: "Trials - NPCNAME Waypoint"
where NPCNAME is the applicable npc's FULL NAME. eg "Garen Thunderblade" not just "Garen".

An npc will mark where each Master will move unwanted players to upon initiating the trial. You must place them, and also add them to DB.
Each waypoint npc should be named: "Trials - NPCNAME Ptele Waypoint"
where NPCNAME is the applicable npc's FULL NAME. eg "Garen Thunderblade" not just "Garen".

An npc will mark where each player should be positioned before the master will bow. You must place them, and also add them to DB.
Each waypoint npc should be named: "Trials - NPCNAME Player Waypoint"
where NPCNAME is the applicable npc's FULL NAME. eg "Garen Thunderblade" not just "Garen".

There WILL be quests for each rank. A spell will be cast at the end of each fight when the player wins.
This will clear the objective of the quest.
So for each rank, one sensei will cast 52852 and the other will cast 52994.
Your quest should require both of those spells as the objectives. They are just dummy spells that do nothing.

Please make each pair of senseis have consecutive entry ids. As in 101 and 102. This is for determining which victory spell to cast.

---------------------------
---------END NOTES---------
-----------------------]]--

TRIALS = {}

function TRIALS.getSenseiString(player)
   local s = CharDBQuery("SELECT senseis_defeated FROM ronin WHERE name = '"..player:GetName().."'")
   if (s == false) then
      CharDBQuery("INSERT INTO `ronin` (`name`) VALUES ('"..player:GetName().."')")
      return ""
   end
   return s
end

function TRIALS.findWaypoint(pUnit, name)
   local mytab = {}
   print("in findWaypoint")
   for k,v in pairs(pUnit:GetInRangeUnits()) do
      print("looping through units")
      if (v:GetName() == name) then
         mytab.x = v:GetX()
         mytab.y = v:GetY()
         mytab.z = v:GetZ()
         mytab.o = v:GetO()
         mytab.unit = v
         print("found a waypoint of: "..name)
         return mytab
      end
   end
end

function TRIALS.OnSpawn(pUnit)
   local def_flags = tonumber(WorldDBQuery("SELECT npcflags FROM creature_proto WHERE entry = "..pUnit:GetEntry()))
   pUnit:SetUInt32Value(0x52, def_flags) --UNIT_NPC_FLAGS
   pUnit:SetOutOfCombatRange(99999) --never out of combat!
end

function TRIALS.OnGossipTalk(pUnit, event, player)
   local ent = pUnit:GetEntry()
   local sensei_string = TRIALS.getSenseiString(player)
   if (player:GetPlayerLevel() < trialsDb[ent].rank) then --wrong rank, noob
      pUnit:GossipCreateMenu(trialsDb[ent].wrongRankId, player, 0)
      pUnit:GossipSendMenu(player)
   elseif (string.find(sensei_string, trialsDb[ent].senseiString) ~= nil) then --already defeated
      pUnit:GossipCreateMenu(trialsDb[ent].alreadyDefeatedId, player, 0)
      pUnit:GossipSendMenu(player)
   elseif (player:HasFinishedQuest(trialsDb[ent].preReqQuest) or trialsDb[ent].preReqQuest == 0) then --not defeated but has finished quest/no pre req
      local kills = player:GetUInt32Value(0x4b2) --PLAYER_FIELD_LIFETIME_HONORBALE_KILLS
      if (kills >= trialsDb[ent].reqKills) then --they've got enough kills
         pUnit:GossipCreateMenu(trialsDb[ent].readyToStartId, player, 0)
         pUnit:GossipMenuAddItem(9, "Train me, Sensei. I wish to become stronger!", 20, 0)
         pUnit:GossipMenuAddItem(0, "Not yet, Sensei.", 21, 0)
         pUnit:GossipSendMenu(player)
      else  --not enough kills
         pUnit:GossipCreateMenu(trialsDb[ent].notEnoughKillsId, player, 0)
         pUnit:GossipSendMenu(player)
      end
   else
      pUnit:GossipCreateMenu(65535, player, 0)
      pUnit:GossipSendMenu(player)
   end
   --other ones here after completion: spell training, light gossip
end

function TRIALS.OnGossipSelect(pUnit, event, player, id, intid, code)
   if (intid == 20) then
      player:GossipComplete()
      print("intid was 20")
      pUnit:SetMovementFlags(0)
      pUnit:SetUInt32Value(0x52, 0) --UNIT_NPC_FLAGS
      local wp = TRIALS.findWaypoint(pUnit, "Trials - "..pUnit:GetName().." Waypoint")
      pUnit:MoveTo(wp.x, wp.y, wp.z, wp.o)
      pUnit:SendChatMessage(12, 0, player:GetName()..", please take your place over there.")
      local pp = TRIALS.findWaypoint(pUnit, "Trials - "..pUnit:GetName().." Player Waypoint")
      pp.unit:CastSpell(6767) --Mark of Shame
      if (pUnit:GetInRangePlayersCount() > 1) then
         pUnit:EventChat(12, 0, "I'm also going to ask everyone else to leave. This is an individual challenge.", 3000)
      end
      RegisterTimedEvent("TRIALS.BeginTrialPart2", 8000, 1, pUnit, player)
   elseif (intid == 21) then
      player:GossipComplete()
   end
end

function TRIALS.BeginTrialPart2(pUnit, player)
   pUnit:SetMovementFlags(1)
   TRIALS[tostring(pUnit)] = {}
   TRIALS[tostring(pUnit)].dome = pUnit:SpawnGameObject(DOME_ENTRY, pUnit:GetX(), pUnit:GetY(), pUnit:GetZ(), pUnit:GetO(), 100)
   local wp = TRIALS.findWaypoint(pUnit, "Trials - "..pUnit:GetName().." Ptele Waypoint")
   for k,v in pairs(pUnit:GetInRangePlayers()) do
      if (tostring(v) ~= tostring(player)) then
         pUnit:SendChatMessageToPlayer(15, 0, "You must leave since the trial is on. You may return when it is over.", v)
         v:Teleport(pUnit:GetMapId(), wp.x, wp.y, wp.z, wp.o)
      end
   end
   TRIALS.checkPlayerPosition(pUnit, player)
   RegisterTimedEvent("TRIALS.expireWaiting", 20000, 1, pUnit, player, 0)
end

function TRIALS.expireWaiting(pUnit, player, elapsed)
   elapsed = elapsed + 20000
   if (elapsed == 20000) then
      pUnit:SendChatMessage(12, 0, "Are we fighting or what?")
      RegisterTimedEvent("TRIALS.expireWaiting", 20000, 1, pUnit, player, elapsed)
   elseif (elapsed == 40000) then
      pUnit:SendChatMessage(12, 0, "I grow tired of your delays, "..player:GetName()..".")
      RegisterTimedEvent("TRIALS.expireWaiting", 20000, 1, pUnit, player, elapsed)
   elseif (elapsed == 60000) then
      pUnit:SendChatMessage(12, 0, "I'm not going to waste any more time with you, "..player:GetName()..". Come back when you're truly ready.")
      TRIALS.endTrial(pUnit, player)
   end
end

function TRIALS.endTrial(pUnit, player)
   pUnit:Despawn(1, 60000)
   player:SetPlayerLock(0)
   TRIALS[tostring(pUnit)].dome:Despawn(0, 0)
   TRIALS[tostring(pUnit)] = nil
end

function TRIALS.checkPlayerPosition(pUnit, player)
   if (type(TRIALS[tostring(pUnit)]) == "nil") then return; end
   local pp = TRIALS.findWaypoint(pUnit, "Trials - "..pUnit:GetName().." Player Waypoint")
   if (player:GetDistanceYards(pp.unit) < 5) then --in position already
      pUnit:SendChatMessage(12, 0, "Good, you're in position. Just bow to me when you're ready to begin.")
      player:SetPlayerLock(1)
      TRIALS[tostring(pUnit)].waitingPlayer = player
      pUnit:Emote(2, 1500)
      pUnit:SendChatMessage(16, 0, pUnit:GetName().." bows down, ready for the trial.")
   else
      RegisterTimedEvent("TRIALS.checkPlayerPosition", 500, 1, pUnit, player)
   end
end

function TRIALS.OnEmote(pUnit, event, player, emoteId)
   local t = TRIALS[tostring(pUnit)]
   if (type(t) == "nil") then 
      return
   elseif (t.waitingPlayer ~= nil) then
      if (tostring(t.waitingPlayer) == tostring(player) and emoteId == 2) then --correct player and bowing
         RegisterTimedEvent("TRIALS.trialCountdown", 1500, 1, pUnit, player, 4)
      end
   end   
end

function TRIALS.trialCountdown(pUnit, player, countdown)
   if (countdown < 4) then
      pUnit:SendChatMessage(42, 0, countdown)
      RegisterTimedEvent("TRIALS.trialCountdown", 1000, 1, pUnit, player, countdown - 1)
   elseif (countdown > 1) then
      TRIALS.trialCountdown(pUnit, player, 3)
   else
      player:SetPlayerLock(0)
      pUnit:SetFaction(14)
      pUnit:Attack(player)
      if (pUnit:GetEntry() == MIMI_ENTRY) then
         TRIALS.mimiStartFight(pUnit, player)
      end
   end
end

function TRIALS.mimiStartFight(pUnit, player)
   pUnit:CastSpellOnTarget(32021, player)
   RegisterTimedEvent("TRIALS.mimiPhase1", 1000, 1, pUnit, player)
   RegisterTimedEvent("TRIALS.mimiPhase2", 1000, 1, pUnit, player)
   RegisterTimedEvent("TRIALS.checkHealths", 500, 1, pUnit, player)
end

function TRIALS.mimiPhase1(pUnit, player)
   if (pUnit:GetHealthPct() <= 75) then
      pUnit:CastSpellOnTarget(44424, player)
      local x = player:GetX()+math.random(10)
      local y = player:GetY()+math.random(10)
      local z = pUnit:GetLandHeight(x, y)
      pUnit:MoveTo(x, y, z, 0)
      RegisterTimedEvent("TRIALS.mimiFeatherBurst", 2000, 1, pUnit, player)
   else
      RegisterTimedEvent("TRIALS.mimiPhase1", 1000, 1, pUnit, player)
   end
end

function TRIALS.mimiPhase2(pUnit, player)
   if (pUnit:GetHealthPct() <= 25) then
      pUnit:CastSpell(39584)
      local x = player:GetX()+math.random(10)
      local y = player:GetY()+math.random(10)
      local z = pUnit:GetLandHeight(x, y)
      pUnit:MoveTo(x, y, z, 0)
      RegisterTimedEvent("TRIALS.mimiFeatherBurst", 2000, 1, pUnit, player)
   else
      RegisterTimedEvent("TRIALS.mimiPhase2", 1000, 1, pUnit, player)
   end
end

function TRIALS.mimiFeatherBurst(pUnit, player)
   pUnit:SetFacing(pUnit:CalcRadAngle(pUnit:GetX(), pUnit:GetY(), player:GetX(), player:GetY()))
   pUnit:SetOrientation(pUnit:CalcRadAngle(pUnit:GetX(), pUnit:GetY(), player:GetX(), player:GetY()))
   pUnit:FullCastSpellOnTarget(39068, player) --feather burst
end

function TRIALS.checkHealths(pUnit, player)
   if (pUnit:GetHealthPct() <= 5) then --player wins
      pUnit:RemoveNegativeAuras()
      player:RemoveNegativeAuras()
      pUnit:SetFaction(35)
      if (pUnit:GetEntry() % 2 == 0) then
         player:FullCastSpell(52852) --"Victory" spell
      else
         player:FullCastSpell(52994) --"Duel Victory" spell
      end
      pUnit:Emote(20, 1500) --EMOTE_ONESHOT_BEG
      pUnit:SendChatMessage(12, 0, "Gah, I am defeated! You have done well.") --def needs changing
      pUnit:EventChat(12, 0, "Now, move on. A long road remains ahead.", 3000) --def needs changing
      local ss = TRIALS.getSenseiString(player)
      CharDBQuery("UPDATE ronin SET senseis_defeated = CONCAT(senseis_defeated, '"..ss.."') WHERE name = "..player:GetName())
      RegisterTimedEvent("TRIALS.endTrial", 6000, 1, pUnit, player)
   elseif (player:GetHealthPct() <= 5) then --pUnit wins
      pUnit:RemoveNegativeAuras()
      player:RemoveNegativeAuras()
      pUnit:SetFaction(35)
      player:Emote(20, 1500) --EMOTE_ONESHOT_BEG
      pUnit:SendChatMessage(12, 0, "Well, "..player:GetName()..", it looks like you're just not ready.") --def needs changing
      pUnit:EventChat(12, 0, "Feel free to speak to me when you're ready.", 3000) --def needs changing
      RegisterTimedEvent("TRIALS.endTrial", 6000, 1, pUnit, player)
   else
      RegisterTimedEvent("TRIALS.checkHealths", 500, 1, pUnit, player)
   end
end

for k,v in pairs(trialsDb) do
   RegisterUnitEvent(k, 18, "TRIALS.OnSpawn")
   RegisterUnitGossipEvent(k, 1, "TRIALS.OnGossipTalk")
   RegisterUnitGossipEvent(k, 2, "TRIALS.OnGossipSelect")
   RegisterUnitEvent(k, 22, "TRIALS.OnEmote")
end