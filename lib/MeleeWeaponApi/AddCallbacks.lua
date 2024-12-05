-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local RegistryManager = include "lib.MeleeWeaponApi.RegistryManager"
local MeleeCallback = include "lib.MeleeWeaponApi.Callbacks"

---@class MeleeWeaponCallbackManager
local CallbackManager = mod.__CallbackManager or {}

---Trigger MC_POST_WEAPON_RENDER
mod:AddCallback(
    ModCallbacks.MC_POST_EFFECT_RENDER,
    ---@param _ MeleeWeaponApiModReference
    ---@param effect EntityEffect
    ---@param offset Vector
    function(_, effect, offset)
        if RegistryManager.Has(effect) then Isaac.RunCallback(MeleeCallback.MC_POST_WEAPON_RENDER, effect, offset) end
    end
)

---Trigger MC_POST_WEAPON_UPDATE
mod:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    ---@param _ MeleeWeaponApiModReference
    ---@param effect EntityEffect
    function(_, effect)
        if RegistryManager.Has(effect) then Isaac.RunCallback(MeleeCallback.MC_POST_WEAPON_UPDATE, effect) end
    end
)

---Trigger `:OnPostSwing()`
mod:AddCallback(
    MeleeCallback.MC_POST_WEAPON_UPDATE,
    ---@param _ MeleeWeaponApiModReference
    ---@param weapon EntityMelee
    function(_, weapon)
        if not weapon:IsSwinging() then return end

        local state = RegistryManager.GetState(weapon)
        local sprite = weapon:GetSprite()

        if sprite:IsFinished(state.CurrentAnimation) then
            state.IsSwinging = false
            weapon:OnPostSwing()
            return
        end
    end
)

---Render and update chargebar if active
mod:AddCallback(
    MeleeCallback.MC_POST_WEAPON_RENDER,
    ---@param _ MeleeWeaponApiModReference
    ---@param weapon EntityMelee
    function(_, weapon)
        local state = RegistryManager.GetState(weapon)
        local bar = state.Chargebar

        if not bar then return end

        local percent = math.max(0, weapon.ChargePercentage)

        if state.IsCharging then
            if percent < 99 then
                bar:SetFrame("Charging", math.floor(percent))
            elseif bar:IsFinished "StartCharged" or bar:IsFinished "Charged" then
                bar:Play("Charged", true)
            elseif not bar:IsPlaying "StartCharged" and not bar:IsPlaying "Charged" then
                bar:Play("StartCharged", true)
            end
        elseif not bar:IsPlaying "Disappear" then
            if bar:IsFinished "Disappear" then
                state.Chargebar = nil
            else
                bar:Play("Disappear", true)
            end
        end

        bar:Render(weapon:GetChargebarPosition())
        bar:Update()
    end
)

---Trigger EntityMelee:OnChargeUpdate() and EntityMelee:OnChargeFull()
mod:AddCallback(
    MeleeCallback.MC_POST_WEAPON_UPDATE,
    ---@param _ MeleeWeaponApiModReference
    ---@param weapon EntityMelee
    function(_, weapon)
        if not weapon:IsCharging() then return end
        if weapon.ChargePercentage < 100 then
            weapon:OnChargeUpdate()
        else
            weapon:OnChargeFull()
        end
    end
)

mod.__CallbackManager = CallbackManager
return mod.__CallbackManager
