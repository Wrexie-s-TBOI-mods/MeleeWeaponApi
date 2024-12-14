-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = require "Api.mod"
local Api = mod.__Api or include "Api.Api" ---@class MeleeWeaponApi

local Callbacks = Api.Callbacks or {}
Api.Callbacks = Callbacks

local PREFIX = "WREX.MeleeWeaponApi."

---@return string
local function prefix(name)
    return PREFIX .. name
end

---@alias McWeaponSimpleCallback fun(mod: ModReference, weapon: EntityMelee)

---@alias McWeaponCallback
---| McPostWeaponInit
---| McPostWeaponUpdate
---| McPostWeaponRender

---@alias McPostWeaponInit McWeaponSimpleCallback
Callbacks.MC_POST_WEAPON_INIT = prefix "MC_POST_WEAPON_INIT"

---@alias McPostWeaponUpdate McWeaponSimpleCallback
Callbacks.MC_POST_WEAPON_UPDATE = prefix "MC_POST_WEAPON_UPDATE"

---@alias McPostWeaponRender fun(mod: ModReference, weapon: EntityMelee, direction: Vector)
Callbacks.MC_POST_WEAPON_RENDER = prefix "MC_POST_WEAPON_RENDER"

return Callbacks
