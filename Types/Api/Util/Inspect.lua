-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable)
---@diagnostic disable: unused-local

---@class MeleeWeaponApiUtil
local Util = {}

---@class InspectOptions
---@field depth     integer
---@field newline   string
---@field indent    string
---@field process   unknown Idk what that's for, really

--[[
    Encode any Lua data into a human readable string similar to JSON.  
    Credit: http://github.com/kikito/inspect.lua
    ]]
---@param root      any
---@param options?  InspectOptions
function Util.Inspect(root, options) end
