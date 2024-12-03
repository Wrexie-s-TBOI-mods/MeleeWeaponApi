-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local CB = include "lib.MeleeWeaponApi.Callbacks"
local Registry = include "lib.MeleeWeaponApi.RegistryManager"
local Util = include "lib.MeleeWeaponApi.Util"

---@class MeleeWeaponCallbackManager
local CallbackManager = mod.__CallbackManager or {}

---@param table table<RegistryCallback>
---@return table<RegistryCallback>
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

---@param weapon EntityMelee
function CallbackManager.RegisterDefaults(weapon)
    local state = Registry.GetState(weapon) ---@cast state -nil
    local props = Registry.GetProps(weapon) ---@cast props -nil

    local function thisWeapon(effect)
        return GetPtrHash(effect) == GetPtrHash(weapon)
    end

    local defaults = {
        [ModCallbacks.MC_POST_PLAYER_UPDATE] = Callbacks {
            { ---RotateWithAim
                ---@param _ ModReference
                ---@param player EntityPlayer
                function(_, player)
                    if not state.AimRotationSource or GetPtrHash(state.AimRotationSource) ~= GetPtrHash(player) then
                        return
                    end

                    local aiming, direction = Util.IsAiming(player)
                    if not aiming then return end

                    local angle = direction:GetAngleDegrees()
                    weapon.Rotation = angle + props.AimRotationOffset
                    weapon:GetSprite().Rotation = angle + props.AimRotationOffset
                end,
            },
            -- { ---RotateWithMovement

            -- },
        },
        [ModCallbacks.MC_POST_EFFECT_UPDATE] = Callbacks {
            { ---Trigger MC_POST_WEAPON_UPDATE
                function(_, effect)
                    if thisWeapon(effect) then Isaac.RunCallback(CB.MC_POST_WEAPON_UPDATE, weapon) end
                end,
                weapon.Variant,
            },
        },
        [ModCallbacks.MC_POST_EFFECT_RENDER] = Callbacks {
            { ---Trigger MC_POST_WEAPON_RENDER
                function(_, effect, offset)
                    if thisWeapon(effect) then Isaac.RunCallback(CB.MC_POST_WEAPON_RENDER, weapon, offset) end
                end,
                weapon.Variant,
            },
        },
    }

    Registry.AddCallbacks(weapon, defaults)
end

mod.__CallbackManager = CallbackManager
return mod.__CallbackManager
