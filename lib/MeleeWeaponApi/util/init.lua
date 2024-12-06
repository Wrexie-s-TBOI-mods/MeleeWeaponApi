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

--[[Perform a Switch/Case-like selection.  
    `value` is used to index `cases`.  
    When `value` is `nil`, returns `default`.  
    ]]
---@generic In, Out, Default
---@param value?    In
---@param cases     { [In]: Out }
---@param default?  Default
---@return Out|Default
function Util.When(value, cases, default)
    if value == nil then return default end
    return cases[value]
end

--[[Check that an object is an instance of some Isaac API class.  
    **DISCLAIMER: This is mostly untested, as I didn't have a lot of use for it yet.**
    ]]
---@param input unknown
---@param class userdata|function|table
function Util.InstanceOfIsaacApiClass(input, class)
    local mtInput = getmetatable(input)
    local mtClass = getmetatable(type(class) == "function" and class() or class)

    return mtInput.__class == mtClass.__class
end

include "lib.MeleeWeaponApi.Util.Clock"
include "lib.MeleeWeaponApi.Util.Clone"
include "lib.MeleeWeaponApi.Util.Direction"
include "lib.MeleeWeaponApi.Util.Entity"
include "lib.MeleeWeaponApi.Util.IterableList"
include "lib.MeleeWeaponApi.Util.Player"

return Util
