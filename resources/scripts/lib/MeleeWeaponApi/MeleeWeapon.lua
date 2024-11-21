-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local Registry = include "resources.scripts.lib.MeleeWeaponApi.Registry"

---@class MeleeWeapon
local Meta = {}

function Meta:Remove()
    self.Sprite:Stop(true)
    self.Effect:Remove()

    Registry.Remove(self)
    return nil
end

---@param angle Vector|number
function Meta:Rotate(angle)
    local r = type(angle) == "number" and angle or angle:GetAngleDegrees()
    self.Effect.Rotation = self.RotationOffset + r
    self.Sprite.Rotation = self.RotationOffset + r
end

return Meta
