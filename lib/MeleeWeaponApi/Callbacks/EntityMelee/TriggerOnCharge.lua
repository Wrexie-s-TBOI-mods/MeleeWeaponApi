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
local function TriggerOnCharge(_mod, weapon)
    if not weapon:IsCharging() then return end

    if weapon.ChargePercentage < 100 then
        weapon:OnChargeUpdate()
    else
        weapon:OnChargeFull()
    end
end

return {
    {
        key = Callbacks.MC_POST_WEAPON_UPDATE,
        fn = TriggerOnCharge,
    },
}
