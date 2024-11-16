-- BL2 Krieg - TBOI: Repentance character mod (c) by Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local BuzzaxeRampage = require "resources.scripts.BuzzaxeRampage"

local Buzzaxe = {
    ID = Isaac.GetItemIdByName "Buzzaxe",
}

function Buzzaxe:onUse(item, rng, entity, useFlags, slot, custom)
    local Player = Isaac.GetPlayer()
    if Player == nil then return end

    local hearts = Player:GetHearts()
    local releaseTheBeast = (hearts <= 2)
    local Effects = Player:GetEffects()

    if releaseTheBeast then
        if Player:CanPickRedHearts() then
            Player:AddHearts(Player:GetMaxHearts() - hearts)
        end
    end

    Effects:AddCollectibleEffect(BuzzaxeRampage.ID)

    return {
        ShowAnim = false,
        Remove = false,
        Discharge = not releaseTheBeast,
    }
end

function Buzzaxe:preventBatteryPickup(pickup, entity)
    local player = entity:ToPlayer()
    if player and player:GetActiveItem() == Buzzaxe.ID then
        return false
    end
end

function Buzzaxe.init(mod)
    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Buzzaxe.preventBatteryPickup, PickupVariant.PICKUP_LIL_BATTERY)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, Buzzaxe.onUse, Buzzaxe.ID)
end

return Buzzaxe
