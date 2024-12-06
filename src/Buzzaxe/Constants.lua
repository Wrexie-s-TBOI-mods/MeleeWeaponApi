-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe" ---@class Buzzaxe

---@class BuzzaxeDynamicConstant
local DynamicConstants = {}

---@class BuzzaxeHardcodedConstant
local Constants = Buzzaxe.Constants
    or setmetatable({}, {
        __index = function(self, key)
            local value = rawget(self, key)

            if value == nil and DynamicConstants[key] then
                value = DynamicConstants[key]()
                rawset(self, key, value)
            end

            return value
        end,
    })

Constants.BUZZAXE_ITEM_NAME = "Buzzaxe"
Constants.BUZZAXE_ITEM_EFFECT_NAME = "Buzzaxe Effect"

--- Max number of hearts to trigger Relase The Beast.
--- 1 unit represents half a heart.
Constants.RTB_THRESHOLD = 2

Constants.MULT_SPEED = 1.4

Constants.MULT_DAMAGE = {
    --- In Beast mode
    [true] = 5,

    --- In non Beast mode
    [false] = 4,
}

Constants.MAX_SPEED = 2

Constants.CLOCK_ACTIVE_CHARGE_TICKS = 60

Constants.CLOCK_ATTACK_TICKS = 60

Constants.CHARGEBAR_FLASH_THRESHOLD = 4

---@class BuzzaxeConstant : BuzzaxeHardcodedConstant
---@field BUZZAXE_ITEM_ID               integer
---@field BUZZAXE_ITEM_EFFECT_VARIANT   integer
---@field BUZZAXE_MAX_CHARGES           integer
---@cast Constants BuzzaxeConstant

function DynamicConstants:BUZZAXE_ITEM_ID()
    return Isaac.GetItemIdByName(Constants.BUZZAXE_ITEM_NAME)
end

function DynamicConstants:BUZZAXE_ITEM_EFFECT_VARIANT()
    return Isaac.GetEntityVariantByName(Constants.BUZZAXE_ITEM_EFFECT_NAME)
end

function DynamicConstants:BUZZAXE_MAX_CHARGES()
    local conf = Isaac.GetItemConfig()
    local item = conf:GetCollectible(Constants.BUZZAXE_ITEM_ID)

    return item.MaxCharges
end

Buzzaxe.Constants = Constants --[[@as BuzzaxeConstant]]
return Constants
