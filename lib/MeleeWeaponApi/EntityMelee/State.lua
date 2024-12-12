-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = mod.__Api and mod.__Api.Util or include "lib.MeleeWeaponApi.Util.init"
local RegistryManager = mod.__RegistryManager or include "lib.MeleeWeaponApi.RegistryManager"

---@class EntityMelee
local EntityMelee = mod.__EntityMelee or {}
mod.__EntityMelee = EntityMelee

---@class MeleeWeaponState
local INITIAL_STATE = {
    IsSwinging = false, ---@type boolean
    CurrentAnimation = nil, ---@type string?

    IsCharging = false, ---@type boolean
    IsThrowing = false, ---@type boolean
    IsPlayerMoving = false, ---@type boolean
    IsPlayerAiming = false, ---@type boolean

    SwingHitBlacklist = {}, ---@type table<PtrHash, boolean>

    Chargebar = nil, ---@type Sprite

    IsRotating = false, ---@type boolean
    RotateFrom = Vector(0, 0),
    RotateTo = Vector(0, 0),
    RotateProgress = 0.0, ---@type number

    AimRotationSource = nil, ---@type EntityPlayer?
    MovementRotationSource = nil, ---@type EntityPlayer?
}

---@private
function EntityMelee.GetInitialState()
    return Util.Clone(INITIAL_STATE)
end

--[[Return the internal state of an @{EntityMelee}.  
    When `unsafe` is set to `true`, returns a reference to the actual state table.  
    When `unsafe` is set to `false`, returns a read-only proxy to the state table.  
    **DISCLAIMER:** Modifying the returned table in unsafe mode can break things and
    you should only do so if you really know what you are doing.  
    ]]
---@param unsafe? boolean Default: `false`
---@return MeleeWeaponState
function EntityMelee:GetState(unsafe)
    local state = RegistryManager.GetState(self)

    return unsafe and state
        or setmetatable({}, {
            __index = state,
            __newindex = function(_, key, value)
                local msg = "Attempting to edit an EntityMelee state proxy: "
                    .. Util.Inspect { key = key, value = value }
                    .. "\n"
                    .. "If you really want to modify the state (not recommended), pass `true` to :GetState()."

                error(msg, 2)
            end,
            __metatable = false,
        })
end
