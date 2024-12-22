-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Util = mod.Api.Util

function Util.GetEntityId(entity)
    return tostring(entity.Type) .. "." .. tostring(entity.Variant) .. "." .. tostring(entity.SubType)
end

function Util.MustBePlayer(entity)
    local p = assert(entity:ToPlayer(), "Entity " .. Util.GetEntityId(entity) .. " is not a player")
    return p
end

function Util.MustBeEffect(entity)
    local e = assert(entity:ToEffect(), "Entity " .. Util.GetEntityId(entity) .. " is not an effect")
    return e
end
