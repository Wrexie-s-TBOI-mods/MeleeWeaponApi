-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local inspect = require "lib.inspect"

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

local Util = include "lib.MeleeWeaponApi.Util"
local CallbackManager = include "lib.MeleeWeaponApi.CallbackManager"
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
    if props then
        if EntityMelee[key] then return EntityMelee[key] end
        if props[key] then return props[key] end
    end

    return EntityMelee.__fxindex(self, key)
end)

rawset(Super, "__newindex", function(self, key, value)
    local props = RegistryManager.GetProps(self)

    if props and props[key] then
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

--[[ Defaults ]]

---@param weapon EntityMelee
local function INITIAL_PROPS(weapon)
    ---@class MeleeWeaponProps
    local props = {
        AimRotationOffset = 0,
        MovementRotationOffset = 0,

        ChargePercentage = 0,
        ChargebarSprite = "gfx/chargebar.anm2",
        GetChargebarPosition = function()
            return weapon.SpawnerEntity:GetPosVel().Position
        end,
    }

    return props
end

local function INITIAL_STATE(_weapon)
    ---@class MeleeWeaponState
    local state = {
        CurrentAnimation = nil, ---@type string?

        IsSwinging = false,
        IsCharging = false,
        IsThrowing = false,

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
    RegistryManager.Add(effect, INITIAL_PROPS(effect), INITIAL_STATE(effect))
    CallbackManager.RegisterDefaults(effect)
    return effect
end

---Destroy effect, sprite and remove EntityMelee from registry
function EntityMelee:Remove()
    local props = assert(RegistryManager.GetProps(self))
    local state = assert(RegistryManager.GetState(self))

    self:__fxcall "Remove"

    RegistryManager.Remove(self)
    return nil
end

---Set the weapon's rotation to follow a player's aim direction
---@param player EntityPlayer
function EntityMelee:RotateWithAim(player)
    local state = assert(RegistryManager.GetState(self))
    state.AimRotationSource = Util.MustBePlayer(player)
end

---Set the weapon's rotation to follow a player's movement direction
---@param player EntityPlayer
function EntityMelee:RotateWithMovement(player)
    local state = assert(RegistryManager.GetState(self))
    state.MovementRotationSource = Util.MustBePlayer(player)
end

---Swing the weapon
---@param animation     string              Animation to play
---@param direction?    Direction|Vector    Direction of the swing, if different from the weapon's current rotation
---@param force?        boolean             Override previously playing animation — Default: `false`
function EntityMelee:Swing(animation, direction, force)
    local EvalDirection = Util.When(type(direction), {
        ["nil"] = function()
            return Vector.FromAngle(self:GetSprite().Rotation) ---@type Vector
        end,
        ["number"] = function()
            return Vector.FromAngle(direction) ---@type Vector
        end,
        ["userdata"] = function()
            assert(Util.InstanceOfIsaacApiClass(direction, Vector), "Given direction is `userdata` but not a Vector.")
            return direction
        end,
    })

    direction = EvalDirection() ---@cast direction Vector
    if not force and Isaac.RunCallback(Callback.MC_PRE_WEAPON_SWING, self, direction) then return end

    local state = assert(RegistryManager.GetState(self))
    local sprite = self:GetSprite()

    state.IsSwinging = true
    state.CurrentAnimation = animation

    sprite.Rotation = self.AimRotationOffset + direction:GetAngleDegrees()
    sprite:Play(animation, true)

    Isaac.RunCallback(Callback.MC_WEAPON_SWING_START, self, direction)
end

---@return boolean IsSwinging
function EntityMelee:IsSwinging()
    local state = assert(RegistryManager.GetState(self))
    return state.IsSwinging
end

function EntityMelee:StartCharging()
    if Isaac.RunCallback(Callback.MC_PRE_WEAPON_CHARGE, self) then return end

    local state = assert(RegistryManager.GetState(self))
    local props = assert(RegistryManager.GetProps(self))

    if not state.Chargebar then
        state.Chargebar = Sprite()
        state.Chargebar:Load(props.ChargebarSprite, true)
    end

    state.IsCharging = true
    state.Chargebar:Render(props.GetChargebarPosition())
    state.Chargebar:Update()

    print "Start charging."
    print("Props: " .. inspect(props))
    print("State: " .. inspect(state))
end

function EntityMelee:StopCharging()
    assert(RegistryManager.GetState(self)).IsCharging = false
end

---@return boolean IsCharging
function EntityMelee:IsCharging()
    local state = assert(RegistryManager.GetState(self))
    return state.IsCharging
end

--]]

mod.__EntityMelee = EntityMelee
return mod.__EntityMelee
