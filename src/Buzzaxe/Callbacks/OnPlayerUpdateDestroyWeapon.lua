-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe"

---@param _mod      KriegModReference
---@param player    EntityPlayer
local function OnPlayerUpdateRemoveWeapon(_mod, player)
    if not Buzzaxe:isRampaging(player) then return end
    Buzzaxe:DestroyBaseWeapon(player)
end

---@type ModCallbackModule
return {
    {
        key = ModCallbacks.MC_POST_PLAYER_UPDATE,
        fn = OnPlayerUpdateRemoveWeapon,
        param = PlayerVariant.PLAYER,
    },
}
