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
    Sets both the entity and it's sprite `.Rotation` property to the given angle.  
    Vector `angle` is converted to a number using `angle:GetAngleDegrees()`.
    ]]
---@param angle Vector
function EntityMelee:Rotate(angle) end

--[[
    Sets both the entity and it's sprite `.Rotation` property to the given angle.  
    ]]
---@param angle number
function EntityMelee:Rotate(angle) end
