-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local CB = include "resources.scripts.lib.MeleeWeaponApi.Callback"
local Registry = include "resources.scripts.lib.MeleeWeaponApi.Registry"

---@class MeleeWeaponCallbackManager
local Manager = {}

---@return RegistryCallbackTable callbacks
function Manager.GetDefaults(weapon)
    local function state()
        return Registry.GetState(weapon)
    end

    local function thisWeapon(effect)
        return GetPtrHash(effect) == GetPtrHash(weapon.Effect)
    end

    local function isOwner(entity)
        return GetPtrHash(entity) == GetPtrHash(state().owner)
    end

    return {
        [ModCallbacks.MC_POST_EFFECT_UPDATE] = {
            {
                function(_, effect)
                    if thisWeapon(effect) then Isaac.RunCallback(CB.MC_POST_WEAPON_UPDATE, weapon) end
                end,
                weapon.Effect.Variant,
            },
        },
        [ModCallbacks.MC_POST_EFFECT_RENDER] = {
            {
                function(_, effect, offset)
                    if thisWeapon(effect) then Isaac.RunCallback(CB.MC_POST_WEAPON_RENDER, weapon, offset) end
                end,
                weapon.Effect.Variant,
            },
        },
    }
end

---@param weapon MeleeWeapon
function Manager.RegisterDefaults(weapon)
    Registry.AddCallbacks(weapon, Manager.GetDefaults(weapon))
end

return setmetatable(Manager, {
    __index = Manager,
    __newindex = function()
        error "Trying to edit MeleeWeaponApi's CallBackManager"
    end,
})
