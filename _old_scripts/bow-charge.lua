function Charger_OnEmote(pUnit, event, pPlayer, emoteId)
   pUnit:EventChat(12, 0, "Rawr", 1000)
   pUnit:EventChat(12, 0, "Rawr again", 2000)
   pUnit:EventChat(14, 0, "I SAID RAWR!!!", 4000)
   pUnit:EventChat(12, 0, "why aren't you running?", 8000)
   if (emoteId == 2) then --bow
      pUnit:CastSpellOnTarget(11578, pPlayer)
      pUnit:ReturnToSpawnPoint()
      --pPlayer:SendBattlegroundWindow(12)
   end
end

RegisterUnitEvent(84776, 22, "Charger_OnEmote")