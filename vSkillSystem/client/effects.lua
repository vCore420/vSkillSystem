-- todo -
-- add more skills - over in the JS - and make pics for them 
-- create effects and reverts for skills
-- Expand on effects and add  extra abilities or drawbacks for skills when paired with other skills

--------------------
-- Skill Effects
--------------------

-- These are called when a skill is equipped or unequipped.

-- Add Effect For Skills Heres
SkillEffects = {
    berserker = function(level)
        -- Skill logic here
        if deBug then print("Apply Berserker effect, level:", level) end -- have made it to that point, need to expand from here 30/6 
    end,
    gunslinger = function(level)
        -- Skill logic here
        if deBug then print("Apply Gunslinger effect, level:", level) end
    end,
    -- Add more skills effects here...
}

-- Revert Effects For Skills Here
SkillReverts = {
    berserker = function()
        -- Your revert logic here
        if deBug then print("Revert Berserker effect") end -- have made it to that point, need to expand from here 30/6
    end,
    gunslinger = function()
        -- Your revert logic here
        if deBug then print("Revert Gunslinger effect") end
    end,
    -- Add more effect reverts here...
}