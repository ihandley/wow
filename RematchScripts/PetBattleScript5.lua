function(e)
    if e == "BAG_UPDATE" or e == "WA_DELAYED_PLAYER_ENTERING_WORLD" then
        if aura_env.config.autoCage then
            
            aura_env.cageList = {}
            
            for b = 0, 4 do
                for s = 1, 50 do
                    
                    local linkString = GetContainerItemLink(b, s)
                    if linkString then
                        local spec, level = string.match(linkString, "|Hbattlepet:(%d+):(%d+)")
                        if spec then
                            spec, level = tonumber(spec), tonumber(level)
                            
                            if level < 25 and (not aura_env.autoCageSkips[spec]) then
                                aura_env.cageList[spec] = {b, s, linkString}
                                
                            end
                        end
                    end
                    
                end
            end
            
            return true
        end
    end
end

