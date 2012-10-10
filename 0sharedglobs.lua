OBJECT_END = 0x0006
UNIT_NPC_FLAGS = OBJECT_END + 0x004C
UNIT_FIELD_FLAGS = OBJECT_END + 0x0035
UNIT_DYNAMIC_FLAGS = 78
U_DYN_FLAG_DEAD = 32
UNIT_FLAG_NOT_ATTACKABLE_2 = 0x02
UNIT_FLAG_NOT_SELECTABLE = 0x2000000
PLAYER_FARSIGHT = 624
PLAYER_FIELD_LIFETIME_HONORBALE_KILLS = 1228
PLAYER_FIELD_KILLS = 1225
PLAYER_FLAGS = 150
GAMEOBJECT_BYTES_1 = 17
GAMEOBJECT_FLAGS = 9
UNIT_NPC_EMOTESTATE = 83
UNIT_FIELD_BYTES_1 = 74

function table.find(t, v)
    if type(t) == "table" and v then
        for k, val in pairs(t) do
            if v == val then
                return k
            end
        end
    end
    return false
end