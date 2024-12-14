-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local Util = mod.__Api.Util

---https://wofsauge.github.io/IsaacDocs/rep/RNG.html
local RNG_SHIFT_INDEX = 35

---@class IterableListInternal
---@field __order   IterableListOrder
---@field __current integer
---@field __size    integer
---@field __rng     RNG

---@class IterableList : IterableListInternal
local IterableList = {}
IterableList.__index = IterableList

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

--[[
    Returned type includes `unknown` in the union, but this is only in the internal side of things.
    A user of the class will not see this discrepency when documentation is provided through the @meta files.
    ]]
---@param data IterableList<unknown>
function IterableList.Create(data, order)
    order = IterableList.ValidateOrder(order or IterableList.Order.Default)

    data.__order = order
    data.__current = 0
    data.__size = #data
    data.__rng = RNG(Game():GetSeeds():GetStartSeed(), RNG_SHIFT_INDEX)

    setmetatable(data, IterableList)

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

function IterableList:SetCurrentIndex(index)
    if self.__order == "Random" then return self:NextRandom() end

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

Util.IterableList = IterableList.Create
