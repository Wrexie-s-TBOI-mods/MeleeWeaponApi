-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = require "Api.mod" ---@class MeleeWeaponApiModReference

local EntityMelee = mod.__EntityMelee or {}
mod.__EntityMelee = EntityMelee

function EntityMelee:StartCharging()
    if self:OnChargeStart() then return end

    local state = self:GetState(true)

    if not state.Chargebar then
        state.Chargebar = Sprite()
        state.Chargebar:Load(self.ChargebarSprite, true)
    end

    state.IsCharging = true
end

function EntityMelee:StopCharging()
    if self:OnChargeEnd() then return end

    self:GetState(true).IsCharging = false
    self:OnChargeRelease()
end
