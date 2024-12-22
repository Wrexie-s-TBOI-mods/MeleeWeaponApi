-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Registry = mod.Registry

---TODO: Garbage collection on run end?
---TODO: Savestate on run end?
---@class RegistryManager
local RegistryManager = mod.RegistryManager

---@param weapon    EntityEffect|EntityMelee
---@param props     EntityMeleeProps
---@param state     EntityMeleeState
function RegistryManager.Add(weapon, props, state)
    ---@type RegistryEntry
    local reg = {
        props = props,
        state = state,
    }

    Registry[weapon] = reg
end

function RegistryManager.Has(weapon)
    return Registry[weapon] ~= nil
end

---@param weapon EntityMelee
function RegistryManager.GetState(weapon)
    local entry = Registry[weapon]
    return assert(entry).state
end

---@param weapon EntityMelee
function RegistryManager.GetProps(weapon)
    local entry = Registry[weapon]
    return entry and entry.props
end

function RegistryManager.Size()
    return #Registry
end

function RegistryManager.Remove(weapon)
    assert(Registry[weapon], "Trying to remove a non existent entry")
    Registry[weapon] = nil
end
