-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = require "Api.mod" ---@class MeleeWeaponApiModReference

---@class WeaponRegistry
---@field [EntityMelee] WeaponRegistryEntry
local Registry = mod.__Registry or {
    size = 0,
}

---@type metatable
local Meta = {}

---@param table     WeaponRegistry
---@param weapon    EntityMelee
function Meta.__index(table, weapon)
    local ok, hash = pcall(GetPtrHash, weapon)
    if ok then return table[hash] end
end

---@param table     WeaponRegistry
---@param weapon    EntityMelee
---@param value     WeaponRegistryEntry
function Meta.__newindex(table, weapon, value)
    local hash = GetPtrHash(weapon)

    rawset(table, hash, value)
    if value == nil then
        table.size = math.max(0, table.size - 1)
    else
        table.size = table.size + 1
    end
end

function Meta.__len(table)
    return table.size
end

mod.__Registry = setmetatable(Registry, Meta)
return mod.__Registry