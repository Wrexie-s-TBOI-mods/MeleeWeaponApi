-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

---@meta

---@class EntityMelee : EntityEffect, MeleeWeaponProps

---@class MeleeWeaponCreateOptions
---@field Variant   integer             Entity variant
---@field Spawner   Entity              The effect's SpawnerEntity — Default: `player`
---@field Subtype?  integer             Entity subtype — Default: 0
---@field PosVel?   PosVel              Initial position and velocity — Default: `player`'s pos and `Vector.Zero`
---@field Follow?   boolean             Follow the spawner — Default: true

---@alias CallbackFn fun(ModReference, ...)

---@class RegistryCallback
---@field [1] CallbackFn    Callback function
---@field [2] integer?      `AddCallback` third parameter

---@alias RegistryCallbackTable table<ModCallbacks, table<RegistryCallback>>

---@class WeaponRegistryEntry
---@field props     MeleeWeaponProps
---@field state     MeleeWeaponState
---@field callbacks RegistryCallbackTable

---@class MeleeWeaponApiModReference : ModReference
