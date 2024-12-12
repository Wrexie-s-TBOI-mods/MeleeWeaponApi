-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod"
local Util = mod.__Api and mod.__Api.Util or include "lib.MeleeWeaponApi.Util.init"
local Callbacks = mod.__Api and mod.__Api.Callbacks or include "lib.MeleeWeaponApi.Callbacks.CallbackId"

---@alias PlayerUpdateCallbackFn fun(mod: MeleeWeaponApiModReference, player: EntityPlayer)

---@param weapon EntityMelee
---@param target EntityPlayer
---@return PlayerUpdateCallbackFn
local function TriggerOnPlayerAim(weapon, target)
    return function(_mod, player)
        if GetPtrHash(player) ~= GetPtrHash(target) then return end

        local state = weapon:GetState(true)
        local aim = player:GetAimDirection()

        state.PlayerHeadDirection = player:GetHeadDirection()

        if aim.X == 0 and aim.Y == 0 then
            if not state.IsPlayerAiming then return end

            state.IsPlayerAiming = false
            weapon:OnPlayerAimEnd(player)
            return
        end

        Util.CallWhen(state.IsPlayerAiming, {
            [false] = function()
                state.IsPlayerAiming = true
                weapon:OnPlayerAimStart(player)
            end,
            [true] = function()
                weapon:OnPlayerAimUpdate(player)
            end,
        })
    end
end

---@param weapon EntityMelee
---@param target EntityPlayer
---@return PlayerUpdateCallbackFn
local function TriggerOnPlayerMove(weapon, target)
    return function(_mod, player)
        if GetPtrHash(player) ~= GetPtrHash(target) then return end

        local state = weapon:GetState(true)
        local movement = player:GetMovementVector()

        if movement.X == 0 and movement.Y == 0 then
            if not state.IsPlayerMoving then return end

            weapon:OnPlayerMoveEnd(player)
            state.IsPlayerMoving = false
            return
        end

        Util.CallWhen(state.IsPlayerMoving, {
            [false] = function()
                state.IsPlayerMoving = true
                weapon:OnPlayerMoveStart(player)
            end,
            [true] = function()
                weapon:OnPlayerMoveUpdate(player)
            end,
        })
    end
end

---@param mod       MeleeWeaponApiModReference
---@param weapon    EntityMelee
local function RegisterPlayerCallbacks(mod, weapon)
    local player = weapon.SpawnerEntity:ToPlayer()
    if not player then return end

    mod.__CallbackManager:RegisterEntries(weapon, {
        force = true,
        {
            key = ModCallbacks.MC_POST_PLAYER_UPDATE,
            fn = TriggerOnPlayerAim(weapon, player),
            param = PlayerVariant.PLAYER,
        },
        {
            key = ModCallbacks.MC_POST_PLAYER_UPDATE,
            fn = TriggerOnPlayerMove(weapon, player),
            param = PlayerVariant.PLAYER,
        },
    })
end

---@type ModCallbackModule
return {
    force = true,
    {
        key = Callbacks.MC_POST_WEAPON_INIT,
        fn = RegisterPlayerCallbacks,
    },
}
