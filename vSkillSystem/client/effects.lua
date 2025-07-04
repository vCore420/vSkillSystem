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
        local currentSpeed = GetRunSprintMultiplierForPlayer(player)
        local newSpeed = math.min(1.49, currentSpeed + speedBonus)
        local baseHealth = 200 -- default player max health, need to make a way to track players current max and store increases and decreases to work with other skills, this will revert back to GTA 5 default when removed no matter how many health increase skills are equipped 
        local newMaxHealth = math.max(50, baseHealth * (1 - healthPenalty))

        -- Movement speed
        SetRunSprintMultiplierForPlayer(player, newSpeed)

        -- Max health
        SetEntityMaxHealth(ped, newMaxHealth)

        if debug then print(string.format("Berserker applied: +%.0f%% speed, -%.0f%% max health", speedBonus * 100, healthPenalty * 100)) end
    end,

    gunslinger = function(level)
        local ped = PlayerPedId()
        local currentAccuracy = GetPedAccuracy(ped)
        local currentReload = GetPedReloadSpeedMultiplier(ped)
        local accuracyBonus = 0.20 * (level or 1)
        local reloadBonus = 0.15 * (level or 1)
        
        -- Accuracy Buff
        SetPedAccuracy(ped, math.min(100, currentAccuracy + (accuracyBonus * 100)))
        
        -- Reload Buff
        SetPedReloadSpeedMultiplier(ped, currentReload + reloadBonus)

        if deBug then print(string.format("Gunslinger applied: +%.0f accuracy, +%.0f%% reload speed", accuracyBonus * 100, reloadBonus * 100)) end
    end,

    slowjumper = function(level)
        local ped = PlayerPedId()
        local player = PlayerId()
        local jumpBonus = 0.50 * (level or 1)
        local speedPenalty = 0.40 * (level or 1)
        local currentSpeed = GetRunSprintMultiplierForPlayer(player)

        -- Jump height
        SetPedJumpHeightMultiplier(ped, 1.0 + jumpBonus)

        -- Movement speed
        SetRunSprintMultiplierForPlayer(player, math.max(0.1, currentSpeed - speedPenalty))

       if debug then print(string.format("Slow Jumper applied: +%.0f%% jump height, -%.0f%% movement speed", jumpBonus * 100, speedPenalty * 100)) end
    end,

    medicsinstinct = function(level)
        local ped = PlayerPedId()
        local baseHealth = 200
        local healthPenalty = 0.10 * (level or 1)  -- 10% per level
        local regenRate = 0.02 * (level or 1)      -- 2% per level/sec
   			 local newMaxHealth = math.max(50, baseHealth * (1 - healthPenalty))
    		 SetEntityMaxHealth(ped, newMaxHealth)
        if GetEntityHealth(ped) > newMaxHealth then
            SetEntityHealth(ped, newMaxHealth)
        end

        if medicsInstinctRegenThread then
            medicsInstinctActive = false
            medicsInstinctRegenThread = nil
        end
        medicsInstinctActive = true
        medicsInstinctRegenThread = Citizen.CreateThread(function()
            while medicsInstinctActive do
                Citizen.Wait(1000)
                local maxHealth = GetEntityMaxHealth(ped)
                local health = GetEntityHealth(ped)
                if health > 0 and health < math.floor(maxHealth * 0.3) then
                    local regen = math.floor(maxHealth * regenRate)
                    SetEntityHealth(ped, math.min(health + regen, maxHealth))
                end
            end
        end)

       if debug then print(string.format("Medic's Instinct applied: -%.0f%% max health, +%.0f%%/sec regen below 30%% HP", healthPenalty * 100, regenRate * 100)) end
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
        local currentSpeed = GetRunSprintMultiplierForPlayer(player)
        local newSpeed = math.max(1.0, currentSpeed - speedBonus)
        local baseHealth = 200 -- this is where it will revert back to default instead of just taking off the added buff amount
        local newMaxHealth = baseHealth

        -- Revert movement speed
        SetRunSprintMultiplierForPlayer(player, newSpeed)

        -- Revert max health
        SetEntityMaxHealth(ped, newMaxHealth)

        if debug then print(string.format("Berserker reverted: -%.0f%% speed, +%.0f%% max health", speedBonus * 100, healthPenalty * 100)) end
    end,

    gunslinger = function()
        local ped = PlayerPedId()
        local currentAccuracy = GetPedAccuracy(ped)
        local currentReload = GetPedReloadSpeedMultiplier(ped)
        local accuracyBonus = 0.20 * (level or 1)
        local reloadBonus = 0.15 * (level or 1)
        
        -- Revert Accuracy Buff
        SetPedAccuracy(ped, math.max(0, currentAccuracy - (accuracyBonus * 100)))

        -- Revert Reload Buff
        SetPedReloadSpeedMultiplier(ped, math.max(0.1, currentReload - reloadBonus))

        if deBug then print(string.format("Gunslinger reverted: -%.0f accuracy, -%.0f%% reload speed", accuracyBonus * 100, reloadBonus * 100)) end
    end,

    slowjumper = function()
        local ped = PlayerPedId()
        local player = PlayerId()
        local jumpBonus = 0.50 * (level or 1)
        local speedPenalty = 0.40 * (level or 1)
        local currentSpeed = GetRunSprintMultiplierForPlayer(player)

        -- revert Jump height
        SetPedJumpHeightMultiplier(ped, 1.0)

        -- revert speed
        SetRunSprintMultiplierForPlayer(player, math.min(1.0, currentSpeed + speedPenalty))

        if debug then print(string.format("Slow Jumper reverted: -%.0f%% jump height, +%.0f%% movement speed", jumpBonus * 100, speedPenalty * 100)) end
    end,

    -- Add more effect reverts here...
}