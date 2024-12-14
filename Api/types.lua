-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(global_usage)

---@class RegistryEntry
---@field props     EntityMeleeProps
---@field state     EntityMeleeState

---@class ApiModReference : ModReference
---@field __Api             MeleeWeaponApi
---@field __EntityMelee     EntityMelee
---@field __CallbackManager CallbackManager
---@field __Registry        Registry
---@field __RegistyManager  RegistryManager
local mod = {}

_G.mod = mod
