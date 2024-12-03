-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local inspect = require "lib.inspect"
local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Callback = include "lib.MeleeWeaponApi.CallbackManager"
local Registry = include "lib.MeleeWeaponApi.RegistryManager"
local Util = include "lib.MeleeWeaponApi.Util"

---@class EntityMelee
local EntityMelee = mod.__EntityMelee or {}

--#region Metatable shenanigans

local Super = getmetatable(EntityEffect).__class
if not EntityMelee.__fxindex then
    EntityMelee.__fxindex = Super.__index
    EntityMelee.__fxnewindex = Super.__newindex
end

rawset(Super, "__index", function(self, key)
    local props = Registry.GetProps(self)
    if props then
        if EntityMelee[key] then return EntityMelee[key] end
        if props[key] then return props[key] end
    end

    return EntityMelee.__fxindex(self, key)
end)

rawset(Super, "__newindex", function(self, key, value)
    local props = Registry.GetProps(self)

    if props and props[key] then
        props[key] = value
        return
    end

    return EntityMelee.__fxnewindex(self, key, value)
end)

---Call a method from the parent class @{EntityEffect}
---@param name string Method name
---@param ... any
function EntityMelee:__fxcall(name, ...)
    local fn = EntityMelee.__fxindex(self, name)
    return fn(self, ...)
end

--#endregion Metatable shenanigans

--#region Defaults

---@class MeleeWeaponProps
local INITIAL_PROPS = {
    AimRotationOffset = 0,
    MovementRotationOffset = 0,
}

---@class MeleeWeaponState
local INITIAL_STATE = {
    AimRotationSource = nil, ---@type EntityPlayer?
    MovementRotationSource = nil, ---@type EntityPlayer?
}

--#endregion Defaults

--#region Class methods

---@return EntityMelee
function EntityMelee.FromEffect(effect)
    Registry.Add(effect, INITIAL_PROPS, INITIAL_STATE)
    Callback.RegisterDefaults(effect)
    return effect
end

---Destroy effect, sprite and remove EntityMelee from registry
function EntityMelee:Remove()
    self:__fxcall "Remove"
    Registry.Remove(self)
    return nil
end

---Set the weapon's rotation to follow a player's aim direction
---@param player EntityPlayer
function EntityMelee:RotateWithAim(player)
    Registry.GetState(self).AimRotationSource = Util.MustBePlayer(player)
end

---Set the weapon's rotation to follow a player's movement direction
---@param player EntityPlayer
function EntityMelee:RotateWithMovement(player)
    Registry.GetState(self).MovementRotationSource = Util.MustBePlayer(player)
end

--#endregion Class methods

mod.__EntityMelee = EntityMelee
return mod.__EntityMelee
