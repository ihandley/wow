function(e, ...)
    if e == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, _, spellID = ...
        if (not unit) or (not spellID) then return false end
        
        if unit == "player" then
            if spellID == 133994 or spellID == 125439 then
                
                aura_env.unhealthyTeams = {}
                return true
            end
        end
    elseif e == "PET_BATTLE_CLOSE" then
        aura_env.unhealthyTeams = {}
    end
end

