-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "lib.MeleeWeaponApi.mod" ---@class MeleeWeaponApiModReference

---@class MeleeWeaponApi
local Api = mod.__Api or {}
mod.__Api = Api

local Util = Api.Util or {}
Api.Util = Util

local MAX_TICK_DEFAULT = 60

---@param maxTick? number default: `60`
function Util.Clock(maxTick)
    if type(maxTick) ~= "number" or maxTick < 1 then maxTick = MAX_TICK_DEFAULT end

    ---@class Clock
    local clock = {
        now = 0, ---@type number
        max = maxTick, ---@type integer
    }

    ---@param newMax? integer
    function clock:reset(newMax)
        self.now = 0
        if type(newMax) ~= "number" or newMax < 1 then return end
        self.max = newMax
    end

    ---@param step? number default: `1`
    ---@return integer rotations How many rotations have been completed by this tick
    function clock:tick(step)
        if type(step) ~= "number" or step < 0 then step = 1 end
        local rotations

        self.now = self.now + step
        rotations = self.now // self.max
        self.now = self.now % self.max

        return rotations
    end

    return clock
end
