-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local Custom = mod.__Api.Callbacks

---@param _mod      ApiModReference
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
        key = Custom.MC_POST_WEAPON_UPDATE,
        fn = TriggerOnCharge,
    },
}
