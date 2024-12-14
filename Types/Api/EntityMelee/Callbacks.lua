-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable)
---@diagnostic disable: missing-return, unused-local

---@class EntityMelee : EntityEffect, EntityMeleeProps
local EntityMelee = {}

--[[
    Called when rendering the chargebar.  
    Defaults to returning roughly the same position as the game's original chargebar, relative to
    `self.SpawnerEntity.Position` and `self.SpawnerEntity.SpriteScale`.  
    
    [Parent callback]: `MC_POST_WEAPON_RENDER` ← `MC_POST_EFFECT_RENDER`
    ]]
---@return Vector
function EntityMelee:GetChargebarPosition() end

--[[
    Called before starting a charge.  
    Returning a truthy value prevents charging.

    [Parent callback]: `MC_POST_WEAPON_UPDATE` ← `MC_POST_EFFECT_UPDATE`
    ]]
function EntityMelee:OnChargeStart() end

--[[
    Called on every update of an `EntityMelee`, if it is charging and `self.ChargePercentage < 100`.
    
    [Parent callback]: `MC_POST_WEAPON_UPDATE` ← `MC_POST_EFFECT_UPDATE`
    ]]
function EntityMelee:OnChargeUpdate() end

--[[
    Called on every update of an `EntityMelee`, if it is charging and `self.ChargePercentage >= 100` 

    [Parent callback]: `MC_POST_WEAPON_UPDATE` ← `MC_POST_EFFECT_UPDATE`
    ]]
function EntityMelee:OnChargeFull() end

--[[
    Called before releasing a charge.  
    Returning a truthy value prevents releasing the charge.
    ]]
function EntityMelee:OnChargeEnd() end

--[[
    Called after releasing a charge.
    ]]
function EntityMelee:OnChargeRelease() end

--[[
    Called before each swing.  
    If a truthy value is returned, prevents the swing.  
    By default, checks that it's not already swinging and, if spawner entity is a player, checks
    that they can shoot.
    ]]
function EntityMelee:OnSwingStart() end

--[[
    Called after each swing.
    ]]
function EntityMelee:OnSwingEnd() end

--[[
    Called for every entity hit by a swing.  
    Be sure to set your `EntityMelee.Capsules` for this to work properly, else it will not be called !  
    Returning a falsy value will prevent the entity from being hit again by the same swing.

    [Parent callback]: `MC_POST_WEAPON_UPDATE` ← `MC_POST_EFFECT_UPDATE`
    ]]
---@param target Entity
function EntityMelee:OnSwingHit(target) end

--[[
    Called when player starts moving.  

    [Parent callback]: `MC_POST_PLAYER_UPDATE`
    ]]
---@param player    EntityPlayer
---@param movement  Vector
function EntityMelee:OnPlayerMoveStart(player, movement) end

--[[
    Called on every tick of player moving.  

    [Parent callback]: `MC_POST_PLAYER_UPDATE`
    ]]
---@param player    EntityPlayer
---@param movement  Vector
function EntityMelee:OnPlayerMoveUpdate(player, movement) end

--[[
    Called on every tick of player moving.  
    
    [Parent callback]: `MC_POST_PLAYER_UPDATE`
    ]]
---@param player    EntityPlayer
---@param movement  Vector
function EntityMelee:OnPlayerMoveEnd(player, movement) end

--[[
    Called when player starts aiming.  
    
    [Parent callback]: `MC_POST_PLAYER_UPDATE`
    ]]
---@param player    EntityPlayer
---@param aim       Vector
function EntityMelee:OnPlayerAimStart(player, aim) end

--[[
    Called on every tick of player aiming.  
    
    [Parent callback]: `MC_POST_PLAYER_UPDATE`
    ]]
---@param player    EntityPlayer
---@param aim       Vector
function EntityMelee:OnPlayerAimUpdate(player, aim) end

--[[
    Called on every tick of player aiming.  
    
    [Parent callback]: `MC_POST_PLAYER_UPDATE`
    ]]
---@param player EntityPlayer
---@param aim       Vector
function EntityMelee:OnPlayerAimEnd(player, aim) end
