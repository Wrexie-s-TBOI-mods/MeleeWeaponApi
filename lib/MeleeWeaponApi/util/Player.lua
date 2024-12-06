-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

---@class MeleeWeaponApi
local Api = mod.__Api or {}
mod.__Api = Api

local Util = Api.Util or {}
Api.Util = Util

---@param player EntityPlayer
function Util.IsPlayerAiming(player)
    local p = Util.MustBePlayer(player)
    local v = p:GetAimDirection()

    return (v.X ~= 0 or v.Y ~= 0), {
        vector = v,
        head = p:GetHeadDirection(),
    }
end

---@param player EntityPlayer
function Util.IsPlayerMoving(player)
    local p = Util.MustBePlayer(player)
    local v = p:GetMovementVector()

    return (v.X ~= 0 or v.Y ~= 0),
        {
            vector = v,
            direction = p:GetMovementDirection(),
            head = p:GetHeadDirection(),
        }
end
