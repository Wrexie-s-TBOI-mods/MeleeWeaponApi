-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local EntityMelee = mod.EntityMelee

function EntityMelee:Swing(animation, force)
    if not force and self:OnSwingStart() then return end

    local state = self:GetState(true)
    local sprite = self:GetSprite()

    state.IsSwinging = true
    state.CurrentAnimation = animation

    sprite:Play(animation, true)
end
