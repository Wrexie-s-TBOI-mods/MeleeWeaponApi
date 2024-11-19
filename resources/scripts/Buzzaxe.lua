-- BL2 Krieg - TBOI: Repentance character mod (c) by Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local Clock = include "resources.scripts.lib.Clock"
local inspect = require "resources.scripts.lib.inspect"

---
--- META DEFINITIONS
------------------------

---@class BuzzaxeState
---@field active    boolean       Has the weapon been activated recently ?
---@field beast     boolean       Is the current rampage in Beast mode ?
---@field clock     Clock         Frame counter for various time-based actions
---@field effect    EntityEffect  Weapon visuals
---@field hearts    integer       Red heart units at the time of activation
---@field shoot     boolean       During rampage, is the player holding shoot after a swing ?

local Buzzaxe = {}

Buzzaxe.ID = Isaac.GetItemIdByName "Buzzaxe"
Buzzaxe.EFFECT = Isaac.GetEntityVariantByName "Buzzaxe Visuals"

Buzzaxe.const = {
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

    CLOCK_CHARGE_TICKS = 60,

    CLOCK_ATTACK_TICKS = 60,

    MAX_CHARGES = Isaac.GetItemConfig():GetCollectible(Buzzaxe.ID).MaxCharges,
}

--- Table index is the player index
---@type table<integer, BuzzaxeState>
Buzzaxe.state = {}

---
--- STATE MANAGEMENT
------------------------

---@param player EntityPlayer
function Buzzaxe:getState(player)
    local id = player:GetPlayerIndex()

    if Buzzaxe.state[id] == nil then
        Buzzaxe.state[id] = {
            active = false,
            beast = false,
            clock = Clock(Buzzaxe.const.CLOCK_CHARGE_TICKS),
            ---@diagnostic disable-next-line: assign-type-mismatch
            effect = nil,
            hearts = 0,
            shoot = false,
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
        if player:GetActiveItem(slot) == Buzzaxe.ID then return slot end
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

function Buzzaxe:chargeClock()
    local game = Game()
    for i = 0, game:GetNumPlayers() do
        local player = game:GetPlayer(i)
        if player:HasCollectible(Buzzaxe.ID) and not Buzzaxe:isRampaging(player) then
            ---@type ActiveSlot
            ---@diagnostic disable-next-line: assign-type-mismatch Presence of the item is checked above, slot cannot be nil
            local slot = Buzzaxe:getSlot(player)
            local charge = player:GetActiveCharge(slot)
            local clock = Buzzaxe:getState(player).clock
            if charge < Buzzaxe.const.MAX_CHARGES and clock:tick() ~= 0 then
                player:AddActiveCharge(1, slot, charge >= Buzzaxe.const.MAX_CHARGES - 4, false, true)
            end
        end
    end
end

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param flags integer
---@param slot ActiveSlot
---@param custom integer
function Buzzaxe:onPreUseItem(item, rng, player, flags, slot, custom)
    if (flags & UseFlag.USE_CARBATTERY) == UseFlag.USE_CARBATTERY then return end
    print "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    print "Pre-rampage"

    local state = Buzzaxe:getState(player)
    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, Buzzaxe.EFFECT, 0, player.Position, Vector.Zero, player)
        :ToEffect()
    if not effect then
        error "Coudln't spawn Buzzaxe visuals. (this message should never appear)"
        return true
    end

    effect:FollowParent(player)
    state.effect = effect
    state.hearts = player:GetHearts()
    state.beast = state.hearts <= Buzzaxe.const.RTB_THRESHOLD
end

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param flags integer
---@param slot ActiveSlot
---@param custom integer
function Buzzaxe:onUseItem(item, rng, player, flags, slot, custom)
    if (flags & UseFlag.USE_CARBATTERY) == UseFlag.USE_CARBATTERY then return end
    print "Rampage"

    local state = Buzzaxe:getState(player)

    state.active = true
    if state.beast and player:CanPickRedHearts() then player:AddHearts(player:GetMaxHearts() - state.hearts) end

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
    if Buzzaxe:isRampaging(player) then return end

    local state = Buzzaxe:getState(player)
    if not state.active then return end
    print "Post-rampage"

    local slot = Buzzaxe:getSlot(player)
    if slot ~= nil and state.beast then player:FullCharge(slot, true) end

    state.active = false
    state.beast = false
    state.shoot = false
    state.effect:Remove()
    state.effect = nil
    state.clock:reset(Buzzaxe.const.CLOCK_CHARGE_TICKS)
end

---@param mod ModReference
function Buzzaxe.init(mod)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Buzzaxe.chargeClock)
    mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, Buzzaxe.onPreUseItem, Buzzaxe.ID)
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, Buzzaxe.onUseItem, Buzzaxe.ID)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Buzzaxe.postRampage, PlayerVariant.PLAYER)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Buzzaxe.onEvalCacheDamage, CacheFlag.CACHE_DAMAGE)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Buzzaxe.onEvalCacheSpeed, CacheFlag.CACHE_SPEED)
end

return Buzzaxe
