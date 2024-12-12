-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = mod.__Api and mod.__Api.Util or include "lib.MeleeWeaponApi.Util.init"

---@class EntityMelee
local EntityMelee = mod.__EntityMelee or {}
mod.__EntityMelee = EntityMelee

---Swing the weapon
---@param animation     string              Animation to play
---@param force?        boolean             Override previously playing animation — Default: `false`
function EntityMelee:Swing(animation, force)
    if not force and self:OnSwingStart() then return end

    local state = self:GetState(true)
    local sprite = self:GetSprite()

    state.IsSwinging = true
    state.CurrentAnimation = animation

    sprite:Play(animation, true)
end
