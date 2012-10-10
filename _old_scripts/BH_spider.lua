-----------------------
--Made by Hypersniper--
-------wow-v.com-------
--For Burning Heavens--
-----------------------
--===NEW STANDARDS===--
-----------------------

DREADWEAVER = {}

function DREADWEAVER.combat(pUnit)
    pUnit:SendChatMessage(16, 0, "Dreadweaver smells its prey.")
    pUnit:RegisterEvent("Dreadweaver_poison", 5000, 0)
    pUnit:RegisterEvent("Dreadweaver_knockweb", 20000, 0)
end

function DREADWEAVER.death(pUnit)
    pUnit:SendChatMessage(16, 0, "Dreadweaver curls up as it is slain.")
    pUnit:RemoveEvents()
end

function DREADWEAVER.leavecombat(pUnit)
    pUnit:RemoveEvents()
end

function DREADWEAVER.poison(pUnit)
    pUnit:FullCastSpellOnTarget(30917, pUnit:GetRandomPlayer(0))
end

function DREADWEAVER.knockweb(pUnit)
    pUnit:CastSpell(52029)
    pUnit:RegisterEvent("Dreadweaver_knockweb2", 1000, 1)
end

function DREADWEAVER.knockweb2(pUnit)
    local players = pUnit:GetInRangePlayers()
    for k,v in pairs(players) do
        if (pUnit:GetDistanceYards(v) <= 20) then
            pUnit:CastSpellOnTarget(53322, v)
        end
    end
end

RegisterUnitEvent(8000017, 1, "DREADWEAVER.combat")
RegisterUnitEvent(8000017, 2, "DREADWEAVER.leavecombat")
RegisterUnitEvent(8000017, 4, "DREADWEAVER.death")