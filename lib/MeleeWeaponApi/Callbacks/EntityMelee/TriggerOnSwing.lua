-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod"
local Callbacks = mod.__Api.Callbacks or include "lib.MeleeWeaponApi.Callbacks.CallbackId"

---@param _mod      MeleeWeaponApiModReference
---@param weapon    EntityMelee
local function TriggerOnSwing(_mod, weapon)
    local state = weapon:GetState(true)
    if not state.IsSwinging then return end

    local sprite = weapon:GetSprite()
    local blacklist = state.SwingHitBlacklist or {}

    state.SwingHitBlacklist = blacklist

    ---@param entity Entity
    local function Hit(entity)
        local hash = GetPtrHash(entity)
        if blacklist[hash] then return end
        blacklist[hash] = weapon:OnSwingHit(entity) == nil
    end

    for _, layer in ipairs(weapon.Capsules) do
        local capsule = weapon:GetNullCapsule(layer)

        for _, entity in ipairs(Isaac.FindInCapsule(capsule, weapon.SwingTargets)) do
            Hit(entity)
        end
    end

    if sprite:IsFinished(state.CurrentAnimation) then
        state.IsSwinging = false
        state.SwingHitBlacklist = nil
        weapon:OnSwingEnd()
    end
end

---@type ModCallbackModule
return {
    force = true,
    {
        key = Callbacks.MC_POST_WEAPON_UPDATE,
        fn = TriggerOnSwing,
    },
}
