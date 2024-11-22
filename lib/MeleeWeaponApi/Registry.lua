-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponapi.mod" ---@class MeleeWeaponApiModReference

---@class WeaponRegistry
---@field [MeleeWeapon] WeaponRegistryEntry
local Registry = mod.__Registry
    or setmetatable({
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

mod.__Registry = Registry
return mod.__Registry
