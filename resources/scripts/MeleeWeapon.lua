-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.
local inspect = require "resources.scripts.lib.inspect"

local mod = RegisterMod("!!Melee Weapon API", 1) ---@type ModReference

local ENTITY_TYPE = EntityType.ENTITY_EFFECT

---@class MeleeWeaponFactory
local Melee = {
    ---@enum MeleeCallback
    Callbacks = {
        MC_POST_WEAPON_INIT = "WREX.MWA.MC_POST_WEAPON_INIT",
        MC_POST_WEAPON_UPDATE = "WREX.MWA.MC_POST_WEAPON_UPDATE",
        MC_POST_WEAPON_RENDER = "WREX.MWA.MC_POST_WEAPON_RENDER",
    },
}

---@class MeleeWeapon
local Meta = {}

---TODO: Garbage collection on run end
---@class WeaponRegistry
local Registry = {}

---@param entry MeleeWeapon
function Registry:Has(entry)
    if getmetatable(entry) == Meta then return self[GetPtrHash(entry.Effect)] ~= nil end
end

---@param weapon MeleeWeapon
function Registry:Add(weapon)
    local hash = GetPtrHash(weapon.Effect)

    self[hash] = {
        weapon = weapon,
        callbacks = {},
    }

    self:AddCallbacks(weapon, {
        [ModCallbacks.MC_POST_EFFECT_UPDATE] = {
            function(_, effect)
                if GetPtrHash(effect) == hash then Isaac.RunCallback(Melee.Callbacks.MC_POST_WEAPON_UPDATE, weapon) end
            end,
            weapon.Effect.Variant,
        },
        [ModCallbacks.MC_POST_EFFECT_RENDER] = {
            function(_, effect, offset)
                if GetPtrHash(effect) == hash then
                    Isaac.RunCallback(Melee.Callbacks.MC_POST_WEAPON_RENDER, weapon, offset)
                end
            end,
            weapon.Effect.Variant,
        },
    })
end

---@param weapon    MeleeWeapon
---@param cbt       RegistryCallbackTable
function Registry:AddCallbacks(weapon, cbt)
    local callbacks = self[GetPtrHash(weapon.Effect)].callbacks

    for key, cb in pairs(cbt) do
        callbacks[#callbacks + 1] = cb
        mod:AddCallback(key, cb[1], cb[2])
    end
end

function Registry:Remove(weapon)
    local entry = self[GetPtrHash(weapon.Effect)]
    if not entry then return end

    for key, cb in pairs(entry.callbacks) do
        mod:RemoveCallback(key, cb[1])
    end
end

function Meta:Remove()
    self.Sprite:Stop(true)
    self.Effect:Remove()

    Registry:Remove(self)
    return nil
end

---@param angle Vector|number
function Meta:Rotate(angle)
    local r = type(angle) == "number" and angle or angle:GetAngleDegrees()
    self.Effect.Rotation = self.RotationOffset + r
    self.Sprite.Rotation = self.RotationOffset + r
end

--- TODO: Create option validation
function Melee.ValidateOptions() end

---@param o MeleeWeaponCreateOptions
function Melee.InitOptions(o)
    o.subtype = o.subtype or 0
    o.posvel = o.posvel or {}
    o.posvel.Position = o.posvel.Position or o.spawner:GetPosVel().Position
    o.posvel.Velocity = o.posvel.Velocity or Vector.Zero
    o.follow = o.follow == nil or o.follow
    o.aim = o.aim == nil and o.spawner:ToPlayer() or o.aim or false
    return o
end

---@param o MeleeWeaponCreateOptions
function Melee.Create(o)
    o = Melee.InitOptions(o)

    local weapon = {
        RotationOffset = 0,
    }

    local entity = Isaac.Spawn(ENTITY_TYPE, o.variant, o.subtype, o.posvel.Position, o.posvel.Velocity, o.spawner)

    weapon.Effect = entity:ToEffect()
    assert(weapon.Effect, "Couldn't convert Entity #" .. inspect.EntityId(entity) .. " into EntityEffect")
    weapon.Sprite = weapon.Effect:GetSprite()

    if o.follow then weapon.Effect:FollowParent(o.spawner) end

    weapon = setmetatable(weapon, {
        __index = Meta,
        __eq = Melee.Equal,
    })

    Registry:Add(weapon)

    if o.aim then
        Registry:AddCallbacks(weapon, {
            [ModCallbacks.MC_POST_PLAYER_UPDATE] = {
                ---@param player EntityPlayer
                function(_, player)
                    if player.Index ~= o.aim.Index then return end

                    local aim = player:GetShootingJoystick()
                    local walk = player:GetMovementDirection()
                    if aim.X ~= 0 or aim.Y ~= 0 then
                        weapon:Rotate(aim)
                    elseif walk ~= Direction.NO_DIRECTION then
                        weapon:Rotate(player:GetSmoothBodyRotation())
                    else
                        weapon:Rotate(0)
                    end
                end,
                PlayerVariant.PLAYER,
            },
        })
    end

    Isaac.RunCallback(Melee.Callbacks.MC_POST_WEAPON_INIT, weapon)
    return weapon
end

function Melee.Equal(left, right)
    return getmetatable(left) == Meta and getmetatable(right) == Meta and GetPtrHash(left) == GetPtrHash(right)
end

return Melee
