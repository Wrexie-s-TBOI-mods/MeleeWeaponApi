-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable, global_usage)
---@diagnostic disable: unused-local

---@alias PtrHash integer

---@enum MeleeWeaponApiDebugMode
local MeleeWeaponApiDebugMode = {
    --- Logging with `dprint` will print to the console.
    On = 1,

    --- Logging with `dprint` be ignored.
    Off = 0,

    --- Logging with `dprint` will throw an error.
    --- Useful for cleaning up code before releasing to production.
    Cleanup = -1,
}

---@class MeleeWeaponApi
---@field DebugMode MeleeWeaponApiDebugMode
---@field Util      MeleeWeaponApiUtil
_G.MeleeWeaponApi = {}

---@class EntityMeleeCreateOptions
--[[
    The created weapon's EntityVariant.
    ]]
---@field Variant integer
--[[
    The created weapon's `SpawnerEntity`.
    ]]
---@field Spawner Entity
--[[
    Entity subtype.  

    Default: 0
    ]]
---@field Subtype? integer
--[[
    Initial position and velocity of the created weapon.

    Default: { Position = Spawner:GetPosVel().Position, Velocity = Vector.Zero }
    ]]
---@field PosVel? PosVel
--[[
    Follow `Spawner`'s position.

    Default: true
    ]]
---@field Follow? boolean

---@param options EntityMeleeCreateOptions
---@return EntityMelee
function MeleeWeaponApi:Create(options) end

--[[
    Maybe print something to the console.
    ]]
---@see MeleeWeaponApiDebugMode
---@see MeleeWeaponApi.DebugMode
function _G.dprint(...) end

--[[
    Convert an angle into a `Vector`.  
    <br>
    Added in MeleeWeaponApi: This function is missing from the Binding of Isaac VS Code extension
    even though it is part of the base modding API.  
]]
---@param angle number
---@return Vector
function _G.Vector.FromAngle(angle) end
