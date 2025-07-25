-- todo -
-- make the gacha spins cost a in game item or money - make a congif lua for this
-- make upgrading skill cost too by item or money **, add cap for skill levels
-- make server.lua where the inventory, levels and equiped skills can be saved to the database
-- make function to pull skill data from DB and apply to player
-- make a config.lua for the gacha cost and upgrade cost

--------------------------------------
-- vSkillSystem ----------------------
--------------------------------------
local deBug = Config.deBug
local currentEffects = {}

-- Skill Effects and Reverts
RegisterNUICallback("updateEquipped", function(data, cb)
    local equipped = data.equipped or {}
    local player = PlayerId()
    currentEffects[player] = currentEffects[player] or {}

    -- 1. Revert effects for slots that changed or were cleared
    for slot = 1, 3 do
        local prevSkill = currentEffects[player][slot]
        local newSkill = equipped[slot] and equipped[slot].id or nil
        if prevSkill and prevSkill ~= newSkill then
            if deBug then print(("Reverting effect for slot %d: %s"):format(slot, prevSkill)) end
            if SkillReverts[prevSkill] then
                SkillReverts[prevSkill]()
            end
        end
    end

    -- 2. Apply new effects and update tracking
    for slot = 1, 3 do
        local skill = equipped[slot]
        if skill and skill.id and currentEffects[player][slot] ~= skill.id then
            if deBug then print(("Applying effect for slot %d: %s"):format(slot, skill.id)) end
            if SkillEffects[skill.id] then
                SkillEffects[skill.id](skill.level or 1)
            end
            currentEffects[player][slot] = skill.id
        elseif not skill or not skill.id then
            currentEffects[player][slot] = nil
        end
    end
    cb("ok")
end)

-- Commands to open/close the skills UI
RegisterCommand("vskills", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "showSkills" })
end, false)

RegisterNUICallback("closeSkills", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hideSkills" })
    cb('ok')
end)
