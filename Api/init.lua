-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"

include "Api.Util.init"
include "Api.EntityMelee.init"
include "Api.Callbacks.init"

---@todo Make this an `include "Api.Registry.init"
include "Api.Registry"
include "Api.RegistryManager"

local Api = mod.Api ---@class MeleeWeaponApi
local EntityMelee = mod.EntityMelee

---@param o EntityMeleeCreateOptions
local function initOptions(o)
    o.Subtype = o.Subtype or 0
    o.PosVel = o.PosVel or {}
    o.PosVel.Position = o.PosVel.Position or o.Spawner:GetPosVel().Position
    o.PosVel.Velocity = o.PosVel.Velocity or Vector.Zero
    o.Follow = o.Follow == nil or o.Follow
    return o
end

function Api.ValidateOptions()
    -- @todo Option validation
end

function Api:Create(options)
    local Util = self.Util
    local Callbacks = self.Callbacks

    options = initOptions(options)

    local entity = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
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
