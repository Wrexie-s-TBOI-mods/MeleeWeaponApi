-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Custom = mod.Api.Callbacks

---@param _mod      ApiModReference
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
        key = Custom.MC_POST_WEAPON_UPDATE,
        fn = TriggerOnSwing,
    },
}
