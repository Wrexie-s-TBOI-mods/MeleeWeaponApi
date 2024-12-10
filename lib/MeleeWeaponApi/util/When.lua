-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod"

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

--[[Perform a Switch/Case-like selection, like @{Util.When}, but takes a
    table of functions and runs the found matching case to return its result.  
    `value` is used to index `cases`.
    When `value` is `nil`, returns `default`, or runs and returns its value if
    it is a function.
    ]]
---@generic In, Out, Default
---@param value?    In
---@param cases     { [In]: fun(): Out }
---@param default?  Default|fun(): Default
---@return Out|Default
function Util.WhenEval(value, cases, default)
    local f = Util.When(value, cases)
    local v = (f and f()) or (type(default) == "function" and default() or default)
    return v
end
