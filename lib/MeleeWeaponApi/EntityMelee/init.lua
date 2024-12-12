-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local RegistryManager = mod.__RegistryManager or include "lib.MeleeWeaponApi.RegistryManager"
local CallbackManager = mod.__CallbackManager or include "lib.MeleeWeaponApi.Callbacks.init"

---@class EntityMelee
local EntityMelee = mod.__EntityMelee or {}
mod.__EntityMelee = EntityMelee

if not EntityMelee.__super then
    local super = getmetatable(EntityEffect).__class ---@type metatable

    ---@private
    EntityMelee.__super = super

    ---@private
    EntityMelee.__fxindex = super.__index

    ---@private
    EntityMelee.__fxnewindex = super.__newindex

    ---Call a method from the parent class @{EntityEffect}
    ---@param name string Method name
    ---@param ... any
    ---@private
    function EntityMelee:__fxcall(name, ...)
        local fn = EntityMelee.__fxindex(self, name)
        return fn(self, ...)
    end

    rawset(super, "__index", function(self, key)
        if EntityMelee[key] then return EntityMelee[key] end

        local props = RegistryManager.GetProps(self)
        if props and props[key] then return props[key] end

        return EntityMelee.__fxindex(self, key)
    end)

    rawset(super, "__newindex", function(self, key, value)
        local props = RegistryManager.GetProps(self)

        if props and props[key] then
            props[key] = value
            return
        end

        return EntityMelee.__fxnewindex(self, key, value)
    end)
end

include "lib.MeleeWeaponApi.EntityMelee.Properties"
include "lib.MeleeWeaponApi.EntityMelee.State"

--[[Create an @{EntityMelee} instance from an @{EntityEffect}.
    ]]
---@param effect Entity
function EntityMelee:FromEffect(effect)
    effect = assert(effect:ToEffect())
    RegistryManager.Add(effect, self.GetInitialProps(), self.GetInitialState())
    return effect --[[@as EntityMelee]]
end

--[[Destroy an @{EntityEffect} instance.
    ]]
function EntityMelee:Remove()
    self:__fxcall "Remove"
    RegistryManager.Remove(self)
    CallbackManager:RemoveEntries(self)
    return nil
end

include "lib.MeleeWeaponApi.EntityMelee.Charge"
include "lib.MeleeWeaponApi.EntityMelee.Properties"
include "lib.MeleeWeaponApi.EntityMelee.Rotation"
include "lib.MeleeWeaponApi.EntityMelee.State"
include "lib.MeleeWeaponApi.EntityMelee.Swing"

return EntityMelee
