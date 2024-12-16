-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

-- #selene: allow(global_usage)

if mod then return mod end

_G.mod = RegisterMod("!![Repentogon] Melee Weapon API", 1) ---@class ApiModReference

mod.__Api = mod.__Api or {
    Util = {},
    Callbacks = {},
}

mod.__EntityMelee = mod.__EntityMelee or {}

mod.__CallbackManager = mod.__CallbackManager or {}

mod.__Registry = mod.__Registry or {
    size = 0,
}

mod.__RegistryManager = mod.__RegistryManager or {}

_G.MeleeWeaponApi = mod.__Api

_G.mod = mod

if not _G.dprint then
    ---@type MeleeWeaponApiDebugMode
    local DebugMode = {
        Nope = 0,
        Yep = 1,
        Clean = -1,
    }

    function _G.dprint(...)
        if MeleeWeaponApi.DebugMode == DebugMode.Nope then return end
        if MeleeWeaponApi.DebugMode == DebugMode.Yep then print(...) end
        if MeleeWeaponApi.DebugMode == DebugMode.Clean then error("CLEANUP YOUR DEBUG PRINTS, DUMMY.", 1) end
    end
end

return mod
