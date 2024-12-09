-- BL2 Krieg - TBOI: Repentance character mod (c) by Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference

local Util = MeleeWeaponApi.Util
local IterableList = Util.IterableList

---@class Buzzaxe
local Buzzaxe = mod.__Buzzaxe or {}

---@param player EntityPlayer
function Buzzaxe:CreateBuzzaxe(player)
    local state = self.state[player]

    local axe = MeleeWeaponApi:Create { Spawner = player, Variant = self.Constants.BUZZAXE_ITEM_EFFECT_VARIANT }

    axe.DepthOffset = player.DepthOffset + 1

    axe.Capsules = { "tip" }
    axe.CustomData.Clock = Util.Clock(30)
    axe.CustomData.Animations = {
        Swing = IterableList { "Swing", "Swing2" },
        SwingDown = IterableList { "SwingDown", "SwingDown2" },
    }

    function axe:OnSwingHit(target)
        if not target:IsVulnerableEnemy() or not target:IsActiveEnemy() then return end

        local damage = player.Damage * Util.When(state.beast, Buzzaxe.Constants.MULT_DAMAGE)

        target:TakeDamage(damage, 0, EntityRef(player), 0)
        target:BloodExplode()
        target:MakeBloodPoof(target.Position, nil, 0.5)
    end

    function axe:OnSwingStart()
        if self:IsSwinging() then return false end
        SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN)
        return true
    end

    function axe:OnSwingEnd()
        self:StartCharging()
    end

    function axe:OnChargeUpdate()
        self.ChargePercentage = self.ChargePercentage + (100 / 30) * 2
    end

    function axe:OnChargeFull()
        self:StopCharging()
    end

    function axe:OnChargeRelease()
        self.ChargePercentage = 0
        local anim = self.CustomData.Animations.Swing
        self:Swing(anim:Next())
    end

    state.buzzaxe = axe

    return axe, state
end

mod.__Buzzaxe = Buzzaxe
return Buzzaxe
