-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

---@class KriegModReference
local mod = require "src.mod"
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe" ---@class Buzzaxe

local Util = include "lib.MeleeWeaponApi.Util.init"

---@type metatable
local BuzzaxeState = mod.__BuzzaxeState or {}
mod.__BuzzaxeState = BuzzaxeState

---@param player EntityPlayer
function BuzzaxeState:__index(player)
    return rawget(self, player:GetPlayerIndex())
end

---@param player EntityPlayer
---@param state  BuzzaxeState
function BuzzaxeState:__newindex(player, state)
    state.clock = Util.Clock()
    rawset(self, player:GetPlayerIndex(), state)
end

BuzzaxeState.__metatable = false

---@class BuzzaxeState
local INITIAL_STATE = {

    -- Frame counter for various time-based actions
    clock = nil, ---@type Clock

    -- Has the weapon been activated recently ?
    active = false,

    -- Is the current rampage in Beast mode ?
    beast = false,

    -- Red heart units at the time of activation
    hearts = 0,

    -- During rampage, is the player holding shoot after a swing ?
    shoot = false,

    -- Player's weapon type when not rampaging
    weapon = WeaponType.WEAPON_TEARS,

    -- Ramapage weapon
    buzzaxe = nil, ---@type EntityMelee
}

--- Table index is the player index
---@type BuzzaxeState[]
Buzzaxe.state = Buzzaxe.state or setmetatable({}, BuzzaxeState)

---@param player EntityPlayer
function Buzzaxe:InitState(player)
    print("init player " .. player:GetPlayerIndex())
    self.state[player] = Util.Clone(INITIAL_STATE)
end

---@param player EntityPlayer
function Buzzaxe:shouldReleaseTheBeast(player)
    local hearts = player:GetHearts() + player:GetRottenHearts()
    return hearts <= self.Constants.RTB_THRESHOLD
end

---@param player EntityPlayer
---@return ActiveSlot?
function Buzzaxe:GetSlot(player)
    for _, slot in pairs(ActiveSlot) do
        if player:GetActiveItem(slot) == self.Constants.BUZZAXE_ITEM_ID then return slot end
    end
end

---@param player EntityPlayer
function Buzzaxe:isHoldingBuzzaxe(player)
    return self:GetSlot(player) ~= -1
end

---@param player EntityPlayer
function Buzzaxe:isRampaging(player)
    return player:GetEffects():HasCollectibleEffect(self.Constants.BUZZAXE_ITEM_ID)
end

--[[Clean up state after a rampage.  
    Additionally, recharge Buzzaxe if it was Beast mode.
    ]]
---@param player EntityPlayer
function Buzzaxe:CleanupState(player)
    local state = self.state[player]

    local slot = self:GetSlot(player)
    if slot ~= nil and state.beast then player:FullCharge(slot, true) end

    state.active = false
    state.beast = false
    state.shoot = false
    state.clock:reset(self.Constants.CLOCK_ACTIVE_CHARGE_TICKS)

    ---@diagnostic disable-next-line: assign-type-mismatch Drop value to force garbage collection
    state.buzzaxe = state.buzzaxe:Remove()

    self:RestoreBaseWeapon(player)
end

return BuzzaxeState
