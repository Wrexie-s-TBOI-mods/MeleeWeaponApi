-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Callbacks = mod.Api.Callbacks
local RegistryManager = mod.RegistryManager

---@param _mod      ApiModReference
---@param effect    EntityEffect
---@param offset    Vector
local function TriggerMcPostWeaponRender(_mod, effect, offset)
    if not RegistryManager.Has(effect) then return end

    Isaac.RunCallback(Callbacks.MC_POST_WEAPON_RENDER, effect, offset)
end

---@type ModCallbackModule
return {
    force = true,
    {
        key = ModCallbacks.MC_POST_EFFECT_RENDER,
        fn = TriggerMcPostWeaponRender,
    },
}
