-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local EntityMelee = mod.EntityMelee
local Util = mod.Api.Util

---@param animation string Animation to play for the thrown weapon
function EntityMelee:Throw(animation)
    local player = Util.MustBePlayer(self.SpawnerEntity)
    local knife = player:FireKnife(player)
    local kSprite = knife:GetSprite()
    local sSprite = self:GetSprite()

    kSprite:Load(sSprite:GetFilename(), true)
    kSprite:Play(animation, true)

    knife:Shoot(self.ChargePercentage, player.TearRange)
end
