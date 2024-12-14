-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.
---@diagnostic disable: duplicate-set-field

local mod = require "Api.mod" ---@class MeleeWeaponApiModReference

local Util = mod.__Api and mod.__Api.Util or include "Api.Util.init"

---@class EntityMelee
local EntityMelee = mod.__EntityMelee or {}
mod.__EntityMelee = EntityMelee

---@class EntityMeleeProps
local INITIAL_PROPS = {
    AimRotationOffset = 0,
    MovementRotationOffset = 0,
    ChargePercentage = 0,
    ChargebarSprite = "gfx/chargebar.anm2",
    Capsules = {},
    SwingTargets = nil,
    CustomData = {},
}

---@cast INITIAL_PROPS EntityMelee

function INITIAL_PROPS:GetChargebarPosition()
    local pos = self.SpawnerEntity.Position
    local scale = self.SpawnerEntity.SpriteScale
    local offsetX = Vector(-20, 0) * scale
    local offsetY = Vector(0, 50) * scale
    local offset = offsetX + offsetY

    return Isaac.WorldToScreen(pos - offset)
end

function INITIAL_PROPS:OnChargeStart() end

function INITIAL_PROPS:OnChargeUpdate() end

function INITIAL_PROPS:OnChargeFull() end

function INITIAL_PROPS:OnChargeEnd() end

function INITIAL_PROPS:OnChargeRelease() end

function INITIAL_PROPS:OnSwingStart()
    if self:GetState().IsSwinging then return true end

    local player = self.SpawnerEntity:ToPlayer()
    if not player or not player:CanShoot() then return true end
end

function INITIAL_PROPS:OnSwingEnd() end

function INITIAL_PROPS:OnSwingHit() end

function INITIAL_PROPS:OnPlayerMoveStart() end

function INITIAL_PROPS:OnPlayerMoveUpdate() end

function INITIAL_PROPS:OnPlayerMoveEnd() end

function INITIAL_PROPS:OnPlayerAimStart() end

function INITIAL_PROPS:OnPlayerAimUpdate() end

function INITIAL_PROPS:OnPlayerAimEnd() end

---Back to original type to prevent breaking inference
---@cast INITIAL_PROPS EntityMeleeProps

---@private
function EntityMelee.GetInitialProps()
    return Util.Clone(INITIAL_PROPS)
end
