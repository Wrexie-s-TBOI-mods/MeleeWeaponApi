-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = include "lib.MeleeWeaponApi.Util"
local RegistryManager = include "lib.MeleeWeaponApi.RegistryManager"
local Callback = include "lib.MeleeWeaponApi.Callbacks"

---@class EntityMelee
local EntityMelee = mod.__EntityMelee or {}

--[[ Metatable shenanigans ]]

local Super = getmetatable(EntityEffect).__class
if not EntityMelee.__fxindex then
    EntityMelee.__fxindex = Super.__index
    EntityMelee.__fxnewindex = Super.__newindex
end

rawset(Super, "__index", function(self, key)
    local props = RegistryManager.GetProps(self)

    if EntityMelee[key] then return EntityMelee[key] end
    if props[key] then return props[key] end

    return EntityMelee.__fxindex(self, key)
end)

rawset(Super, "__newindex", function(self, key, value)
    local props = RegistryManager.GetProps(self)

    if props[key] then
        props[key] = value
        return
    end

    return EntityMelee.__fxnewindex(self, key, value)
end)

---Call a method from the parent class @{EntityEffect}
---@param name string Method name
---@param ... any
function EntityMelee:__fxcall(name, ...)
    local fn = EntityMelee.__fxindex(self, name)
    return fn(self, ...)
end

--]]

local ANY_ENTITY_PARTITION = EntityPartition.BULLET
    | EntityPartition.EFFECT
    | EntityPartition.ENEMY
    | EntityPartition.FAMILIAR
    | EntityPartition.PICKUP
    | EntityPartition.PLAYER
    | EntityPartition.TEAR

--[[ Properties and overrideable methods ]]
local function INITIAL_PROPS()
    ---@class MeleeWeaponProps
    local props = {
        AimRotationOffset = 0,
        MovementRotationOffset = 0,

        ChargePercentage = 0,
        ChargebarSprite = "gfx/chargebar.anm2",

        --[[Null capsules defined in your sprite's `.anm2`.  
            They're the hitboxes of your weapon, and will be iterated over during a swing to simulate collision.  
            During a swing, `EntityMelee:OnSwingHit()` will be called for each entity found in any of the capsules,
            and the entities will be passed as the first argument (`target`) after `self`.
            ]]
        Capsules = {}, ---@type string[]

        SwingTargets = ANY_ENTITY_PARTITION, ---@type EntityPartition

        --[[This field is to store any arbitrary data of your choice.
            ]]
        CustomData = {}, ---@type any
    }

    ---Here we cast so that we get completion when using `self` in the callback definitions.
    ---@cast props EntityMelee

    --[[Called when rendering the chargebar.
        Defaults to roughly the same position as the game's original chargebar.
        ]]
    function props:GetChargebarPosition()
        local pos = self.SpawnerEntity.Position
        local scale = self.SpawnerEntity.SpriteScale
        local offsetX = Vector(-20, 0) * scale
        local offsetY = Vector(0, 50) * scale
        local offset = offsetX + offsetY

        return Isaac.WorldToScreen(pos - offset)
    end

    --[[Called on every update of an `EntityMelee`, if it is charging.
        ]]
    function props:OnChargeUpdate() end

    --[[Called on every update of an `EntityMelee`, if it is charging and `EntityMelee.ChargePercentage >= 100` 
        ]]
    function props:OnChargeFull() end

    --[[Called before each swing.
        If a falsy value is returned, prevents the swing.  
        By default, checks that it's not already swinging and,
        if spawner entity is a player, checks that they can shoot.
        ]]
    function props:OnSwingStart()
        if self:IsSwinging() then return false end

        local player = self.SpawnerEntity:ToPlayer()

        return player and player:CanShoot()
    end

    --[[Called after each swing.
        ]]
    function props:OnSwingEnd() end

    --[[Called for every entity hit by a swing.  
        Be sure to set your `EntityMelee.Capsules` for this to work properly, else it will not be called !  
        When this returns `nil`, it will not be called again for the same target of the same swing.
        ]]
    --- @param target Entity
    function props:OnSwingHit(target) end

    ---Back to original type to prevent breaking inference
    ---@cast props MeleeWeaponProps
    return props
end
--]]

--[[ Internal state ]]

local function INITIAL_STATE()
    ---@class MeleeWeaponState
    local state = {
        CurrentAnimation = nil, ---@type string?

        IsSwinging = false,
        IsCharging = false,
        IsThrowing = false,

        SwingHitBlacklist = {}, ---@type table<PtrHash, boolean>

        Chargebar = nil, ---@type Sprite

        IsRotating = false,
        RotateFrom = Vector(0, 0),
        RotateTo = Vector(0, 0),
        RotateProgress = 0.0,

        AimRotationSource = nil, ---@type EntityPlayer?
        MovementRotationSource = nil, ---@type EntityPlayer?
    }

    return state
end

--]]

--[[ Class methods ]]

---@return EntityMelee
function EntityMelee.FromEffect(effect)
    RegistryManager.Add(effect, INITIAL_PROPS(), INITIAL_STATE())
    return effect
end

---Destroy effect, sprite and remove EntityMelee from registry
function EntityMelee:Remove()
    self:__fxcall "Remove"
    RegistryManager.Remove(self)
    return nil
end

---Set the weapon's rotation to follow a player's aim direction
---@param player EntityPlayer
function EntityMelee:RotateWithAim(player)
    local state = RegistryManager.GetState(self)
    state.AimRotationSource = Util.MustBePlayer(player)
end

---Set the weapon's rotation to follow a player's movement direction
---@param player EntityPlayer
function EntityMelee:RotateWithMovement(player)
    local state = RegistryManager.GetState(self)
    state.MovementRotationSource = Util.MustBePlayer(player)
end

---Swing the weapon
---@param animation     string              Animation to play
---@param direction?    Direction|Vector    Direction of the swing, if different from the weapon's current rotation
---@param force?        boolean             Override previously playing animation — Default: `false`
function EntityMelee:Swing(animation, direction, force)
    if not force and not self:OnSwingStart() then return end

    ---@type fun(): Vector
    local EvalDirection = Util.When(type(direction), {
        ["nil"] = function()
            return Vector.FromAngle(self:GetSprite().Rotation)
        end,
        ["number"] = function()
            return Vector.FromAngle(direction)
        end,
        ["userdata"] = function()
            assert(Util.InstanceOfIsaacApiClass(direction, Vector), "Given direction is `userdata` but not a Vector.")
            return direction
        end,
    })
    direction = EvalDirection()

    local state = RegistryManager.GetState(self)
    local sprite = self:GetSprite()

    state.IsSwinging = true
    state.CurrentAnimation = animation

    sprite.Rotation = self.AimRotationOffset + direction:GetAngleDegrees()
    sprite:Play(animation, true)
end

---@return boolean IsSwinging
function EntityMelee:IsSwinging()
    local state = RegistryManager.GetState(self)
    return state.IsSwinging
end

function EntityMelee:StartCharging()
    if Isaac.RunCallback(Callback.MC_PRE_WEAPON_CHARGE, self) then return end

    local state = RegistryManager.GetState(self)

    if not state.Chargebar then
        state.Chargebar = Sprite()
        state.Chargebar:Load(self.ChargebarSprite, true)
    end

    state.IsCharging = true
end

function EntityMelee:StopCharging()
    RegistryManager.GetState(self).IsCharging = false
end

---@return boolean IsCharging
function EntityMelee:IsCharging()
    return RegistryManager.GetState(self).IsCharging
end

--]]

mod.__EntityMelee = EntityMelee
return mod.__EntityMelee
