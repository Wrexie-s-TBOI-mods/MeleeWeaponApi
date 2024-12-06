-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference

local IMPORT_PATH_PREFIX = "src.Buzzaxe.Callbacks."

---@class Buzzaxe
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe"
Buzzaxe.Callbacks = Buzzaxe.Callbacks or {}

---@class BuzzaxeCallbacks : { [string]: ModCallbackModule }
local CallbackManager = mod.__CallbackManager or {}
mod.__CallbackManager = CallbackManager

---@param key?      ModCallbacks
---@param priority? CallbackPriority
---@param fn?       function
---@param param?    integer
function CallbackManager:RegisterCallback(key, priority, fn, param)
    if not key or not fn then return end

    if priority then
        mod:AddPriorityCallback(key, priority, fn, param)
    else
        mod:AddCallback(key, fn, param)
    end
end

---@param key?      ModCallbacks
---@param fn?       function
function CallbackManager:RemoveCallback(key, fn)
    if not key or not fn then return end

    mod:RemoveCallback(key, fn)
end

---@param filename  string
---@param module    ModCallbackModule
function CallbackManager:RegisterEntries(filename, module)
    self[filename] = module

    for _, entry in ipairs(module) do
        self:RegisterCallback(entry.key, entry.priority, entry.fn, entry.param)
    end
end

---@param filename string
function CallbackManager:UnloadModule(filename)
    local module = self[filename]

    for _, entry in ipairs(module) do
        mod:RemoveCallback(entry.key, entry.fn)
    end

    self[filename] = nil
end

---@param filename  string
function CallbackManager:LoadModule(filename)
    local path = IMPORT_PATH_PREFIX .. filename
    local module = include(path) ---@type ModCallbackModule

    if self[filename] then
        if not module.force then return end
        self:UnloadModule(filename)
    end

    self:RegisterEntries(filename, module)
end

--[[This seems pointless and, technically speaking, it is.  
    However, I've set an alias in my VSCode Lua config so that functions named
    `LoadModule` are treated as an alias of `include`/`require`.  
    That way, I get code completion and validity check on filenames.
    ]]
local function LoadModule(filename)
    CallbackManager:LoadModule(filename)
end

LoadModule "ActiveChargeTimer"
LoadModule "OnCacheEvalSpeed"
LoadModule "OnPlayerInitState"
LoadModule "OnPlayerUpdateDestroyWeapon"
LoadModule "OnRampageEnd"
LoadModule "OnUseItem"
