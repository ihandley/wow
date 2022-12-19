function()
    if not aura_env.config.Name then return false end
    if aura_env.teamNum == 0 then return false end
    
    aura_env.btn = aura_env.btn or CreateFrame("Button", aura_env.buttonName, WeakAuras.GetRegion(aura_env.id), "SecureActionButtonTemplate")
    aura_env.btn:SetAllPoints()
    
    if aura_env.config.autoCage then    
        local total = C_PetJournal.GetNumPets()       
        
        for i = 1, total do
            local petID, spec, _, _, level = C_PetJournal.GetPetInfoByIndex(i)
            if aura_env.cageList[spec] and level == 25 and (not C_PetJournal.PetIsSlotted(petID)) then
                local collected, maxCollected = C_PetJournal.GetNumCollectedInfo(spec)
                if collected == maxCollected then
                    if aura_env.checkPerSecond() then
                        C_PetJournal.CagePetByID(petID)
                    end
                end
            end
        end
        
        for k,v in pairs(aura_env.cageList) do            
            --# k, v = spec, {bag, slot, linkString}
            local collected, maxCollected = C_PetJournal.GetNumCollectedInfo(k)
            if collected < maxCollected then
                
                aura_env.btn:SetAttribute("type", "item")
                aura_env.btn:SetAttribute("item", string.format("%d %d", v[1], v[2]))  
                
                if aura_env.checkPerSecond() then
                    aura_env.setBindingClick()
                end                      
                
                aura_env.text = "Adopt ".. v[3]
                
                return true
            end                        
            
        end    
    end
    
    local target = UnitName("target")
    
    if aura_env.config.safari and PlayerHasToy(92738) and (not WA_GetUnitBuff("player", 158486)) then
        aura_env.btn:SetAttribute("type", "item")
        aura_env.btn:SetAttribute("item", GetItemInfo(92738))
        local safari = GetItemInfo(92738) or ""
        if aura_env.checkPerSecond() then
            aura_env.setBindingClick()
        end
        aura_env.text = "Use "..safari
        
        return true
        
    elseif aura_env.config.tenlands and (not WA_GetUnitBuff("player", 289982)) and GetItemCount(166751) > 0 then
        aura_env.btn:SetAttribute("type", "item")
        aura_env.btn:SetAttribute("item", GetItemInfo(166751))
        local tenlands = GetItemInfo(166751) or ""
        if aura_env.checkPerSecond() then
            aura_env.setBindingClick()
        end
        aura_env.text = "Use "..tenlands
        
        return true        
        
    elseif (not target) or (target ~= aura_env.config.Name) then
        if aura_env.config.Sternfathom and GetZoneText() == C_Map.GetAreaInfo(7334) and GetItemCooldown(122681) == 0 then
            aura_env.btn:SetAttribute("type", "item")
            aura_env.btn:SetAttribute("item", GetItemInfo(122681))
            
            if aura_env.checkPerSecond() then
                aura_env.setBindingClick()
            end
            aura_env.text = "Use "..GetItemInfo(122681)
            
            return true
            
        else
            aura_env.btn:SetAttribute("type", "macro")
            aura_env.btn:SetAttribute("macrotext1", "/tar "..aura_env.config.Name)
            
            if aura_env.checkPerSecond() then
                aura_env.setBindingClick()
            end
            aura_env.text = "Target NPC: "..aura_env.config.Name
            
            return true
        end
        
    else
        if (not aura_env.config.AutoInteract) then
            
            local distance = select(2, WeakAuras.GetRange("target")) --# we use the max distance
            if distance and (distance > aura_env.config.interactDistance) then
                aura_env.btn:SetAttribute("type", "macro")
                aura_env.btn:SetAttribute("macrotext1", "/cleartarget")
                
                if aura_env.checkPerSecond() then
                    aura_env.setBindingClick()
                end
                aura_env.text = string.format("target distance: %d\ncleartarget", distance)
                
                return true
            end            
        end        
        
        if aura_env.config.reviveOnCooldown and GetSpellCooldown(125439) == 0 then
            aura_env.btn:SetAttribute("type", "spell")
            aura_env.btn:SetAttribute("spell", (GetSpellInfo(125439)))
            
            if aura_env.checkPerSecond() then
                aura_env.setBindingClick()
            end
            aura_env.text = "Revive Pets"
            
        elseif not aura_env.currentTeamInList() then            
            aura_env.btn:SetAttribute("type", "macro")
            aura_env.btn:SetAttribute("macrotext1", "/rematch "..aura_env.Teams[1])
            
            if aura_env.checkPerSecond() then
                aura_env.setBindingClick()
            end
            aura_env.text = "Loading for team1"
            
        elseif aura_env.currentTeamHealthy() then
            if aura_env.checkPerSecond() then
                if aura_env.config.Binding ~= ""  then
                    SetBinding(aura_env.config.Binding, "INTERACTTARGET")
                end
            end
            aura_env.text = "Current Team: ".. RematchSettings.loadedTeam
            
            return true
        elseif not aura_env.teamsAllUnhealthy() then
            aura_env.unhealthyTeams[RematchSettings.loadedTeam] = true
            
            local currentIndex = aura_env.getCurrentTeamIndex() or 0                
            local nextTeam = (currentIndex + 1) > aura_env.teamNum and 1 or (currentIndex + 1)
            
            aura_env.btn:SetAttribute("type", "macro")
            aura_env.btn:SetAttribute("macrotext1", "/rematch "..aura_env.Teams[nextTeam])
            
            if aura_env.checkPerSecond() then
                aura_env.setBindingClick()
            end
            aura_env.text = "Current Team: ".. RematchSettings.loadedTeam .. "\n\124cffff0000<unhealthy>\124r"
            
            return true
        else
            if GetSpellCooldown(125439) == 0 then
                aura_env.btn:SetAttribute("type", "spell")
                aura_env.btn:SetAttribute("spell", (GetSpellInfo(125439)))
            elseif aura_env.config.Bandage then
                aura_env.btn:SetAttribute("type", "item")
                aura_env.btn:SetAttribute("item", (GetItemInfo(86143)))
            else
                aura_env.btn:SetAttribute("type", "spell")
                aura_env.btn:SetAttribute("spell", (GetSpellInfo(125439)))
            end
            
            if aura_env.checkPerSecond() then
                aura_env.setBindingClick()
            end
            aura_env.text = "Revive Pets"
            
            return true
        end
    end
    
    return true
end

