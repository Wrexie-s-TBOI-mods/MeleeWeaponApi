-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Callbacks = mod.__Callbacks or {}

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
---| McPreWeaponSwing
---| McWeaponSwingHit
---| McPostWeaponSwing
---| McPreWeaponCharge
---| McPostWeaponChargeUpdate
---| McWeaponChargeFull

---@alias McPostWeaponInit McWeaponSimpleCallback
Callbacks.MC_POST_WEAPON_INIT = prefix "MC_POST_WEAPON_INIT"

---@alias McPostWeaponUpdate McWeaponSimpleCallback
Callbacks.MC_POST_WEAPON_UPDATE = prefix "MC_POST_WEAPON_UPDATE"

---@alias McPostWeaponRender fun(mod: ModReference, weapon: EntityMelee, direction: Vector)
Callbacks.MC_POST_WEAPON_RENDER = prefix "MC_POST_WEAPON_RENDER"

---@alias McPreWeaponSwing fun(mod: ModReference, weapon: EntityMelee, direction: Vector): boolean?
Callbacks.MC_PRE_WEAPON_SWING = prefix "MC_PRE_WEAPON_SWING"

---@alias McWeaponSwingHit fun(mod: ModReference, weapon: EntityMelee, target: Entity, direction: Vector)
Callbacks.MC_WEAPON_SWING_HIT = prefix "MC_WEAPON_SWING_HIT"

---@alias McPostWeaponSwing fun(mod: ModReference, weapon: EntityMelee, direction: Vector)
Callbacks.MC_POST_WEAPON_SWING = prefix "MC_POST_WEAPON_SWING"

---@alias McPreWeaponCharge fun(mod: ModReference, weapon: EntityMelee): boolean?
Callbacks.MC_PRE_WEAPON_CHARGE = prefix "MC_PRE_WEAPON_CHARGE"

---@alias McPostWeaponChargeUpdate McWeaponSimpleCallback
Callbacks.MC_POST_WEAPON_CHARGE_UPDATE = prefix "MC_POST_WEAPON_CHARGE_UPDATE"

---@alias McWeaponChargeFull McWeaponSimpleCallback
Callbacks.MC_WEAPON_CHARGE_FULL = prefix "MC_WEAPON_CHARGE_FULL"

mod.__Callbacks = Callbacks
return mod.__Callbacks
