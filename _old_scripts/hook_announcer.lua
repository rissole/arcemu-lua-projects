local ServerHooks = {
    "NEW_CHARACTER",
    "KILL_PLAYER",
    "FIRST_ENTER_WORLD",
    "ENTER_WORLD",
    "GUILD_JOIN",
    "DEATH",
    "REPOP",
    "EMOTE",
    "ENTER_COMBAT",
    "CAST_SPELL",
    "TICK",
    "LOGOUT_REQUEST",
    "LOGOUT",
    "QUEST_ACCEPT",
    "ZONE",
    "CHAT",
    "LOOT",
    "GUILD_CREATE",
    "ENTER_WORLD_2",
    "CHARACTER_CREATE",
    "QUEST_CANCELLED",
    "QUEST_FINISHED",
    "HONORABLE_KILL",
    "ARENA_FINISH",
    "OBJECTLOOT",
    "AREATRIGGER",
    "POST_LEVELUP",
    "PRE_DIE",
    "ADVANCE_SKILLLINE"
}


function AnnounceHook(event)
    SendWorldMessage("Server hook: "..ServerHooks[event], 1)
    SendWorldMessage("Server hook: "..ServerHooks[event], 2)
    print("Server hook: "..ServerHooks[event])
end

--[[for k,v in ipairs(ServerHooks) do
    RegisterServerHook(k, "AnnounceHook")
end]]