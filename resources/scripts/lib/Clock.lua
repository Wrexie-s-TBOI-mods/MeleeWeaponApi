-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local MAX_TICK_DEFAULT = 60

---@param maxTick? integer default: `60`
local function Clock(maxTick)
    if type(maxTick) ~= "number" or maxTick < 1 then maxTick = MAX_TICK_DEFAULT end

    ---@class Clock
    local clock = {
        now = 0,
        max = maxTick,
    }

    ---@param newMax? integer
    function clock:reset(newMax)
        self.now = 0
        if type(newMax) ~= "number" or newMax < 1 then return end
        self.max = newMax
    end

    ---@param step? integer default: `1`
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

return Clock
