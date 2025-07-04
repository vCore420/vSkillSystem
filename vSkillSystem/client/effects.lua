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

        -- Set Max Health
    		 SetEntityMaxHealth(ped, newMaxHealth)
        if GetEntityHealth(ped) > newMaxHealth then
            SetEntityHealth(ped, newMaxHealth)
        end

        -- Check loop isn't already running
        if medicsInstinctRegenThread then
            medicsInstinctActive = false
            medicsInstinctRegenThread = nil
        end

       -- Start check for player health below 30% then start the health regen 
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

    energizer = function(level)
        local ped = PlayerPedId()
        local player = PlayerId()
        local drainMult = 0.5 -- 50% per level, will need to add logic to increase slowly from here with upgrades as currently level maxs it out
        local regenMult = 0.5 -- 50% per level

        -- Save original player values
        if not energizer_originalMultipliers then
            energizer_originalMultipliers = {
                sprint = GetPlayerSprintStaminaMultiplier(player),
                regen = GetPlayerStaminaRechargeMultiplier(player)
            }
        end

        -- Apply stamina drain reduction
        SetPlayerSprintStaminaMultiplier(player, drainMult)

        -- Apply stamina regen penalty
        SetPlayerStaminaRechargeMultiplier(player, regenMult)

        if debug then print("Energizer applied: -50% stamina drain, -50% stamina regen") end
    end,

    garbagedetonator = function(level)
        local ped = PlayerPedId()
        local explosionPower = 1.0 * (level or 1)
        local selfDamagePercent = 0.10 * (level or 1) -- maybe rework this one so the drawback gets decreased as the skill gets leveled up
        if garbagedetonatorThread then
            garbagedetonatorActive = false
            garbagedetonatorThread = nil
        end
        garbagedetonatorActive = true

        garbagedetonatorThread = Citizen.CreateThread(function()
            -- List of rubbish bin models
            local binHashes = {
                GetHashKey("prop_bin_01a"),
                GetHashKey("prop_bin_02a"),
                GetHashKey("prop_bin_03a"),
                GetHashKey("prop_bin_04a"),
                GetHashKey("prop_bin_05a"),
                GetHashKey("prop_bin_06a"),
                GetHashKey("prop_bin_07a"),
                GetHashKey("prop_bin_07b"),
                GetHashKey("prop_bin_07c"),
            }
            local lastExplosion = 0

            while garbagedetonatorActive do
                Citizen.Wait(100)
                local pos = GetEntityCoords(ped)
                for _, hash in ipairs(binHashes) do
                    -- Search for bins nearby
                    local obj = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.2, hash, false, false, false)
                    if obj and obj ~= 0 then
                        -- Prevent constant triggering (cooldown)
                        if (GetGameTimer() - lastExplosion) > 1500 then
                            local binPos = GetEntityCoords(obj)
                            AddExplosion(binPos.x, binPos.y, binPos.z, 29, explosionPower, true, false, 1.0)
                            lastExplosion = GetGameTimer()

                            -- Apply self-damage
                            local health = GetEntityHealth(ped)
                            local damage = math.floor(100 * selfDamagePercent)
                            SetEntityHealth(ped, math.max(health - damage, 0))

                            if debug then print("Garbage Detonator: Bin exploded! Self-damage applied.") end
                        end
                    end
                end
            end
        end)

        if debug then print("Garbage Detonator effect applied: bins explode on touch, player takes splash damage.") end
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

    medicsinstinct = function()
        local ped = PlayerPedId()
        local baseHealth = 200

        -- Revert Player Max Health
        SetEntityMaxHealth(ped, baseHealth)
        if GetEntityHealth(ped) > baseHealth then
            SetEntityHealth(ped, baseHealth)
        end

        -- End Regen Loop
        medicsInstinctActive = false
        medicsInstinctRegenThread = nil

        if debug then print("Medic's Instinct reverted: max health restored, regen stopped") end
    end,

    energizer = function()
        local player = PlayerId()
        local defaultSprint = 1.0
        local defaultRegen = 1.0

        -- Set Health stats to players saved values, or reset to defaults
        if energizer_originalMultipliers then
            SetPlayerSprintStaminaMultiplier(player, energizer_originalMultipliers.sprint or defaultSprint)
            SetPlayerStaminaRechargeMultiplier(player, energizer_originalMultipliers.regen or defaultRegen)
            energizer_originalMultipliers = nil
        else
            SetPlayerSprintStaminaMultiplier(player, defaultSprint)
            SetPlayerStaminaRechargeMultiplier(player, defaultRegen)
        end

        if debug then print("Energizer reverted: stamina drain and regen restored") end
    end,

    -- Add more effect reverts here...
}