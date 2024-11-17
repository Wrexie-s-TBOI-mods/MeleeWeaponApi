-- BL2 Krieg - TBOI: Repentance character mod (c) by Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

---
--- META DEFINITIONS
------------------------

---@class BuzzaxeState
---@field beast         boolean Is the current rampage Beast mode ?

local Buzzaxe = {
    ID = Isaac.GetItemIdByName "Buzzaxe",

    const = {
        --- Max number of hearts to trigger Relase The Beast.
        --- 1 unit represents half a heart.
        RTB_THRESHOLD = 2,

        MULT_SPEED = 1.4,

        MULT_DAMAGE = {
            --- In Beast mode
            [true] = 5,

            --- In non Beast mode
            [false] = 4,
        },

        MAX_SPEED = 2,
    },

    ---@type table<integer, BuzzaxeState>
    state = {},
}

---
--- STATE MANAGEMENT
------------------------

---@param player EntityPlayer
function Buzzaxe:getState(player)
    local id = player:GetPlayerIndex()

    if Buzzaxe.state[id] == nil then
        Buzzaxe.state[id] = {
            beast = false,
        }
    end

    return Buzzaxe.state[id]
end

---@param player EntityPlayer
function Buzzaxe:shouldReleaseTheBeast(player)
    local hearts = player:GetHearts() + player:GetRottenHearts()
    return hearts <= Buzzaxe.const.RTB_THRESHOLD
end

---@param player EntityPlayer
---@return ActiveSlot?
function Buzzaxe:getSlot(player)
    for _, slot in pairs(ActiveSlot) do
        if player:GetActiveItem(slot) == Buzzaxe.ID then
            return slot
        end
    end
end

---@param player EntityPlayer
function Buzzaxe:isHoldingBuzzaxe(player)
    return Buzzaxe:getSlot(player) ~= -1
end

---@param player EntityPlayer
function Buzzaxe:isRampaging(player)
    return player:GetEffects():HasCollectibleEffect(Buzzaxe.ID)
end

---
--- MOD CALLBACKS
------------------------

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param useFlags integer
---@param slot ActiveSlot
---@param custom integer
function Buzzaxe:onPreUseItem(item, rng, player, useFlags, slot, custom)
    local state = Buzzaxe:getState(player)
    state.beast = Buzzaxe:shouldReleaseTheBeast(player)
end

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param useFlags integer
---@param slot ActiveSlot
---@param custom integer
function Buzzaxe:onUseItem(item, rng, player, useFlags, slot, custom)
    local state = Buzzaxe:getState(player)
    local hearts = player:GetMaxHearts()

    if state.beast and player:CanPickRedHearts() then
        player:AddHearts(hearts - Buzzaxe.const.RTB_THRESHOLD)
    end

    return {
        ShowAnim = true,
        Remove = false,
        Discharge = true,
    }
end

--- Apply speed multiplier during rampage
---@param player EntityPlayer
function Buzzaxe:onEvalCacheSpeed(player)
    if not Buzzaxe:isRampaging(player) then return end

    local speed = player.MoveSpeed * Buzzaxe.const.MULT_SPEED
    player.MoveSpeed = math.min(speed, Buzzaxe.const.MAX_SPEED)
end

--- Apply damage multiplier during rampage
---@param player EntityPlayer
function Buzzaxe:onEvalCacheDamage(player)
    if not Buzzaxe:isRampaging(player) then return end

    local state = Buzzaxe:getState(player)
    player.Damage = player.Damage * Buzzaxe.const.MULT_DAMAGE[state.beast]
end

--- After a rampage, maybe charge the item if it was beast mode.
--- Then cleanup state.
---@param player EntityPlayer
function Buzzaxe:postRampage(player)
    if Buzzaxe:isRampaging(player) then
        return
    end

    local state = Buzzaxe:getState(player)
    if not state.beast then return end

    local slot = Buzzaxe:getSlot(player)
    if slot ~= nil then
        player:FullCharge(slot, true)
    end

    state.beast = false
end

function Buzzaxe:preventBatteryPickup(_pickup, entity)
    local player = entity:ToPlayer()
    if player and player:GetActiveItem() == Buzzaxe.ID then
        return false
    end
end

function Buzzaxe.init(mod)
    mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, Buzzaxe.onPreUseItem, Buzzaxe.ID)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, Buzzaxe.onUseItem, Buzzaxe.ID)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Buzzaxe.postRampage, PlayerVariant.PLAYER)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Buzzaxe.onEvalCacheDamage, CacheFlag.CACHE_DAMAGE)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Buzzaxe.onEvalCacheSpeed, CacheFlag.CACHE_SPEED)
    -- mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Buzzaxe.preventBatteryPickup, PickupVariant.PICKUP_LIL_BATTERY)
end

return Buzzaxe
