-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable)
---@diagnostic disable: unused-local

---@class MeleeWeaponApiUtil
local Util = {}

---@enum (key) DirectionString
local DirectionString = {
    LEFT = Direction.LEFT,
    RIGHT = Direction.RIGHT,
    UP = Direction.UP,
    DOWN = Direction.DOWN,
    NO_DIRECTION = Direction.NO_DIRECTION,
}

---@enum DirectionAngle
local DirectionAngle = {
    LEFT = 180,
    RIGHT = 0,
    UP = -90,
    DOWN = 90,
    NO_DIRECTION = 90,
}

---@param direction DirectionString
---@return Direction
function Util.StringToDirection(direction) end

---@param direction Direction
---@return DirectionString
function Util.DirectionToString(direction) end

---@param direction Direction
---@return DirectionAngle
function Util.DirectionToAngleDegrees(direction) end

---@param direction Direction
---@return Vector
function Util.DirectionToAngleVector(direction) end
