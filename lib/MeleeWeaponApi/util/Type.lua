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

--[[Get the Isaac API class name of an object.  
    Returns `nil` if unknown, most of the times because not an Isaac API class instance.
   ]]
---@param object unknown
function Util.GetIsaacApiClassName(object)
    if type(object) ~= "userdata" then return end

    local metatable = getmetatable(object)
    if metatable == nil then return end

    local type = metatable.__type
    if type(type) ~= "string" then return end

    local name = string.gsub(type, "const ", "")
    return name
end

--[[Get the type of ANY object.
    ]]
---@param object unknown
---@return
---| "nil"
---| "number"
---| "string"
---| "boolean"
---| "table"
---| "function"
---| "thread"
---| "userdata"
---| string
function Util.Type(object)
    local T = type(object)
    return Util.WhenEval(T, {
        ["userdata"] = function()
            return Util.GetIsaacApiClassName(object) or "<userdata>"
        end,
    }, T)
end
