-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local inspect = include "lib.inspect"

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = mod.__Api and mod.__Api.Util or include "lib.MeleeWeaponApi.Util.init"

---@class EntityMelee
local EntityMelee = mod.__EntityMelee or {}
mod.__EntityMelee = EntityMelee

---Swing the weapon
---@param animation     string              Animation to play
---@param direction?    Direction|Vector    Direction of the swing, if different from the weapon's current rotation
---@param force?        boolean             Override previously playing animation — Default: `false`
function EntityMelee:Swing(animation, direction, force)
    dprint "[EntityMelee:Swing()] Init"
    if not force and not self:OnSwingStart() then
        dprint "[EntityMelee:Swing()] Denied"
        return
    end

    ---@type fun(): Vector
    local EvalDirection = Util.When(type(direction), {
        ["nil"] = function()
            return Vector.FromAngle(self:GetSprite().Rotation)
        end,
        ["number"] = function()
            return Vector.FromAngle(direction)
        end,
        ["userdata"] = function()
            assert(Util.InstanceOfIsaacApiClass(direction, Vector), "Given direction is `userdata` but not a Vector.")
            return direction
        end,
    })

    direction = EvalDirection()
    dprint("[EntityMelee:Swing()] Direction: " .. inspect { X = direction.X, Y = direction.Y })
    dprint("[EntityMelee:Swing()] Angle: " .. direction:GetAngleDegrees())

    local state = self:GetState()
    local sprite = self:GetSprite()

    state.IsSwinging = true
    state.CurrentAnimation = animation
    dprint("[EntityMelee:Swing()] Updated state: " .. inspect(state))

    sprite.Rotation = self.AimRotationOffset + direction:GetAngleDegrees()
    sprite:Play(animation, true)
end

--[[Check that the weapon is currently swinging.
    ]]
---@return boolean IsSwinging
function EntityMelee:IsSwinging()
    return self:GetState().IsSwinging
end
