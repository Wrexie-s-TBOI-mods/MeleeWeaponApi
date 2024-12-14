-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable)
---@diagnostic disable: missing-return, unused-local

---@class EntityMelee
local EntityMelee = {}

--[[
    Start charging the weapon.  
    Triggers `self:OnStartCharge()` and, if it returns a truthy value, does nothing.  
    Otherwise, updates `Chargebar` property and `IsCharging` state.
    ]]
function EntityMelee:StartCharging() end

--[[
    Stop charging the weapon.  
    Triggers `self:OnchargeEnd()` and, if it returns a truthy value, does nothing.  
    Otherwise, updates `IsCharging` state then triggers `self:OnChargeRelease()`.
]]
function EntityMelee:StopCharging() end
