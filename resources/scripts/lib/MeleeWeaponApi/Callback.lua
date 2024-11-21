-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

---@enum MeleeWeaponCallback
return setmetatable({
    MC_POST_WEAPON_INIT = "WREX.MeleeWeaponApi.MC_POST_WEAPON_INIT",
    MC_POST_WEAPON_UPDATE = "WREX.MeleeWeaponApi.MC_POST_WEAPON_UPDATE",
    MC_POST_WEAPON_RENDER = "WREX.MeleeWeaponApi.MC_POST_WEAPON_RENDER",
}, {
    __newindex = function()
        error "Trying to edit MeleeWeaponCallback enum."
    end,
    __metatable = false,
})
