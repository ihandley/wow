function(e)
    local target = UnitName("target")
    local options = C_GossipInfo.GetOptions()
    
    if target and target == aura_env.config.Name then
        if aura_env.config.GossipOption > 0 then
            C_GossipInfo.SelectOption(options[1].gossipOptionID)
            
            return true
        end
    end
end

