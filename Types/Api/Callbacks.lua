-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable, global_usage)
---@diagnostic disable: unused-local

---@enum MeleeWeaponApi.Callbacks
local Callbacks = {
    MC_POST_WEAPON_INIT = nil, ---@type string
    MC_POST_WEAPON_UPDATE = nil, ---@type string
    MC_POST_WEAPON_RENDER = nil, ---@type string
}

_G.MeleeWeaponApi.Callbacks = Callbacks
