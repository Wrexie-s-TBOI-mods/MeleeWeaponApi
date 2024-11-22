-- BL2 Krieg - TBOI: Repentance character mod (c) by Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local Clock = include "lib.Clock"
local inspect = include "lib.inspect"

local Melee = include "lib.MeleeWeaponApi.API"

---
--- META DEFINITIONS
------------------------

---@class ItemState
---@field clock         Clock           Frame counter for various time-based actions
---@field active        boolean         Has the weapon been activated recently ?
---@field beast         boolean         Is the current rampage in Beast mode ?
---@field hearts        integer         Red heart units at the time of activation
---@field shoot         boolean         During rampage, is the player holding shoot after a swing ?
---@field weapon        WeaponType      Player's weapon type when not rampaging
---@field buzzaxe       MeleeWeapon     Ramapage weapon

local Item = {}

Item.ID = Isaac.GetItemIdByName "Buzzaxe"
Item.EFFECT_VARIANT = Isaac.GetEntityVariantByName "Buzzaxe Effect"

Item.const = {
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

    MAX_CHARGES = Isaac.GetItemConfig():GetCollectible(Item.ID).MaxCharges,
}

--- Table index is the player index
---@type table<integer, ItemState>
Item.state = {}

---
--- STATE MANAGEMENT
------------------------

---@param player EntityPlayer
function Item:getState(player)
    local id = player:GetPlayerIndex()

    -- TODO: Maybe move this into a MC_POST_PLAYER_INIT
    if Item.state[id] == nil then
        Item.state[id] = {
            clock = Clock(Item.const.CLOCK_CHARGE_TICKS),
            active = false,
            beast = false,
            hearts = 0,
            shoot = false,
            weapon = WeaponType.WEAPON_TEARS,
            buzzaxe = nil,
        }
    end

    return Item.state[id]
end

---@param player EntityPlayer
function Item:shouldReleaseTheBeast(player)
    local hearts = player:GetHearts() + player:GetRottenHearts()
    return hearts <= Item.const.RTB_THRESHOLD
end

---@param player EntityPlayer
---@return ActiveSlot?
function Item:getSlot(player)
    for _, slot in pairs(ActiveSlot) do
        if player:GetActiveItem(slot) == Item.ID then return slot end
    end
end

---@param player EntityPlayer
function Item:isHoldingBuzzaxe(player)
    return Item:getSlot(player) ~= -1
end

---@param player EntityPlayer
function Item:isRampaging(player)
    return player:GetEffects():HasCollectibleEffect(Item.ID)
end

---
--- WEAPON MANIPULATION
------------------------

---@param player EntityPlayer
---@param state? ItemState
function Item:destroyWeapon(player, state)
    local weapon = player:GetWeapon(1)

    if weapon then
        local state = state or Item:getState(player)
        state.weapon = weapon:GetWeaponType()
        Isaac.DestroyWeapon(weapon)
    end
end

---@param player EntityPlayer
---@param state? ItemState
function Item:restoreWeapon(player, state)
    local state = state or Item:getState(player)
    local weapon = Isaac.CreateWeapon(state.weapon, player)

    player:SetWeapon(weapon, 1)
end

function Item:RemoveWeaponOnPlayerUpdate(player)
    if not Item:isRampaging(player) then return end
    Item:destroyWeapon(player)
end

---
--- ITEM ACTIVATION
------------------------

---@param item      CollectibleType
---@param rng       RNG
---@param player    EntityPlayer
---@param flags     integer
---@param slot      ActiveSlot
---@param custom    integer
function Item:ActivateRampage(item, rng, player, flags, slot, custom)
    if (flags & UseFlag.USE_CARBATTERY) == UseFlag.USE_CARBATTERY then return end
    print "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    print "[Buzzaxe#onUse] start"

    local state = Item:getState(player)
    Item:destroyWeapon(player, state)

    state.hearts = player:GetHearts()
    state.beast = state.hearts <= Item.const.RTB_THRESHOLD
    state.active = true
    state.buzzaxe = Melee.Create { Spawner = player, Variant = Item.EFFECT_VARIANT }

    if state.beast and player:CanPickRedHearts() then player:AddHearts(player:GetMaxHearts()) end

    return {
        ShowAnim = true,
        Remove = false,
        Discharge = true,
    }
end

--- After a rampage, maybe charge the item if it was beast mode.
--- Then cleanup state.
---@param player EntityPlayer
function Item:CleanupState(player)
    if Item:isRampaging(player) then return end

    local state = Item:getState(player)
    if not state.active then return end
    print "[Buzzaxe#postRampage] start"

    local slot = Item:getSlot(player)
    if slot ~= nil and state.beast then player:FullCharge(slot, true) end

    state.active = false
    state.beast = false
    state.shoot = false
    state.clock:reset(Item.const.CLOCK_CHARGE_TICKS)
    state.buzzaxe = state.buzzaxe:Remove()

    Item:restoreWeapon(player, state)
    print "[Buzzaxe#postRampage] done"
end

---
--- PASSIVE UPDATING
------------------------

function Item:chargeClock()
    local game = Game()
    for i = 0, game:GetNumPlayers() do
        local player = game:GetPlayer(i)
        if player:HasCollectible(Item.ID) and not Item:isRampaging(player) then
            ---@type ActiveSlot
            ---@diagnostic disable-next-line: assign-type-mismatch Presence of the item is checked above, slot cannot be nil
            local slot = Item:getSlot(player)
            local charge = player:GetActiveCharge(slot)
            local clock = Item:getState(player).clock
            if charge < Item.const.MAX_CHARGES and clock:tick() ~= 0 then
                player:AddActiveCharge(1, slot, charge >= Item.const.MAX_CHARGES - 4, false, true)
            end
        end
    end
end

---
--- CACHE MANIPULATION
------------------------

--- Apply speed multiplier during rampage
---@param player EntityPlayer
function Item:onEvalCacheSpeed(player)
    if not Item:isRampaging(player) then return end

    local speed = player.MoveSpeed * Item.const.MULT_SPEED
    player.MoveSpeed = math.min(speed, Item.const.MAX_SPEED)
end

---
--- INIT
------------------------

---@param mod ModReference
function Item.init(mod)
    -- RAMPAGE
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, Item.ActivateRampage, Item.ID)
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Item.CleanupState, PlayerVariant.PLAYER)

    -- PASSIVE UPDATING
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, Item.chargeClock)

    -- CACHE MANIPULATION
    mod:AddPriorityCallback(
        ModCallbacks.MC_EVALUATE_CACHE,
        CallbackPriority.LATE,
        Item.onEvalCacheSpeed,
        CacheFlag.CACHE_SPEED
    )
end

return Item
