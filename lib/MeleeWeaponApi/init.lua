-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

--# selene: allow(global_usage)

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Api = mod.__Api or include "lib.MeleeWeaponApi.Api" ---@class MeleeWeaponApi
mod.__Api = Api

---@enum MWADebug
local MWADebug = {
    ---Logging with @{dprint} will print nothing.
    Nope = 0,

    ---Logging with @{dprint} will work normally.
    Yep = 1,

    ---Will throw an error if @{dprint} is used.
    Cleanup = -1,
}

Api.DEBUG = MWADebug.Nope ---@type MWADebug

_G.MeleeWeaponApi = Api

--[[Print stuff to the console but only in debug mode.
    ]]
function _G.dprint(...)
    if Api.DEBUG == MWADebug.Nope then return end
    if Api.DEBUG == MWADebug.Yep then print(...) end
    if Api.DEBUG == MWADebug.Cleanup then error("CLEANUP YOUR DEBUG PRINTS, DUMMY.", 1) end
end

--[[Though it might be tempting to sort these alphabetically (I'm looking at you, future Wrexes),
    don't do it. It might break things. I'm not entirely sure. Maybe I should...
    NO. RESIST THE TEMPTATION.
    ]]
include "lib.MeleeWeaponApi.Util.init"
include "lib.MeleeWeaponApi.EntityMelee.init"
include "lib.MeleeWeaponApi.Callbacks.init"

return Api
