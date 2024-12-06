-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

---@class MeleeWeaponApi
local Api = mod.__Api or {}
mod.__Api = Api

local Util = Api.Util or {}
Api.Util = Util

---@param entity Entity
function Util.GetEntityId(entity)
    return tostring(entity.Type) .. "." .. tostring(entity.Variant) .. "." .. tostring(entity.SubType)
end

---@param entity Entity
function Util.MustBePlayer(entity)
    local p = assert(entity:ToPlayer(), "Entity " .. Util.GetEntityId(entity) .. " is not a player")
    return p
end

---@param entity Entity
function Util.MustBeEffect(entity)
    local e = assert(entity:ToEffect(), "Entity " .. Util.GetEntityId(entity) .. " is not an effect")
    return e
end
