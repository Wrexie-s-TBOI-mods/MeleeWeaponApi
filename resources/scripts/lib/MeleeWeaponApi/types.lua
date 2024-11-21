-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

---@meta

---@class MeleeWeapon
---@field Effect            EntityEffect
---@field Sprite            Sprite
---@field RotationOffset    number          Added to any rotation

---@class MeleeWeaponCreateOptions
---@field Variant   integer             Entity variant
---@field Spawner   Entity              The effect's SpawnerEntity — Default: `player`
---@field Subtype?  integer             Entity subtype — Default: 0
---@field PosVel?   PosVel              Initial position and velocity — Default: `player`'s pos and `Vector.Zero`
---@field Follow?   boolean             Follow the spawner — Default: true
---@field Aim?      EntityPlayer|false  Follow this player's aim — Default: `spawner` if it's a player, `false` otherwise

---@class MeleeWeaponState
---@field owner Entity

---@class RegistryCallback
---@field [1]   function    Callback function
---@field [2]   integer?    `AddCallback` third parameter

---@alias RegistryCallbackTable table<ModCallbacks, table<RegistryCallback>>

---@class WeaponRegistryEntry
---@field weapon    MeleeWeapon
---@field options   MeleeWeaponCreateOptions
---@field state     MeleeWeaponState
---@field callbacks RegistryCallbackTable
