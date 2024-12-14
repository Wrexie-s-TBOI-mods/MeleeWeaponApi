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

---@class EntityMeleeState
--[[
    Is the weapon swinging ?
    ]]
---@field IsSwinging boolean
--[[
    Currently playing swing animation.
    ]]
---@field CurrentAnimation? string
--[[
    Stores pointer hashes for entities that got hit during a swing and shouldn't be considered for
    `:OnSwingHit()`'s future calls.  
    This table is reset every new swing.
    ]]
---@field SwingHitBlacklist table<PtrHash, boolean>
--[[
    Is the weapon charging ?
    ]]
---@field IsCharging boolean
--[[
    The `Sprite` object for the current chargebar display, if any.
    ]]
---@field Chargebar? Sprite
--[[
    Is the weapon being thrown ?
    ]]
---@field IsThrowing boolean
--[[
    If the weapon's `SpawnerEntity` is a player, is that player moving ?  
    Always `false` if `SpawnerEntity` is not an `EntityPlayer`.
    ]]
---@field IsPlayerMoving boolean
--[[
    If the weapon's `SpawnerEntity` is a player, is that player aiming (shoot inputs) ?  
    Always `false` if `SpawnerEntity` is not an `EntityPlayer`.
    ]]
---@field IsPlayerAiming boolean
--[[
    If the weapon's `SpawnerEntity` is a player, what `Direction` is their head turned towards ?
    Always `Direction.NO_DIRECTION` if `SpawnerEntity` is not an `EntityPlayer`.
    ]]
---@field PlayerHeadDirection Direction

---@class EntityMelee
local EntityMelee = {}

--[[
    Return the internal state of an @{EntityMelee}.  
    When `unsafe` is set to `true`, returns a reference to the actual state table.  
    When `unsafe` is set to `false`, returns a read-only proxy to the state table.  
    **DISCLAIMER:** Modifying the returned table in unsafe mode can break things and
    you should only do so if you really know what you are doing.  
    ]]
---@param unsafe? boolean Default: `false`
---@return EntityMeleeState
function EntityMelee:GetState(unsafe) end
