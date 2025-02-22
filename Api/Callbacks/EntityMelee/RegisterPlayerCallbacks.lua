-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Util = mod.Api.Util
local Custom = mod.Api.Callbacks

---@alias PlayerUpdateCallbackFn        fun(mod: ApiModReference, player: EntityPlayer)
---@alias PlayerUpdateCallbackFactory   fun(weapon: EntityMelee, targer: EntityPlayer): PlayerUpdateCallbackFn

---@type PlayerUpdateCallbackFactory
local function TriggerOnPlayerAim(weapon, target)
    return function(_mod, player)
        if GetPtrHash(player) ~= GetPtrHash(target) then return end

        local state = weapon:GetState(true)
        local aiming, aim = Util.PlayerIsAiming(player)

        state.PlayerHeadDirection = player:GetHeadDirection()

        if not aiming then
            if not state.IsPlayerAiming then return end

            state.IsPlayerAiming = false
            weapon:OnPlayerAimEnd(player, aim)
            return
        end

        Util.CallWhen(state.IsPlayerAiming, {
            [false] = function()
                state.IsPlayerAiming = true
                weapon:OnPlayerAimStart(player, aim)
            end,
            [true] = function()
                weapon:OnPlayerAimUpdate(player, aim)
            end,
        })
    end
end

---@type PlayerUpdateCallbackFactory
local function TriggerOnPlayerMove(weapon, target)
    return function(_mod, player)
        if GetPtrHash(player) ~= GetPtrHash(target) then return end

        local state = weapon:GetState(true)
        local moving, movement = Util.PlayerIsMoving(player)

        if not moving then
            if not state.IsPlayerMoving then return end

            weapon:OnPlayerMoveEnd(player, movement)
            state.IsPlayerMoving = false
            return
        end

        Util.CallWhen(state.IsPlayerMoving, {
            [false] = function()
                state.IsPlayerMoving = true
                weapon:OnPlayerMoveStart(player, movement)
            end,
            [true] = function()
                weapon:OnPlayerMoveUpdate(player, movement)
            end,
        })
    end
end

---@param mod       ApiModReference
---@param weapon    EntityMelee
local function RegisterPlayerCallbacks(mod, weapon)
    local player = weapon.SpawnerEntity:ToPlayer()
    if not player then return end

    mod.CallbackManager:RegisterEntries(weapon, {
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
        key = Custom.MC_POST_WEAPON_INIT,
        fn = RegisterPlayerCallbacks,
    },
}
