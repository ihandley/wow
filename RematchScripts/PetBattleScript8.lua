aura_env.currentTeamHealthy = function()
    local healthy = {
        [1]=true,
        [2]=true,
        [3]=true,
    }
    
    for i = 1, 3 do 
        local petID = C_PetJournal.GetPetLoadOutInfo(i)
        if not petID then 
            healthy[i] = false
        else
            local _, _, level = C_PetJournal.GetPetInfoByPetID(petID)
            local health, maxHealth = C_PetJournal.GetPetStats(petID)
            if level == 25 then --# We don't check health for low level pets, as they usually do not fight.
                if (not health) or (health < maxHealth * aura_env.config.HealthyPercentage * 0.01) then
                    healthy[i] = false
                end    
            end
        end        
    end
    
    local count = 3
    for k,v in pairs(healthy) do
        if not v then
            count = count - 1 
        end
    end
    
    if count >= aura_env.config.HealthyNum then
        return true
    end
    
    return false
end

aura_env.Teams = {}
aura_env.unhealthyTeams = {}
aura_env.teamNum = 0

for i = 1, 15 do
    if aura_env.config["Team"..i] ~= "" and aura_env.config["UseTeam"..i] then
        aura_env.Teams[ #aura_env.Teams+1] = aura_env.config["Team"..i]
        aura_env.teamNum = aura_env.teamNum + 1
    end    
end

aura_env.getCurrentTeamName = function()
    local currentTeam = RematchSettings.loadedTeam
    
    if(type(currentTeam) == "number" and RematchSaved and RematchSaved[currentTeam] ~= nil and RematchSaved[currentTeam].teamName ~= nil) then
        return RematchSaved[currentTeam].teamName
    else 
        return RematchSettings.loadedTeam
    end
end

aura_env.getCurrentTeamIndex = function()
    local currentTeam = aura_env.getCurrentTeamName()
    for k,v in pairs(aura_env.Teams) do
        if v == currentTeam then
            return k
        end
    end
end

aura_env.currentTeamInList = function()
    local currentTeam = aura_env.getCurrentTeamName()
    for k,v in pairs(aura_env.Teams) do
        if v == currentTeam then
            return true
        end
    end
    
    return false
end

aura_env.teamsAllUnhealthy = function()
    for k,v in pairs(aura_env.Teams) do
        if not aura_env.unhealthyTeams[v] then
            return false
        end
    end
    return true
end

aura_env.buttonName = "waAutoRematch"
aura_env.time = 0

aura_env.setBindingClick = function()
    if aura_env.config.Binding == ""  then return false end
    SetBindingClick(aura_env.config.Binding, aura_env.buttonName)
end

aura_env.checkPerSecond = function()
    local time = time()
    if aura_env.time ~= time then
        aura_env.time = time
        return true
    end
    return false
end

if aura_env.config.AutoInteract then
    SetCVar("autoInteract", 1)
else
    SetCVar("autoInteract", 0)    
end

aura_env.autoCageSkips = {}
for word in string.gmatch(string.gsub(aura_env.config.autoCageSkips,"%s*", ""), '([^,]+)') do
    local name = string.gsub(string.gsub(word, "%[*",""), "%]*", "")
    if name then
        local spec = C_PetJournal.FindPetIDByName(name)
        if spec then
            aura_env.autoCageSkips[tonumber(spec)] = true
        end
    end
end

aura_env.cageList = {}

