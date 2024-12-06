-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe"

---@param charge integer
function ShouldFlashChargebar(charge)
    return charge >= Buzzaxe.Constants.BUZZAXE_MAX_CHARGES - Buzzaxe.Constants.CHARGEBAR_FLASH_THRESHOLD
end

---@param player    EntityPlayer
---@param force?    boolean
function ChargeActiveItem(player, force)
    if not player:HasCollectible(Buzzaxe.Constants.BUZZAXE_ITEM_ID) or Buzzaxe:isRampaging(player) and not force then
        return
    end

    local slot = assert(Buzzaxe:GetSlot(player))
    local charge = player:GetActiveCharge(slot)
    local clock = Buzzaxe.state[player].clock

    if charge < Buzzaxe.Constants.BUZZAXE_MAX_CHARGES and clock:tick() ~= 0 then
        player:AddActiveCharge(1, slot, ShouldFlashChargebar(charge), false, true)
    end
end

---@param _mod KriegModReference
function ActiveChargeTimer(_mod)
    local game = Game()

    for i = 0, game:GetNumPlayers() do
        ChargeActiveItem(game:GetPlayer(i))
    end
end

---@type ModCallbackModule
return {
    force = true,
    {
        key = ModCallbacks.MC_POST_PLAYER_UPDATE,
        fn = ActiveChargeTimer,
        param = PlayerVariant.PLAYER,
    },
}
