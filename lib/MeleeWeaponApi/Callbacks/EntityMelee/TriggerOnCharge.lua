-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod"
local Callbacks = mod.__Api.Callbacks or include "lib.MeleeWeaponApi.Callbacks.CallbackId"

--- FIXME: `EntityMelee:OnChargeRelease()` is called in the `RenderChargeBar` callback,
--- as is easier to tie it to the animation of the chargebar.
--- At some point, chargebar rendering and charge states should be separated, because
--- maybe not everyone wants a chargebar to appear when charging the weapon.
--- Maybe they have some fancy animations that do the trick or whatever, who knows ?

---@param _mod      MeleeWeaponApiModReference
---@param weapon    EntityMelee
local function TriggerOnCharge(_mod, weapon)
    if not weapon:GetState().IsCharging then return end

    if weapon.ChargePercentage < 100 then
        weapon:OnChargeUpdate()
    else
        weapon:OnChargeFull()
    end
end

return {
    force = true,
    {
        key = Callbacks.MC_POST_WEAPON_UPDATE,
        fn = TriggerOnCharge,
    },
}
