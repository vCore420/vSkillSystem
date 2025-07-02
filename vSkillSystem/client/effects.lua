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
        local ped = PlayerPedId()
        local player = PlayerId()
        local speedBonus = 0.20 * (level or 1)
        local healthPenalty = 0.10 * (level or 1)

        -- Movement speed
        local currentSpeed = GetRunSprintMultiplierForPlayer(player)
        local newSpeed = math.min(1.49, currentSpeed + speedBonus)
        SetRunSprintMultiplierForPlayer(player, newSpeed)

        -- Max health
        local baseHealth = 200 -- default player max health in GTA V
        local newMaxHealth = math.max(50, baseHealth * (1 - healthPenalty))
        SetEntityMaxHealth(ped, newMaxHealth)

        if debug then print(string.format("Berserker applied: +%.0f%% speed, -%.0f%% max health", speedBonus * 100, healthPenalty * 100)) end
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

    slowjumper = function(level)
        local ped = PlayerPedId()
        local player = PlayerId()
        local jumpBonus = 0.50 * (level or 1)
        local speedPenalty = 0.40 * (level or 1)

        -- Jump height
        SetPedJumpHeightMultiplier(ped, 1.0 + jumpBonus)

        -- Movement speed
        local currentSpeed = GetRunSprintMultiplierForPlayer(player)
        SetRunSprintMultiplierForPlayer(player, math.max(0.1, currentSpeed - speedPenalty))

       if debug then print(string.format("Slow Jumper applied: +%.0f%% jump height, -%.0f%% fall damage, -%.0f%% movement speed", jumpBonus * 100, fallBuff * 100, speedPenalty * 100)) end
    end,

    -- Add more effects here...
}

-- Revert Effects For Skills Here
SkillReverts = {

    berserker = function()
        local ped = PlayerPedId()
        local player = PlayerId()
        local speedBonus = 0.20 * (level or 1)
        local healthPenalty = 0.10 * (level or 1)

        -- Revert movement speed
        local currentSpeed = GetRunSprintMultiplierForPlayer(player)
        local newSpeed = math.max(1.0, currentSpeed - speedBonus)
        SetRunSprintMultiplierForPlayer(player, newSpeed)

        -- Revert max health
        local baseHealth = 200
        local newMaxHealth = baseHealth
        SetEntityMaxHealth(ped, newMaxHealth)

        if debug then print(string.format("Berserker reverted: -%.0f%% speed, +%.0f%% max health", speedBonus * 100, healthPenalty * 100)) end
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

    slowjumper = function()
        local ped = PlayerPedId()
        local player = PlayerId()
        local jumpBonus = 0.50 * (level or 1)
        local speedPenalty = 0.40 * (level or 1)

        -- Jump height
        SetPedJumpHeightMultiplier(ped, 1.0)

        -- Movement speed
        local currentSpeed = GetRunSprintMultiplierForPlayer(player)
        SetRunSprintMultiplierForPlayer(player, math.min(1.0, currentSpeed + speedPenalty))

        if debug then print(string.format("Slow Jumper reverted: -%.0f%% jump height, +%.0f%% fall damage, +%.0f%% movement speed", jumpBonus * 100, fallBuff * 100, speedPenalty * 100)) end
    end,

    -- Add more effect reverts here...
}