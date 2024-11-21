-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "resources.scripts.lib.MeleeWeaponapi.mod" ---@type ModReference

---@class WeaponRegistryTable
---@field [MeleeWeapon] WeaponRegistryEntry
local R = setmetatable({
    size = 0,
}, {
    __index = function(self, weapon)
        return rawget(self, GetPtrHash(weapon.Effect))
    end,
    __newindex = function(self, weapon, value)
        rawset(self, GetPtrHash(weapon.Effect), value)
        if value == nil then
            self.size = math.max(0, self.size - 1)
        else
            self.size = self.size + 1
        end
    end,
    __len = function(self)
        return self.size
    end,
    __metatable = false,
})

---TODO: Garbage collection on run end
---@class WeaponRegistry
local Registry = {}

---@param weapon MeleeWeapon
---@param options MeleeWeaponCreateOptions
function Registry.Add(weapon, options)
    ---@type WeaponRegistryEntry
    local reg = {
        weapon = weapon,
        options = options,
        state = {
            owner = options.Spawner,
        },
        callbacks = {},
    }

    R[weapon] = reg
end

---@param weapon    MeleeWeapon
---@param key       ModCallbacks
---@param fn        function
---@param param     any
function Registry.AddCallback(weapon, key, fn, param)
    local callbacks = R[weapon].callbacks[key]

    mod:AddCallback(key, fn, param)
    callbacks[#callbacks + 1] = fn
end

---@param weapon    MeleeWeapon
---@param table     RegistryCallbackTable
function Registry.AddCallbacks(weapon, table)
    for key, callbacks in pairs(table) do
        for _, cb in ipairs(callbacks) do
            Registry.AddCallback(weapon, key, cb[1], cb[2])
        end
    end
end

---@param weapon MeleeWeapon
function Registry.GetState(weapon)
    return R[weapon].state
end

function Registry.Size()
    return R.size
end

function Registry.Remove(weapon)
    local entry = R[weapon]
    if not entry then return end

    for key, cb in pairs(entry.callbacks) do
        mod:RemoveCallback(key, cb[1])
    end
    R[weapon] = nil
end

return setmetatable(Registry, {
    __index = Registry,
    __newindex = function()
        error "Trying to edit MeleeWeaponApi's Registry table"
    end,
    __metatable = false,
})
