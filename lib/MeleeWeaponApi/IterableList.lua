-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

---https://wofsauge.github.io/IsaacDocs/rep/RNG.html
local RNG_SHIFT_INDEX = 35

---@class IterableList
local IterableList = mod.__AnimationList or {}
IterableList.__index = IterableList

---@enum IterableListOrder
IterableList.Order = {
    --Iterates through the list from start to end
    Default = "Default",

    --Iterates through the list from end to start
    Reverse = "Reverse",

    --Pick a random animation in the list every time
    Random = "Random",
}

---@param data  unknown[]
---@param order IterableListOrder
---@return IterableList
function IterableList.New(data, order)
    ---@cast data table

    data.__order = order or IterableList.Order.Default
    data.__current = 0
    data.__size = #data
    data.__rng = RNG(Game():GetSeeds():GetStartSeed(), RNG_SHIFT_INDEX)

    setmetatable(data, IterableList)

    ---@cast data IterableList
    return data
end

---@param order IterableListOrder
function IterableList:SetOrder(order)
    self.__order = order
    return self
end

function IterableList:RandomIndex()
    return 1 + self.__rng:RandomInt(self.__size + 1)
end

function IterableList:NextDefault()
    if self.__current == self.__size then self.__current = 0 end
    self.__current = self.__current + 1
    return self:Current()
end

function IterableList:NextReverse()
    if self.__current < 2 then self.__current = self.__size + 1 end
    self.__current = self.__current - 1
    return self:Current()
end

function IterableList:NextRandom()
    self.__current = self:RandomIndex()
    return self:Current()
end

function IterableList:Current()
    return self[self.__current]
end

function IterableList:Next()
    return self["Next" .. self.__order](self)
end

---@param index integer
function IterableList:SetCurrent(index)
    if index == nil then
        index = 1
    else
        assert(
            type(index) == "number" and index % 1 == 0 and index > 0 and index <= self.__size,
            "Index out of bounds: " .. tostring(index)
        )
    end
    self.__current = index
    return self:Current()
end

mod.__AnimationList = IterableList
return IterableList
