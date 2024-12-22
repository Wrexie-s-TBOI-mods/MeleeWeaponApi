-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Util = mod.Api.Util

local DirStrings = {
    [Direction.LEFT] = "LEFT",
    [Direction.RIGHT] = "RIGHT",
    [Direction.UP] = "UP",
    [Direction.DOWN] = "DOWN",
    [Direction.NO_DIRECTION] = "NO_DIRECTION",
}

local DirAngles = {
    [Direction.LEFT] = 180,
    [Direction.RIGHT] = 0,
    [Direction.UP] = -90,
    [Direction.DOWN] = 90,
    [Direction.NO_DIRECTION] = 90,
}

function Util.StringToDirection(direction)
    local d = Direction[direction]

    if d == nil then error('Invalid direction string: "' .. tostring(direction) .. '".', 2) end

    return d
end

function Util.DirectionToString(direction)
    local d = DirStrings[direction]

    if d == nil then error('Invalid direction: "' .. tostring(direction) .. '".', 2) end

    return d
end

function Util.DirectionToAngleDegrees(direction)
    local d = DirAngles[direction]

    if d == nil then error('Invalid direction: "' .. tostring(direction) .. '".', 2) end

    return d
end

function Util.DirectionToAngleVector(direction)
    local d = DirAngles[direction]

    if d == nil then error('Invalid direction: "' .. tostring(direction) .. '".', 2) end

    return Vector.FromAngle(d)
end
