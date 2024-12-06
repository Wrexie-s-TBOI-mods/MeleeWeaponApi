-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe"
local Constants = Buzzaxe.Constants or include "src.Buzzaxe.Constants"

---@param _mod      KriegModReference
---@param item      CollectibleType
---@param rng       RNG
---@param player    EntityPlayer
---@param flags     integer
---@param slot      ActiveSlot
---@param custom    integer
local function OnUseItem(_mod, item, rng, player, flags, slot, custom)
    if (flags & UseFlag.USE_CARBATTERY) == UseFlag.USE_CARBATTERY then return end
    dprint "\n\n\n\n\n\n\n"
    dprint "[Buzzaxe#OnUseItem] Init"

    Buzzaxe:DestroyBaseWeapon(player)

    local axe, state = Buzzaxe:CreateBuzzaxe(player)

    state.hearts = player:GetHearts()
    -- state.beast = state.hearts <= Item.const.RTB_THRESHOLD
    state.beast = true
    state.active = true
    state.buzzaxe = axe

    if state.beast and player:CanPickRedHearts() then player:AddHearts(player:GetMaxHearts()) end

    axe:Swing(axe.CustomData.Animations.Swing:Next())

    return {
        ShowAnim = true,
        Remove = false,
        Discharge = true,
    }
end

---@type ModCallbackModule
return {
    force = true,
    {
        key = ModCallbacks.MC_USE_ITEM,
        fn = OnUseItem,
        param = Constants.BUZZAXE_ITEM_ID,
    },
}
