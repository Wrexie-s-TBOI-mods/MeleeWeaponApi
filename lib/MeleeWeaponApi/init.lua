-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Api = mod.__Api or include "lib.MeleeWeaponApi.Api"
mod.__Api = Api

--[[Though it might be tempting to sort these alphabetically (I'm looking at you, future Wrexes),
    don't do it. It might break things. I'm not entirely sure. Maybe I should...
    NO. RESIST THE TEMPTATION.
    ]]
include "lib.MeleeWeaponApi.Util.init"
include "lib.MeleeWeaponApi.EntityMelee.init"
include "lib.MeleeWeaponApi.Callbacks.init"

-- selene: allow(global_usage)

_G.MeleeWeaponApi = Api

return Api
