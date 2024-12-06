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

local function __clone(table, cache)
    if type(table) ~= "table" then return table end

    cache = cache or {}
    if cache[table] then return cache[table] end
    local copy = {}
    cache[table] = copy
    for key, value in pairs(table) do
        copy[__clone(key, cache)] = __clone(value, cache)
    end
    return copy
end

---@generic Table : table --- That doc comment be like https://youtu.be/XtAhISkoJZc
---@param table Table
---@return Table
function Util.Clone(table)
    return __clone(table)
end
