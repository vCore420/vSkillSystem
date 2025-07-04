// List of Skills, add more skills here as needed
const skills = [
    // Player Skills
    {
        id: "berserker",
        label: "Berserker",
        type: "player",
        image: "berserker.png",
        description: "Increases player speed, but lowers health.",
        buffs: { speed: 0.20 },
        drawbacks: { health: -0.10 },
        level: 1,
        rarity: "common",
        gachaChance: 0.8
    },
    {
        id: "slowjumper",
        label: "Slow Jumper",
        type: "player",
        image: "slowjumper.png",
        description: "Boosts players Jump height but reduces players movement speed.",
        buffs: { jump: 0.50 },
        drawbacks: { speed: -0.40 },
        level: 1,
        rarity: "common",
        gachaChance: 0.8
    },
    {
        id: "medicsinstinct",
        label: "Medic's Instinct",
        type: "player",
        image: "medicsinstinct.png",
        description: "Slowly regenerate health when below 30% HP, but your max health is slightly reduced.",
        buffs: { regen: 0.02 }, // 2% health/sec regen
        drawbacks: { maxHealth: -0.10 },
        level: 1,
        rarity: "rare", 
        gachaChance: 0.6
    },
    {
        id: "energizer",
        label: "Energizer",
        type: "player",
        image: "energizer.png",
        description: "Stamina drain is halved, but it takes twice as long to fully recharge.",
        buffs: { staminaDrain: -0.50 },
        drawbacks: { staminaRegen: -1.0 },
        level: 1,
        rarity: "rare",
        gachaChance: 0.6
    },
    {
        id: "garbagedetonator",
        label: "Garbage Detonator",
        type: "player",
        image: "garbagedetonator.png", 
        description: "Rubbish Bins explode when you touch them. Be careful—sometimes the explosion can hurt you too!",
        buffs: { Explosion: 1.0 },
        drawbacks: { ExplosionDamage: 0.10 },
        level: 1,
        rarity: "epic",
        gachaChance: 0.4
    },

    // Gun Skills
    {
        id: "gunslinger",
        label: "Gunslinger",
        type: "gun",
        image: "gunslinger.png",
        description: "Boosts gun accuracy and reload speed.",
        buffs: { accuracy: 0.20, reload: 0.15 },
        drawbacks: {},
        level: 1,
        rarity: "rare",
        gachaChance: 0.7
    },
];