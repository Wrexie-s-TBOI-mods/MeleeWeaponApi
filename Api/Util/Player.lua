-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = require "Api.mod"

local Api = mod.__Api or {}
mod.__Api = Api

local Util = Api.Util or {}
Api.Util = Util

function Util.PlayerIsAiming(player)
    local v = Util.MustBePlayer(player):GetAimDirection()

    return (v.X ~= 0 or v.Y ~= 0), v
end

function Util.PlayerIsMoving(player)
    local v = Util.MustBePlayer(player):GetMovementVector()

    return (v.X ~= 0 or v.Y ~= 0), v
end
