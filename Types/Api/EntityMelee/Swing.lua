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

---@class EntityMelee : EntityEffect, EntityMeleeProps
local EntityMelee = {}

--[[
    Swing the weapon.  
    If `force` is false, when `self:OnSwingStart()` returns a truthy value, does nothing.  
    ]]
---@param animation string  Animation to play
---@param force?    boolean Ignore `self:OnSwingStart()` [Default: `false`]
function EntityMelee:Swing(animation, force) end
