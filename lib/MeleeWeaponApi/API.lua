-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference
local EntityMelee = mod.__EntityMelee or include "lib.MeleeWeaponApi.EntityMelee.init"

---@class MeleeWeaponApi
local Api = mod.__Api or {}

local ENTITY_TYPE = EntityType.ENTITY_EFFECT

---@param o MeleeWeaponCreateOptions
local function initOptions(o)
    o.Subtype = o.Subtype or 0
    o.PosVel = o.PosVel or {}
    o.PosVel.Position = o.PosVel.Position or o.Spawner:GetPosVel().Position
    o.PosVel.Velocity = o.PosVel.Velocity or Vector.Zero
    o.Follow = o.Follow == nil or o.Follow
    return o
end

--- TODO: Create option validation
function Api.ValidateOptions() end

---@param options MeleeWeaponCreateOptions
---@return EntityMelee
function Api:Create(options)
    local Util = self.Util
    local Callbacks = self.Callbacks

    options = initOptions(options)

    local entity = Isaac.Spawn(
        ENTITY_TYPE,
        options.Variant,
        options.Subtype,
        options.PosVel.Position,
        options.PosVel.Velocity,
        options.Spawner
    )

    local effect = Util.MustBeEffect(entity)
    local weapon = EntityMelee:FromEffect(effect)

    if options.Follow then weapon:FollowParent(options.Spawner) end

    local sprite = weapon:GetSprite()
    sprite.Rotation = Util.DirectionToAngleDegrees(Direction.NO_DIRECTION)

    Isaac.RunCallback(Callbacks.MC_POST_WEAPON_INIT, weapon)
    return weapon
end

mod.__Api = Api
return mod.__Api
