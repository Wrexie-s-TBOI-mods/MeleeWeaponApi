-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"

include "Api.EntityMelee.Charge"
include "Api.EntityMelee.Properties"
include "Api.EntityMelee.Rotation"
include "Api.EntityMelee.State"
include "Api.EntityMelee.Swing"

local RegistryManager = mod.RegistryManager
local CallbackManager = mod.CallbackManager

local EntityMelee = mod.EntityMelee ---@class EntityMelee

if not EntityMelee.__super then
    local super = getmetatable(EntityEffect).__class ---@type metatable

    ---@private
    EntityMelee.__super = super

    ---@private
    EntityMelee.__fxindex = super.__index

    ---@private
    EntityMelee.__fxnewindex = super.__newindex

    --[[
        Call a method from the parent class EntityEffect
        ]]
    ---@param name string Method name
    ---@param ...  any
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

--[[
    Create an EntityMelee instance from an EntityEffect.
    ]]
---@param effect Entity
---@return EntityMelee
function EntityMelee:FromEffect(effect)
    effect = assert(effect:ToEffect())
    RegistryManager.Add(effect, self.GetInitialProps(), self.GetInitialState())

    ---@diagnostic disable-next-line: return-type-mismatch
    return effect
end

function EntityMelee:Remove()
    self:__fxcall "Remove"
    RegistryManager.Remove(self)
    CallbackManager:RemoveEntries(self)
    return nil
end
