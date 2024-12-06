-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = mod.__Util or {}

---@param meta metatable
function Util.LockMetatable(module, meta)
    -- TODO: Implement Util.LockMetatable
end

local function __CloneTable(table, cache)
    if type(table) ~= "table" then return table end

    cache = cache or {}
    if cache[table] then return cache[table] end
    local copy = {}
    cache[table] = copy
    for key, value in pairs(table) do
        copy[__CloneTable(key, cache)] = __CloneTable(value, cache)
    end
    return copy
end

---@generic T : table
---@param table T
---@return T
function Util.CloneTable(table)
    assert(type(table) == "table", "Given object is not a table")
    return __CloneTable(table)
end

---@param entity Entity
function Util.GetEntityId(entity)
    return tostring(entity.Type) .. "." .. tostring(entity.Variant) .. "." .. tostring(entity.SubType)
end

---@param entity Entity
function Util.MustBePlayer(entity)
    local p = assert(entity:ToPlayer(), "Entity " .. Util.GetEntityId(entity) .. " is not a player")
    return p
end

---@param entity Entity
function Util.MustBeEffect(entity)
    local e = assert(entity:ToEffect(), "Entity " .. Util.GetEntityId(entity) .. " is not an effect")
    return e
end

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

--[[
    Perform a Switch/Case-like selection.  
    `value` is used to index `cases`.  
    When `value` is `nil`, returns `default`.  
]]
---@generic In, Out, Default
---@param value?    In
---@param cases     { [In]: Out }
---@param default?  Default
---@return Out|Default
---@todo Find if there's a magical way to type this properly
function Util.When(value, cases, default)
    if value == nil then return default end
    return cases[value]
end

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

---@param direction Direction
---@return Vector
function Util.DirectionToAngleVector(direction)
    return Vector.FromAngle(Util.DirectionToAngleDegrees(direction))
end

---@param input unknown
---@param class userdata|function|table
function Util.InstanceOfIsaacApiClass(input, class)
    local mtInput = getmetatable(input)
    local mtClass = getmetatable(type(class) == "function" and class() or class)

    return mtInput.__class == mtClass.__class
end

mod.__Util = Util
return mod.__Util
