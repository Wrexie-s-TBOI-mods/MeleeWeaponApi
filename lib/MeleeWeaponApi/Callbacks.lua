-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Callbacks = mod.__Callbacks or {}

Callbacks.MC_POST_WEAPON_INIT = "WREX.MeleeWeaponApi.MC_POST_WEAPON_INIT"
Callbacks.MC_POST_WEAPON_UPDATE = "WREX.MeleeWeaponApi.MC_POST_WEAPON_UPDATE"
Callbacks.MC_POST_WEAPON_RENDER = "WREX.MeleeWeaponApi.MC_POST_WEAPON_RENDER"

mod.__Callbacks = Callbacks
return mod.__Callbacks
