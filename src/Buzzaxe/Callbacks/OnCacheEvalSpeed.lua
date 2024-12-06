-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe"

--- Apply speed multiplier during rampage
---@param _mod      KriegModReference
---@param player    EntityPlayer
function OnEvalCacheSpeed(_mod, player)
    if not Buzzaxe:isRampaging(player) then return end

    local speed = player.MoveSpeed * Buzzaxe.Constants.MULT_SPEED
    player.MoveSpeed = math.min(speed, Buzzaxe.Constants.MAX_SPEED)
end

---@type ModCallbackModule
return {
    {
        key = ModCallbacks.MC_EVALUATE_CACHE,
        fn = OnEvalCacheSpeed,
        param = CacheFlag.CACHE_SPEED,
    },
}
