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

---https://wofsauge.github.io/IsaacDocs/rep/RNG.html
local RNG_SHIFT_INDEX = 35

---@class IterableList
local IterableList = {}
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

---@param  order unknown
---@return IterableListOrder
function IterableList.ValidateOrder(order)
    order = Util.When(order, IterableList.Order)
    if not order then error("Invalid order: " .. tostring(order)) end
    return order
end

--[[Creates a list that you can iterate over using its methods.  
    It always loops, meaning that calling `:Next()` when `:Current()` returns the  
    last element of its chosen order will reset the counter and retrun the first
    element of its chosen order.    
    **Note:** Even though you can edit fields like `.__current`, `.__order`, etc,
    I recommend using things like `:SetCurrent()` or `:SetOrder()` which include
    a validation step to avoid bugs.
    ]]
---@param data      any[]
---@param order?    IterableListOrder
---@return IterableList
function IterableList.New(data, order)
    order = IterableList.ValidateOrder(order or IterableList.Order.Default)

    ---@cast data table
    data.__order = order
    data.__current = 0
    data.__size = #data
    data.__rng = RNG(Game():GetSeeds():GetStartSeed(), RNG_SHIFT_INDEX)

    setmetatable(data, IterableList)

    ---@cast data IterableList
    return data
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

--[[Set the index for the current animation in the list.
    If `index` is `nil`, sets it to the first of chosen order.  
    Does nothing if chosen order is "Random".
    ]]
---@param index integer
function IterableList:SetCurrent(index)
    if self.__order == "Random" then return end

    if index == nil then
        index = self.__order == "Default" and 1 or self.__size
    else
        assert(
            type(index) == "number" and index % 1 == 0 and index > 0 and index <= self.__size,
            "Index out of bounds: " .. tostring(index)
        )
    end
    self.__current = index
    return self:Current()
end

Util.IterableList = IterableList.New
