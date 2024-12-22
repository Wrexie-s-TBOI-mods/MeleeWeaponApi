-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local EntityMelee = mod.EntityMelee

function EntityMelee:Rotate(angle)
    if not type(angle) == "number" then ---@cast angle Vector
        angle = angle:GetAngleDegrees()
    end ---@cast angle number

    self.Rotation = angle
    self.SpriteRotation = angle
end
