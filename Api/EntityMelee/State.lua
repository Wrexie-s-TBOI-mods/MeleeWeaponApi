-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Util = mod.Api.Util
local RegistryManager = mod.RegistryManager

local EntityMelee = mod.EntityMelee ---@class EntityMelee

---@type EntityMeleeState
local INITIAL_STATE = {
    IsSwinging = false,
    CurrentAnimation = nil,
    SwingHitBlacklist = {},

    IsCharging = false,
    Chargebar = nil,

    IsThrowing = false,

    IsPlayerMoving = false,
    IsPlayerAiming = false,
    PlayerHeadDirection = Direction.NO_DIRECTION,
}

---@private
function EntityMelee.GetInitialState()
    return Util.Clone(INITIAL_STATE)
end

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
