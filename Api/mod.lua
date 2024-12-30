-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

-- #selene: allow(global_usage)
---@diagnostic disable: missing-fields

if MeleeWeaponApi then return _G[MeleeWeaponApi] end

local mod = RegisterMod("!![Repentogon] Melee Weapon API", 1) ---@class ApiModReference

mod.Api = {
    Util = {},
    Callbacks = {},
}

mod.EntityMelee = {}

mod.CallbackManager = {}

mod.Registry = {
    size = 0,
}

mod.RegistryManager = {}

_G.MeleeWeaponApi = mod.Api
_G[MeleeWeaponApi] = mod

---@type MeleeWeaponApiDebugMode
local DebugMode = {
    Off = 0,
    On = 1,
    Cleanup = -1,
}

function _G.dprint(...)
    if MeleeWeaponApi.DebugMode == DebugMode.On then
        print(...)
    elseif MeleeWeaponApi.DebugMode == DebugMode.Cleanup then
        error("CLEANUP YOUR DEBUG PRINTS, DUMMY.", 1)
    end
end

return mod
