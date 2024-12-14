-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable)
---@diagnostic disable: unused-local, duplicate-doc-alias

---@class MeleeWeaponApiUtil
local Util = {}

---@enum IterableListOrder
local IterableListOrder = {
    --Iterates through the list from start to end
    Default = "Default",

    --Iterates through the list from end to start
    Reverse = "Reverse",

    --Pick a random animation in the list every time
    Random = "Random",
}

---@class IterableList
local IterableList = {}

---@alias IterableList<Elements> IterableList | { [integer]: Elements }

--[[
    Creates a list that you can iterate over using its methods.
    It always loops, meaning that calling `:Next()` when `:Current()` returns the last element of
    its chosen order will reset the current index and retrun the first element of its chosen order.
    ]]
---@generic Elements
---@param elements  { [integer]: Elements }
---@param order?    IterableListOrder
---@return IterableList<Elements>
function IterableList.Create(elements, order) end

--[[
    Get a random index within the bounds of this list.
    ]]
---@return number
function IterableList:RandomIndex() end

--[[
    Return the element at the current index of the list.
    ]]
---@generic Elements
---@param self IterableList<Elements>
---@return Elements
function IterableList:Current() end

--[[
    Get the next item in the list in "Default" order.
    ]]
---@see IterableListOrder.Default
---@generic Elements
---@param self IterableList<Elements>
---@return Elements
function IterableList:NextDefault() end

--[[
    Get the next item in the list in "Reverse" order.
    ]]
---@see IterableListOrder.Reverse
---@generic Elements
---@param self IterableList<Elements>
---@return Elements
function IterableList:NextReverse() end

--[[
    Get the next item in the list in "Random" order.
    ]]
---@see IterableListOrder.Random
---@generic Elements
---@param self IterableList<Elements>
---@return Elements
function IterableList:NextRandom() end

--[[
    Get the next item in the list in its configured order.
    ]]
---@see IterableListOrder
---@generic Elements
---@param self IterableList<Elements>
---@return Elements
function IterableList:Next() end

--[[
    Set the index for the current animation in the list, then return the corresponding element.
    If `index` is `nil`, sets it to the first of chosen order.
    If set order is random, simply returns a random element.
    ]]
---@generic Elements
---@param self IterableList<Elements>
---@param index? integer
function IterableList:SetCurrentIndex(index) end

Util.IterableList = IterableList.Create
