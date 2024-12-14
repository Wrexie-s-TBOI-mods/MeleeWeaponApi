-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

--# selene: allow(global_usage)

local mod = require "Api.mod" ---@class MeleeWeaponApiModReference

local Api = mod.__Api or include "Api.API"
mod.__Api = Api

_G.MeleeWeaponApi = Api

---@type MeleeWeaponApiDebugMode
local DebugMode = {
    Nope = 0,
    Yep = 1,
    Clean = -1,
}

function _G.dprint(...)
    if Api.DebugMode == DebugMode.Nope then return end
    if Api.DebugMode == DebugMode.Yep then print(...) end
    if Api.DebugMode == DebugMode.Clean then error("CLEANUP YOUR DEBUG PRINTS, DUMMY.", 1) end
end

--[[
    Though it might be tempting to sort these alphabetically (I'm looking at you, future Wrexes),
    don't do it. It might break things. I'm not entirely sure. Maybe I should...
    NO. RESIST THE TEMPTATION.
    ]]
include "Api.Util.init"
include "Api.EntityMelee.init"
include "Api.Callbacks.init"

return Api
