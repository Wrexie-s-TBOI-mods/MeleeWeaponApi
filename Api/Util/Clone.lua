-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Util = mod.Api.Util

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

function Util.Clone(table)
    return __clone(table)
end
