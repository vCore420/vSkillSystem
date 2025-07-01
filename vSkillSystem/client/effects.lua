-- todo -
-- add more skills - over in the JS - and make pics for them 
-- create effects and reverts for skills
-- Expand on effects and add  extra abilities or drawbacks for skills when paired with other skills

--------------------
-- Skill Effects
--------------------
-- These are called the moment a skill is equipped or unequipped.

-- Add Effect For Skills Heres
SkillEffects = {

    berserker = function(level)
        -- Skill logic here
        if deBug then print("Apply Berserker effect, level:", level) end -- have made it to that point, need to expand from here 30/6 
    end,

    gunslinger = function(level)
        local ped = PlayerPedId()
        local currentAccuracy = GetPedAccuracy(ped)
        local currentReload = GetPedReloadSpeedMultiplier(ped)

        -- Calculate bonuses
        local accuracyBonus = 0.20 * (level or 1)
        local reloadBonus = 0.15 * (level or 1)
        
        -- Add Accuracy Buff to Player
        SetPedAccuracy(ped, math.min(100, currentAccuracy + (accuracyBonus * 100)))
        
        -- Add Reload Buff to Player
        SetPedReloadSpeedMultiplier(ped, currentReload + reloadBonus)

        if deBug then print(string.format("Gunslinger applied: +%.0f accuracy, +%.0f%% reload speed", accuracyBonus * 100, reloadBonus * 100)) end
    end,

    -- Add more effects here...
}

-- Revert Effects For Skills Here
SkillReverts = {

    berserker = function()
        -- Your revert logic here
        if deBug then print("Revert Berserker effect") end -- have made it to that point, need to expand from here 30/6
    end,

    gunslinger = function()
        local ped = PlayerPedId()
        local currentAccuracy = GetPedAccuracy(ped)
        local currentReload = GetPedReloadSpeedMultiplier(ped)

        -- Calculate the same bonuses so we can subtract them
        local accuracyBonus = 0.20 * (level or 1)
        local reloadBonus = 0.15 * (level or 1)
        
        -- Remove Accuracy Buff from Player
        SetPedAccuracy(ped, math.max(0, currentAccuracy - (accuracyBonus * 100)))

        -- Remove Reload Buff from Player
        SetPedReloadSpeedMultiplier(ped, math.max(0.1, currentReload - reloadBonus))

        if deBug then print(string.format("Gunslinger reverted: -%.0f accuracy, -%.0f%% reload speed", accuracyBonus * 100, reloadBonus * 100)) end
    end,

    -- Add more effect reverts here...
}