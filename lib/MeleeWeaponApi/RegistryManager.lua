-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Registry = include "lib.MeleeWeaponApi.Registry"

---TODO: Garbage collection on run end
---@class WeaponRegistryManager
local RegistryManager = mod.__RegistryManager or {}

---@param weapon    EntityEffect|EntityMelee
---@param props     MeleeWeaponProps
---@param state     MeleeWeaponState
function RegistryManager.Add(weapon, props, state)
    ---@type WeaponRegistryEntry
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

mod.__RegistryManager = RegistryManager
return mod.__RegistryManager
