-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = require "Api.mod" ---@class MeleeWeaponApiModReference

local Api = mod.__Api or {}
Api.Callbacks = mod.__Api.Callbacks or include "Api.Callbacks.CallbackId"

include "Api.Callbacks.init"

return Api.Callbacks
