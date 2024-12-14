-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable)
---@diagnostic disable: missing-return, unused-local

---@class MeleeWeaponApiUtil
local Util = {}

--[[
    Check that an object is an instance of some Isaac API class.  
    <br>
    **DISCLAIMER: This is mostly untested, as I didn't have a lot of use for it yet.**
    ]]
---@param input unknown
---@param class userdata|function|table
function Util.InstanceOfIsaacApiClass(input, class) end

--[[
    Get the Isaac API class name of an object.  
    Returns `nil` if unknown or `input` is not an Isaac API class instance.  
   ]]
---@param object unknown
---@return string
---@todo Document all possible class names
function Util.GetIsaacApiClassName(object) end

--[[
    Get the type of ANY object.
    ]]
---@param object any
---@return type | string
function Util.Type(object) end
