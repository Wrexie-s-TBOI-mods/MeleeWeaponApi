-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local inspect = include "lib.inspect"

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = include "lib.MeleeWeaponApi.Util"
local RegistryManager = include "lib.MeleeWeaponApi.RegistryManager"
local MeleeCallback = include "lib.MeleeWeaponApi.Callbacks"

---@class MeleeWeaponCallbackManager
local CallbackManager = mod.__CallbackManager or {}

---@param table table<integer, RegistryCallback>
---@return table<integer, RegistryCallback>
local function Callbacks(table)
    return setmetatable(table, {
        __pairs = function(self)
            local done = false
            local i = 0

            local function next(tbl)
                if done then
                    done = false
                    i = 0
                end

                i = i + 1
                local entry = tbl[i]

                if entry then
                    return entry[1], entry[2]
                else
                    done = true
                end
            end

            return next, self, 0
        end,
    })
end

---@param target EntityMelee
function CallbackManager.RegisterDefaults(target)
    local hash = GetPtrHash(target)
    local state = assert(RegistryManager.GetState(target))

    local function ThisWeapon(effect)
        return GetPtrHash(effect) == hash
    end

    local defaults = {
        --[[ ModCallback ]]
        [ModCallbacks.MC_POST_EFFECT_UPDATE] = Callbacks {
            { ---Trigger MC_POST_WEAPON_UPDATE
                function(_, effect)
                    if ThisWeapon(effect) then Isaac.RunCallback(MeleeCallback.MC_POST_WEAPON_UPDATE, target) end
                end,
                target.Variant,
            },
        },
        [ModCallbacks.MC_POST_EFFECT_RENDER] = Callbacks {
            { ---Trigger MC_POST_WEAPON_RENDER
                function(_, effect, offset)
                    if ThisWeapon(effect) then
                        Isaac.RunCallback(MeleeCallback.MC_POST_WEAPON_RENDER, effect, offset)
                    end
                end,
                target.Variant,
            },
        },
        --]]

        --[[ MeleeCallback ]]
        [MeleeCallback.MC_POST_WEAPON_UPDATE] = Callbacks {
            { ---Trigger MC_POST_WEAPON_SWING
                ---@param _ MeleeWeaponApiModReference
                ---@param weapon EntityMelee
                function(_, weapon)
                    if not ThisWeapon(weapon) or not weapon:IsSwinging() then return end

                    local sprite = weapon:GetSprite()
                    if not sprite:IsFinished(state.CurrentAnimation) then return end

                    state.IsSwinging = false
                    Isaac.RunCallback(MeleeCallback.MC_POST_WEAPON_SWING, weapon)
                end,
            },
            { ---Trigger MC_POST_WEAPON_CHARGE_UPDATE or MC_WEAPON_CHARGE_FULL
                ---@param _ MeleeWeaponApiModReference
                ---@param weapon EntityMelee
                function(_, weapon)
                    if not ThisWeapon(weapon) or not weapon:IsCharging() then return end
                    if weapon.ChargePercentage >= 100 then
                        Isaac.RunCallback(MeleeCallback.MC_WEAPON_CHARGE_FULL, weapon)
                    end
                    Isaac.RunCallback(MeleeCallback.MC_POST_WEAPON_CHARGE_UPDATE, weapon)
                end,
            },
        },
        [MeleeCallback.MC_POST_WEAPON_RENDER] = Callbacks {
            { ---Update/render chargebar if active
                function(_, weapon)
                    if not ThisWeapon(weapon) or not state.Chargebar then return end

                    local bar = state.Chargebar
                    local percent = math.max(0, weapon.ChargePercentage)

                    if state.IsCharging then
                        if percent < 99 then bar:SetFrame("Charging", math.floor(percent)) end
                    elseif not bar:IsPlaying "Disappear" and not bar:IsFinished "Disappear" then
                        bar:Play("Disappear", true)
                    end

                    bar:Render(weapon:GetChargebarPosition())
                    bar:Update()
                end,
            },
        },
        [MeleeCallback.MC_WEAPON_CHARGE_FULL] = Callbacks {
            { --- Play chargbar full animation
                function(_, weapon)
                    if not ThisWeapon(weapon) or not state.Chargebar or not state.IsCharging then return end

                    local bar = state.Chargebar
                    if bar:IsFinished "StartCharged" or bar:IsFinished "Charged" then
                        bar:Play("Charged", true)
                        print "+Play charged"
                    elseif not bar:IsPlaying "StartCharged" and not bar:IsPlaying "Charged" then
                        print "+Play start"
                        bar:Play("StartCharged", true)
                    end
                end,
            },
        },
        --]]
    }

    RegistryManager.AddCallbacks(target, defaults)
end

mod.__CallbackManager = CallbackManager
return mod.__CallbackManager
