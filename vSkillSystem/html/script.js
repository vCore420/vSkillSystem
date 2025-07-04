// todo 
// - update the skills effect when its upgraded as well so it doesnt have to be re-equipped
// - Clean up Css and wrap colous in a root variable for easy theme changes

// vSkill System, add new skills to the nui over in the skills.js

// Image paths for skills
skills.forEach(skill => skill.image = `images/${skill.image}`);

// Inventrory and Equipped Skills
let inventory = [];
let equipped = [null, null, null];
let selectedSkill = null;

// Gacha Modal Elements
const gachaModal = document.getElementById('gacha-modal');
const gachaClose = document.getElementById('gacha-close');
const gachaSpin = document.getElementById('gacha-spin');
const rarityOrder = { common: 1, uncommon: 2, rare: 3, epic: 4, legendary: 5 };

function sortInventory(skills, sortBy) {
    switch (sortBy) {
        case "az":
            return skills.slice().sort((a, b) => a.label.localeCompare(b.label));
        case "type":
            return skills.slice().sort((a, b) => a.type.localeCompare(b.type) || a.label.localeCompare(b.label));
        case "rarity":
            return skills.slice().sort((a, b) => (rarityOrder[a.rarity] || 99) - (rarityOrder[b.rarity] || 99) || a.label.localeCompare(b.label));
        case "level":
            return skills.slice().sort((a, b) => (b.level || 0) - (a.level || 0) || a.label.localeCompare(b.label));
        default:
            return skills;
    }
}

// Render Inventory, Equipped Skills and Skill Details to Nui
function renderInventory() {
    const sortBy = document.getElementById('inventory-sort')?.value || "az";
    const sorted = sortInventory(inventory, sortBy);
    const inv = document.getElementById('skill-inventory');
    inv.innerHTML = '';
    sorted.forEach(skill => {
        const card = document.createElement('div');
        card.className = `skill-card ${skill.rarity || 'common'}`;
        card.dataset.id = skill.id;
        card.innerHTML = `<img src="${skill.image}" alt="${skill.label}">`;
        card.onclick = () => selectSkill(skill.id);
        if (selectedSkill && selectedSkill.id === skill.id) card.classList.add('selected');
        inv.appendChild(card);
    });
}

document.getElementById('inventory-sort').addEventListener('change', renderInventory);

function renderEquipped() {
    const eq = document.getElementById('equipped-skills');
    eq.querySelectorAll('.skill-slot').forEach((slot, idx) => {
        slot.innerHTML = '';
        const skill = equipped[idx];
        slot.className = 'skill-slot'; 
        if (skill) {
            slot.innerHTML = `<img src="${skill.image}" alt="${skill.label}">`;
            slot.classList.add(skill.rarity || 'common');
            slot.onclick = () => unequipSkill(idx);
        } else {
            slot.onclick = () => {};
        }
    });
}

function renderDetails() {
    const details = document.getElementById('skill-details');
    if (!selectedSkill) {
        details.innerHTML = "<p>Select a skill to see details.</p>";
        document.getElementById('upgrade-btn').disabled = true;
        return;
    }
    details.innerHTML = `
        <h3>${selectedSkill.label} (Lv. ${selectedSkill.level})</h3>
        <p><em>${selectedSkill.type.charAt(0).toUpperCase() + selectedSkill.type.slice(1)} skill</em></p>
        <p>${selectedSkill.description}</p>
        <ul>
            ${Object.entries(selectedSkill.buffs).map(([k, v]) => `<li>Buff: ${k} +${v * 100}%</li>`).join('')}
            ${Object.entries(selectedSkill.drawbacks).map(([k, v]) => `<li>Drawback: ${k} ${v * 100}%</li>`).join('')}
        </ul>
        <button onclick="equipSkill('${selectedSkill.id}')">Equip</button>
    `;
}

// Select a skill from inventory
function selectSkill(id) {
    selectedSkill = inventory.find(s => s.id === id);
    renderDetails();
    renderInventory();
    document.getElementById('upgrade-btn').disabled = false;
}

// Send all slots and skill data to Lua
function sendEquippedSkillsToLua() {
    const equippedData = equipped.map((skill, idx) => {
        if (skill) {
            return { slot: idx + 1, id: skill.id, level: skill.level };
        } else {
            return { slot: idx + 1, id: null, level: null };
        }
    });

    fetch('https://vSkillSystem/updateEquipped', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ equipped: equippedData })
    });
}

// Equip a skill to the first available slot
function equipSkill(id) {
    // Check if the skill is already equipped
    if (equipped.some(s => s && s.id === id)) {
        return;
    }
    const idx = equipped.findIndex(s => !s);
    if (idx === -1) {
        return;
    }
    const skill = inventory.find(s => s.id === id);
    equipped[idx] = skill;
    renderEquipped();
    sendEquippedSkillsToLua();
}

// Unequip a skill from a slot
function unequipSkill(idx) {
    equipped[idx] = null;
    renderEquipped();
    sendEquippedSkillsToLua();
}

// Upgrade button functionality - to be Advanced to work at the cost of a in game item
// need to add comunication with Lua for this
document.getElementById('upgrade-btn').onclick = () => {
    if (selectedSkill) {
        selectedSkill.level++;
        renderDetails();
        sendEquippedSkillsToLua(); 
    }
};

// Helper function to pick a skill based on weighted chances
function weightedRandom(skills) {
    const total = skills.reduce((sum, skill) => sum + (skill.gachaChance || 0), 0);
    let rand = Math.random() * total;
    for (const skill of skills) {
        rand -= skill.gachaChance || 0;
        if (rand <= 0) return skill;
    }
    return skills[skills.length - 1];
}

// Open Gacha Modal
function showGachaModal() {
    gachaModal.classList.remove('hidden');
}

// Gacha Reel Animation and Logic
function spinGachaReel() {
    gachaSpin.disabled = true;

    const reelBox = document.getElementById('gacha-reel-box');
    const reelSlot = document.getElementById('gacha-reel-slot');
    reelBox.className = ''; 

    // Build weighted pool
    let pool = [];
    skills.forEach(skill => {
        const count = Math.max(1, Math.round((skill.gachaChance || 0.1) * 100));
        for (let i = 0; i < count; i++) pool.push(skill);
    });

    // Pick the winner
    const winner = pool[Math.floor(Math.random() * pool.length)];

    // Prepare a random sequence for spinning (simulate randomness)
    let spinSequence = [];
    for (let i = 0; i < 24; i++) {
        spinSequence.push(pool[Math.floor(Math.random() * pool.length)]);
    }
    spinSequence.push(winner); // Ensure the last one is the winner

    // Animation: spin through the sequence
    let idx = 0;
    function spinStep() {
        const skill = spinSequence[idx];
        reelSlot.innerHTML = `<img src="${skill.image}" alt="${skill.label}">`;
        reelBox.className = '';
        idx++;
        if (idx < spinSequence.length) {
            let delay = 60 + Math.pow(idx, 1.7);
            setTimeout(spinStep, delay);
        } else {
            reelBox.className = winner.rarity || 'common';
            // Add to inventory or level up
            const owned = inventory.find(s => s.id === winner.id);
            if (owned) {
                owned.level = (owned.level || 1) + 1;
            } else {
                inventory.push({...winner});
            }
            renderInventory();
            gachaSpin.disabled = false;
        }
    }
    spinStep();
}

// Gacha Modal Elements
document.getElementById('gacha-btn').onclick = () => {
    showGachaModal();
};

document.getElementById('gacha-spin').onclick = spinGachaReel;

gachaClose.onclick = () => {
    gachaModal.classList.add('hidden');
};

// Initialize the UI
window.onload = () => {
    renderInventory();
    renderEquipped();
    renderDetails();
};

// Listen for NUI messages from Lua
window.addEventListener('message', function(event) {
    if (event.data.action === 'showSkills') {
        document.getElementById('nui-container').style.display = 'flex';
    }
    if (event.data.action === 'hideSkills') {
        document.getElementById('nui-container').style.display = 'none';
        gachaModal.classList.add('hidden');
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key === "Escape") {
        // Hide the menu and notify Lua
        document.getElementById('nui-container').style.display = 'none';
        fetch('https://vSkillSystem/closeSkills', { method: 'POST' });
        e.preventDefault();
    }
});