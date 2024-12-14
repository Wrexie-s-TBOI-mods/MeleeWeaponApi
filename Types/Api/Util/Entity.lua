-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable)
---@diagnostic disable: unused-local

---@class MeleeWeaponApiUtil
local Util = {}

---@param entity Entity
---@return string EntityId Fully qualified entity ID in the form `<Type>.<Variant>.<SubType>`
function Util.GetEntityId(entity) end

--[[
    Throws an error if given entity is not an `EntityPlayer`.
    ]]
---@param entity Entity
---@return EntityPlayer
function Util.MustBePlayer(entity) end

--[[
    Throws an error if given entity is not an `EntityEffect`.
    ]]
---@param entity Entity
---@return EntityEffect
function Util.MustBeEffect(entity) end
