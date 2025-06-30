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
        print("Apply Berserker effect, level:", level) -- have made it to that point, need to expand from here 30/6
    end,
    gunslinger = function(level)
        -- Skill logic here
        print("Apply Gunslinger effect, level:", level)
    end,
    -- Add more skills effects here...
}

-- Revert Effects For Skills Here
SkillReverts = {
    berserker = function()
        -- Your revert logic here
        print("Revert Berserker effect") -- have made it to that point, need to expand from here 30/6
    end,
    gunslinger = function()
        -- Your revert logic here
        print("Revert Gunslinger effect")
    end,
    -- Add more effect reverts here...
}