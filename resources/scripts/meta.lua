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
---@field variant   integer             Entity variant
---@field spawner   Entity              The effect's SpawnerEntity — Default: `player`
---@field subtype?  integer             Entity subtype — Default: 0
---@field posvel?   PosVel              Initial position and velocity — Default: `player`'s pos and `Vector.Zero`
---@field follow?   boolean             Follow the spawner — Default: true
---@field aim?      EntityPlayer|false  Follow this player's aim — Default: `spawner` if it's a player, `false` otherwise

---@class RegistryCallback
---@field [1]   function    Callback function
---@field [2]   integer?    `AddCallback` third parameter

---@alias RegistryCallbackTable table<ModCallbacks, RegistryCallback>

---@class WeaponRegistryEntry
---@field weapon    MeleeWeapon
---@field callbacks RegistryCallbackTable

---@class WeaponRegistry
---@field [integer] WeaponRegistryEntry
