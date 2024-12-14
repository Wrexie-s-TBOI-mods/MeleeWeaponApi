-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

include "Api.Callbacks.Custom"

local IMPORT_PATH_PREFIX = "Api.Callbacks."

---@class CallbackManager : { [string]: ModCallbackModule }
local CallbackManager = mod.__CallbackManager

---@alias ModCallbackKey
---| ModCallbacks
---| string

---@class ModCallbackEntry
---@field key       ModCallbackKey     Key to register the callback for
---@field fn        function            Function to execute on callback trigger
---@field param?    integer             Filter param
---@field priority? CallbackPriority

---@alias ModCallbackModule { [integer]: ModCallbackEntry, force?: boolean }

---@param key?      ModCallbackKey
---@param priority? CallbackPriority
---@param fn?       function
---@param param?    integer
function CallbackManager:RegisterCallback(key, priority, fn, param)
    if not key or not fn then return end

    if priority then
        ---@diagnostic disable-next-line:param-type-mismatch  VSCode type definitions for :ModCallback() wrongly only takes `ModCallback`
        mod:AddPriorityCallback(key, priority, fn, param)
    else
        ---@diagnostic disable-next-line:param-type-mismatch Ditto
        mod:AddCallback(key, fn, param)
    end
end

---@param key?      ModCallbackKey
---@param fn?       function
function CallbackManager:RemoveCallback(key, fn)
    if not key or not fn then return end

    ---@diagnostic disable-next-line:param-type-mismatch Ditto
    mod:RemoveCallback(key, fn)
end

---@param index     string|EntityMelee
---@param module    ModCallbackModule
function CallbackManager:RegisterEntries(index, module)
    if not type(index) == "string" then
        index = self:EntityMeleeIndex(index --[[@as EntityMelee]])
    end

    self[index] = module

    for _, entry in ipairs(module) do
        self:RegisterCallback(entry.key, entry.priority, entry.fn, entry.param)
    end
end

---@param index string|EntityMelee
function CallbackManager:RemoveEntries(index)
    if not type(index) == "string" then
        index = self:EntityMeleeIndex(index --[[@as EntityMelee]])
    end

    local module = self[index]

    for _, entry in ipairs(module) do
        ---@diagnostic disable-next-line:param-type-mismatch Ditto
        mod:RemoveCallback(entry.key, entry.fn)
    end

    self[index] = nil
end

---@param filename  string
function CallbackManager:LoadModule(filename)
    local path = IMPORT_PATH_PREFIX .. filename
    local module = include(path) ---@type ModCallbackModule

    if self[filename] then
        if not module.force then return end
        dprint("[INFO] - MeleeWeaponApi: Force reload callback module " .. filename)
        self:RemoveEntries(filename)
    end

    self:RegisterEntries(filename, module)
end

---@param weapon EntityMelee
function CallbackManager:EntityMeleeIndex(weapon)
    return "EntityMelee@" .. GetPtrHash(weapon)
end

--------- LOAD CALLBACK MODULES BELOW

--[[
    This seems pointless and, technically speaking, it is.  
    However, I've set an alias in my VSCode Lua config so that functions named
    `LoadModule` are treated as an alias of `include`/`require`.  
    That way, I get code completion and validity check on filenames.  
    ]]
---@param filename string
local function LoadModule(filename)
    CallbackManager:LoadModule(filename)
end

LoadModule "TriggerMcPostWeaponRender"
LoadModule "TriggerMcPostWeaponUpdate"

LoadModule "EntityMelee.RengerChargebar"
LoadModule "EntityMelee.TriggerOnCharge"
LoadModule "EntityMelee.TriggerOnSwing"
LoadModule "EntityMelee.RegisterPlayerCallbacks"
