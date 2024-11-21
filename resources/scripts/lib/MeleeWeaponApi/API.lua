-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local inspect = include "resources.scripts.lib.inspect"

local Callback = include "resources.scripts.lib.MeleeWeaponApi.CallbackManager"
local MeleeWeapon = include "resources.scripts.lib.MeleeWeaponApi.MeleeWeapon"
local Registry = include "resources.scripts.lib.MeleeWeaponApi.Registry"

local ENTITY_TYPE = EntityType.ENTITY_EFFECT

---@class MeleeWeaponApi
local Api = {
    Callbacks = include "resources.scripts.lib.MeleeWeaponApi.Callback",
}

---@param o MeleeWeaponCreateOptions
local function initOptions(o)
    o.Subtype = o.Subtype or 0
    o.PosVel = o.PosVel or {}
    o.PosVel.Position = o.PosVel.Position or o.Spawner:GetPosVel().Position
    o.PosVel.Velocity = o.PosVel.Velocity or Vector.Zero
    o.Follow = o.Follow == nil or o.Follow
    o.Aim = o.Aim == nil and o.Spawner:ToPlayer() or o.Aim or false
    return o
end

--- TODO: Create option validation
function Api.ValidateOptions() end

---@param options MeleeWeaponCreateOptions
function Api.Create(options)
    options = initOptions(options)

    local weapon = {
        RotationOffset = 0,
    }

    local entity = Isaac.Spawn(
        ENTITY_TYPE,
        options.Variant,
        options.Subtype,
        options.PosVel.Position,
        options.PosVel.Velocity,
        options.Spawner
    )

    weapon.Effect =
        assert(entity:ToEffect(), "Couldn't convert Entity #" .. inspect.EntityId(entity) .. " into EntityEffect")
    weapon.Sprite = weapon.Effect:GetSprite()

    if options.Follow then weapon.Effect:FollowParent(options.Spawner) end

    weapon = setmetatable(weapon, {
        __index = MeleeWeapon,
        __metatable = false,
    })

    Registry.Add(weapon, options)
    Callback.RegisterDefaults(weapon)

    Isaac.RunCallback(Api.Callbacks.MC_POST_WEAPON_INIT, weapon)
    return weapon
end

return setmetatable({}, {
    __index = Api,
    __newindex = function()
        error "Trying to edit MeleeWeaponApi table."
    end,
    __metatable = false,
})
