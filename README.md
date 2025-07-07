FiveM Skill System created by vCore, 
currently a work in progress!

Unique and fun skill system for FiveM allowing for daily gacha spins to acquire new skills or upgrade current ones.
Rartirty basied skills with simple common skills to game breaking legendary skills.
Unique player, gun and melea skills with cool buffs and drawbacks.
The user can set up to 3 different skills at once allowing for custom and unique skill sets. 
Skill crafting, allowing for new skills to be created from 2 others skills

Easily add more skills to the Nui in the skills.js and add the effect logic and revert logic in the effects.lua.


Very early stages at the moment. any help/input welcome, completely open source, I just enjoy doing this to learn!

if you want to give it a try, drop the vSkillSystem folder in with your resources and restart your server, /vskills in chat opens the menu. 


***not in full working state yet, test at own risk as it definitely still has a little to go***

**Change Log**

1/7 - project started, base html, js and css created and started communication with lua scripts

2/7 - added debug prints to console, added a toggle for this in config.lua. started working on skill effect logic

4/7 - added small fixes to clashing functions by disabling buttons when needed. stpped the same skill equipping twice. Added category dropdown to players skill inventory 

5/7 - started work of effects logic and added images for current skills

6/7 - Added Skill Crafting! can craft new skills by combinin 2 others! started working on the style of Nui to have a liquid glass type look to them

7/7 - added root to CSS for all colours to easily change the nui theme


***Current plans todo***

save users skill info to server side to save to db. with data being pulled back when player rejoins game

finish off current skills, crafts, effects and images

some skills will clash with each other as their effect and revert logic needs to be more modular to work with multiple buffs of the same kind. 
