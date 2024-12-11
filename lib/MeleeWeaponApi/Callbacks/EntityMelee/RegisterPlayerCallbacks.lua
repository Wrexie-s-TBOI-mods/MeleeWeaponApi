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
local function TriggerOnPlayerMove(weapon, target)
    return function(_mod, player)
        if GetPtrHash(player) ~= GetPtrHash(target) then return end

        local state = weapon:GetState()
        local movement = player:GetMovementVector()
        local input = player:GetMovementInput()

        if movement.X == 0 and movement.Y == 0 then
            if state.IsPlayerMoving then
                state.IsPlayerMoving = false
                weapon:OnPlayerMoveEnd(player, movement, input)
            end
            return
        end

        Util.WhenEval(state.IsPlayerMoving, {
            [false] = function()
                state.IsPlayerMoving = true
                weapon:OnPlayerMoveStart(player, movement, input)
            end,
            [true] = function()
                weapon:OnPlayerMoveUpdate(player, movement, input)
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
