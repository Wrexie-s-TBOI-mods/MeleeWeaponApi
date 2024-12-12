-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
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

    axe:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_DONT_OVERWRITE)

    local scale = player.SpriteScale
    local offsetX = Vector(-0.5, 0) * scale
    local offsetY = Vector(0, -0.75) * scale
    local offset = offsetX + offsetY
    axe.SpriteOffset = offset
    axe.Capsules = { "AxeHit", "WooshHit" }

    axe.AimRotationOffset = -90
    axe.MovementRotationOffset = -90

    axe.CustomData.Clock = Util.Clock(30)
    axe.CustomData.Animations = {
        CurrentSwing = nil, ---@type IterableList
        Swing = IterableList { "Swing", "Swing2" },
        SwingDown = IterableList { "SwingDown", "SwingDown2" },
    }

    ---@param weapon EntityMelee
    ---@param player EntityPlayer
    ---@param angle  number
    function AdjustRotationAndOffsets(weapon, player, angle)
        local state = weapon:GetState()
        local depth = Util.When(state.PlayerHeadDirection, {
            [Direction.UP] = -1,
            [Direction.LEFT] = -1,
            [Direction.DOWN] = 1,
            [Direction.RIGHT] = 1,
        })

        weapon:Rotate(angle)
        weapon.DepthOffset = player.DepthOffset + depth
    end

    function axe:OnPlayerAimStart(player)
        local state = self:GetState()
        if state.IsSwinging or state.IsCharging then return end

        local rotation
        if player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) then
            rotation = player:GetAimDirection() --[[@as Vector]]
            rotation = rotation:GetAngleDegrees()
        else
            rotation = Util.DirectionToAngleDegrees(state.PlayerHeadDirection)
        end
        AdjustRotationAndOffsets(self, player, rotation + self.AimRotationOffset)

        local sprite = self:GetSprite()
        local anim = self.CustomData.Animations
        local swing = state.PlayerHeadDirection == Direction.DOWN and anim.SwingDown or anim.Swing

        if anim.CurrentSwing ~= swing then
            swing:SetCurrentIndex()
            anim.CurrentSwing = swing
        end
        self:Swing(anim.CurrentSwing:Next())
    end

    function axe:OnPlayerMoveUpdate(player)
        local state = self:GetState()
        if state.IsPlayerAiming or state.IsSwinging then return end

        local rotation = Util.DirectionToAngleDegrees(state.PlayerHeadDirection)
        AdjustRotationAndOffsets(self, player, rotation + self.MovementRotationOffset)
    end

    function axe:OnSwingHit(target)
        if not target:IsVulnerableEnemy() or not target:IsActiveEnemy() then return end

        local damage = player.Damage * Util.When(state.beast, Buzzaxe.Constants.MULT_DAMAGE)

        target:TakeDamage(damage, 0, EntityRef(player), 0)
        target:BloodExplode()
        target:MakeBloodPoof(target.Position, nil, 0.5)
    end

    function axe:OnSwingStart()
        if self:GetState().IsCharging then return true end

        SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN)
    end

    function axe:OnChargeUpdate()
        self.ChargePercentage = self.ChargePercentage + (100 / 30) * 2
    end

    function axe:OnChargeRelease()
        self.ChargePercentage = 0
        self:Swing(self.CustomData.Animations.CurrentSwing:Next())
    end

    state.buzzaxe = axe

    return axe, state
end

mod.__Buzzaxe = Buzzaxe
return Buzzaxe
