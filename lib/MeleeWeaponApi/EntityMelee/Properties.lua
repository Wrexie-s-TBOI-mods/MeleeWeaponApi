-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = mod.__Api and mod.__Api.Util or include "lib.MeleeWeaponApi.Util.init"

---@class EntityMelee
local EntityMelee = mod.__EntityMelee or {}
mod.__EntityMelee = EntityMelee

---@class MeleeWeaponProps
local INITIAL_PROPS = {
    AimRotationOffset = 0,
    MovementRotationOffset = 0,

    ChargePercentage = 0,
    ChargebarSprite = "gfx/chargebar.anm2",

    --[[Null capsules defined in your sprite's `.anm2`.  
        They're the hitboxes of your weapon, and will be iterated over during a swing to simulate collision.  
        During a swing, `EntityMelee:OnSwingHit()` will be called for each entity found in any of the capsules,
        and the entities will be passed as the first argument (`target`) after `self`.
        ]]
    Capsules = {}, ---@type string[]

    --[[EntityPartitions to filter what type of entity should be considered hit during a swing.
        ]]
    SwingTargets = nil, ---@type EntityPartition

    --[[This field is to store any arbitrary data of your choice.
        ]]
    CustomData = {}, ---@type any
}

---Here we cast so that we get completion when using `self` in the callback definitions.
---@cast INITIAL_PROPS EntityMelee

--[[Called when rendering the chargebar.
    Defaults to roughly the same position as the game's original chargebar.
    ]]
function INITIAL_PROPS:GetChargebarPosition()
    local pos = self.SpawnerEntity.Position
    local scale = self.SpawnerEntity.SpriteScale
    local offsetX = Vector(-20, 0) * scale
    local offsetY = Vector(0, 50) * scale
    local offset = offsetX + offsetY

    return Isaac.WorldToScreen(pos - offset)
end

--[[ CHARGE CALLBACKS ]]

--[[Called before starting a charge.  
    Returning a truthy value prevents charging.
    ]]
function INITIAL_PROPS:OnChargeStart() end

--[[Called on every update of an `EntityMelee`, if it is charging.
    ]]
function INITIAL_PROPS:OnChargeUpdate() end

--[[Called on every update of an `EntityMelee`, if it is charging and `self.ChargePercentage >= 100` 
    ]]
function INITIAL_PROPS:OnChargeFull() end

--[[Called before releasing a charge.
    Returning a truthy value prevents charge from stopping.
    ]]
function INITIAL_PROPS:OnChargeEnd() end

--[[Called after releasing a charge.
    ]]
function INITIAL_PROPS:OnChargeRelease() end

--]]
--[[ SWING CALLBACKS ]]

--[[Called before each swing.
    If a truthy value is returned, prevents the swing.  
    By default, checks that it's not already swinging and,
    if spawner entity is a player, checks that they can shoot.
    ]]
function INITIAL_PROPS:OnSwingStart()
    if self:IsSwinging() then return true end

    local player = self.SpawnerEntity:ToPlayer()
    if not player or not player:CanShoot() then return true end
end

--[[Called after each swing.
    ]]
function INITIAL_PROPS:OnSwingEnd() end

--[[Called for every entity hit by a swing.  
    Be sure to set your `EntityMelee.Capsules` for this to work properly, else it will not be called !  
    Returning a falsy value will prevent the entity from being hit again by the same swing.
    ]]
---@param target Entity
function INITIAL_PROPS:OnSwingHit(target) end

--]]
--[[ MOVEMENT CALLBAKCS ]]

--[[Called when player starts moving.
    ]]
---@param player    EntityPlayer
---@param movement  Vector
---@param input     Vector
function INITIAL_PROPS:OnPlayerMoveStart(player, movement, input) end

--[[Called on every tick of player moving.
    ]]
---@param player    EntityPlayer
---@param movement  Vector
---@param input     Vector
function INITIAL_PROPS:OnPlayerMoveUpdate(player, movement, input) end

--[[Called on every tick of player moving.
]]
---@param player    EntityPlayer
---@param movement  Vector
---@param input     Vector
function INITIAL_PROPS:OnPlayerMoveEnd(player, movement, input) end

--]]

---Back to original type to prevent breaking inference
---@cast INITIAL_PROPS MeleeWeaponProps

---@private
function EntityMelee.GetInitialProps()
    return Util.Clone(INITIAL_PROPS)
end
