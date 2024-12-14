-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = require "Api.mod" ---@class MeleeWeaponApiModReference

local Api = mod.__Api or {}
mod.__Api = Api

local Util = Api.Util or {}
Api.Util = Util

local MAX_TICK_DEFAULT = 60

---@type TickerClock
local Clock = {}

function Clock:Reset(NewMax)
    self.now = 0
    if type(NewMax) ~= "number" or NewMax < 1 then return end
    self.max = NewMax
end

function Clock:Tick(Step)
    if type(Step) ~= "number" or Step < 0 then Step = 1 end
    local rotations

    self.now = self.now + Step
    rotations = self.now // self.max
    self.now = self.now % self.max

    return rotations
end

local function __newindex(_, key)
    local msg = "Attempting to manually edit a TickerClock's value at index "
        .. tostring(key)
        .. ".\n"
        .. "Please use the instance methods instead."
    error(msg, 2)
end

function Util.Clock(Max)
    if type(Max) ~= "number" or Max < 1 then Max = MAX_TICK_DEFAULT end

    ---@type TickerClock
    local clock = setmetatable({
        now = 0,
        max = Max,
    }, {
        __index = Clock,
        __newindex = __newindex,
        __metatable = false,
    })

    return clock
end
