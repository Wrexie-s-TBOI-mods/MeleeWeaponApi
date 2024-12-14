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

--[[
    Create a deep copy of a table.  
    If passed anything else than a table, directly returns the passed value.  
    Be aware that the more complex the table is, the harder more performance takes hit.
    ]]
---@generic Table : table --- That doc comment be like https://youtu.be/XtAhISkoJZc
---@param table Table
---@return Table
function Util.Clone(table) end
