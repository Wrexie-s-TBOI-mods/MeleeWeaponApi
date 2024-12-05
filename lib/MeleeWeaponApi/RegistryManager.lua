-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local inspect = require "lib.inspect"
local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = include "lib.MeleeWeaponApi.Util"
local Registry = include "lib.MeleeWeaponApi.Registry"

---TODO: Garbage collection on run end
---@class WeaponRegistryManager
local RegistryManager = mod.__RegistryManager or {}

---@param weapon    EntityMelee
---@param props     MeleeWeaponProps
---@param state     MeleeWeaponState
function RegistryManager.Add(weapon, props, state)
    ---@type WeaponRegistryEntry
    local reg = {
        props = props,
        state = state,
        callbacks = setmetatable({}, {
            __metatable = false,
            __index = function(self, key)
                if not rawget(self, key) then self[key] = {} end
                return rawget(self, key)
            end,
        }),
    }

    Registry[weapon] = reg
end

function RegistryManager.Has(weapon)
    return Registry[weapon] ~= nil
end

---@param weapon    EntityMelee
---@param table     RegistryCallbackTable
function RegistryManager.AddCallbacks(weapon, table)
    local entry = Registry[weapon]

    for key, callbacks in pairs(table) do
        local regcb = entry.callbacks[key]
        for fn, param in pairs(callbacks) do
            ---@diagnostic disable-next-line: cast-type-mismatch — See CallbackManager.lua
            ---@cast fn     CallbackFn
            ---@cast param  integer
            mod:AddCallback(key, fn, param)
            regcb[#regcb + 1] = fn
        end
    end
end

---@param weapon EntityMelee
function RegistryManager.GetState(weapon)
    local entry = Registry[weapon]
    local exists = entry ~= nil

    return exists and entry.state or nil
end

---@param weapon EntityMelee
function RegistryManager.GetProps(weapon)
    local entry = Registry[weapon]
    local exists = entry ~= nil

    return exists and entry.props or nil
end

function RegistryManager.Size()
    return #Registry
end

function RegistryManager.Remove(weapon)
    local entry = assert(Registry[weapon], "Trying to remove a non existent entry")

    for key, cb in pairs(entry.callbacks) do
        mod:RemoveCallback(key, cb[1])
    end

    Registry[weapon] = nil
end

mod.__RegistryManager = RegistryManager
return mod.__RegistryManager
