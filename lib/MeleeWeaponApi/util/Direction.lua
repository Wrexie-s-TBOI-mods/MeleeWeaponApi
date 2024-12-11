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

---@param direction Direction
function Util.DirectionToAngleDegrees(direction)
    return Util.When(direction, {
        [Direction.LEFT] = 180,
        [Direction.RIGHT] = 0,
        [Direction.UP] = -90,
        [Direction.DOWN] = 90,
        [Direction.NO_DIRECTION] = 90,
    })
end

---@param direction? Direction
---@return Vector
function Util.DirectionToAngleVector(direction)
    return Vector.FromAngle(Util.DirectionToAngleDegrees(direction or Direction.NO_DIRECTION))
end
