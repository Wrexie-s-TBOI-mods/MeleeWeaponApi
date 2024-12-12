-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod"
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe"

local Util = MeleeWeaponApi.Util

---@param _mod      KriegModReference
---@param player    EntityPlayer
local function OnPlayerInitState(_mod, player)
    Buzzaxe:InitState(player)
    print(Util.Inspect(Buzzaxe.state[player]))
end

---@type ModCallbackModule
return {
    force = true,
    {
        key = ModCallbacks.MC_POST_PLAYER_INIT,
        fn = OnPlayerInitState,
        param = PlayerVariant.PLAYER,
    },
}
