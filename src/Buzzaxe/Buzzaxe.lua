-- BL2 Krieg - TBOI: Repentance character mod (c) by Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local inspect = require "lib.inspect"
local mod = require "src.mod" ---@class KriegModReference

local Melee = include "lib.MeleeWeaponApi.init"
local Util = Melee.Util
local IterableList = Util.IterableList

---@class Buzzaxe
local Buzzaxe = mod.__Buzzaxe or {}

---@param player EntityPlayer
function Buzzaxe:CreateBuzzaxe(player)
    dprint "[Buzzaxe:CreateBuzzaxe] Initated"

    local state = self.state[player]
    dprint("[Buzzaxe:CreateBuzzaxe] Buzzaxe player state: " .. inspect(state))

    local axe = Melee:Create { Spawner = player, Variant = self.Constants.BUZZAXE_ITEM_EFFECT_VARIANT }

    axe.DepthOffset = player.DepthOffset + 1

    axe.Capsules = { "tip" }
    axe.CustomData.Clock = Util.Clock(30)
    axe.CustomData.Animations = {
        Swing = IterableList { "Swing", "Swing2" },
        SwingDown = IterableList { "SwingDown", "SwingDown2" },
    }

    function axe:OnSwingEnd()
        dprint "[Buzzaxe#OnSwingEnd] Start charging"
        self:StartCharging()
    end

    function axe:OnChargeUpdate()
        local clock = self.CustomData.Clock
        if clock:tick() ~= 0 then
            self.ChargePercentage = self.ChargePercentage + 25
            dprint("[Buzzaxe#OnChargeUpdate] Charge = " .. self.ChargePercentage)
        end
    end

    function axe:OnChargeFull()
        dprint "[Buzzaxe#OnChargeFull] Stop charging"
        self:StopCharging()
    end

    function axe:OnChargeEnd()
        local anim = self.CustomData.Animations.Swing

        dprint "[Buzzaxe#OnChargeFull] Fart"
        SFXManager():Play(SoundEffect.SOUND_FART)

        dprint "[Buzzaxe#OnChargeFull] Swing again"
        self:Swing(anim:Next())
    end

    state.buzzaxe = axe

    return axe, state
end

mod.__Buzzaxe = Buzzaxe
return Buzzaxe
