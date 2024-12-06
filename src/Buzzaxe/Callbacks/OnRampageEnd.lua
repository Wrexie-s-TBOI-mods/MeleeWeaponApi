-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe"

---@param player EntityPlayer
local function OnRampageEnd(_mod, player)
    local state = Buzzaxe.state[player]

    if not state or not state.active or Buzzaxe:isRampaging(player) then return end
    Buzzaxe:CleanupState(player)
end

---@type ModCallbackModule
return {
    force = true,
    {
        key = ModCallbacks.MC_POST_PLAYER_UPDATE,
        fn = OnRampageEnd,
        param = PlayerVariant.PLAYER,
    },
}
