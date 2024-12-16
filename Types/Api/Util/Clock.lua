-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

-- #selene: allow(unused_variable)
---@diagnostic disable: unused-local

---@class MeleeWeaponApiUtil
local Util = {}

---@class TickerClock
---@field now number
---@field max number
local Clock = {}

--[[
    Set `self.now` to `0`.  
    If `NewMax` is provided, also set `self.max` to that number.  
    If `NewMax` is not a number or is negative, it is ignored.  
    ]]
function Clock:Reset(NewMax) end

--[[
    Advance this clock by given `Step`.
    ]]
---@param Step? number [Default: `1`]
---@return integer Rotations How many rotations have been completed by this tick
function Clock:Tick(Step) end

--[[
    Create a new `TickerClock` instance with given `Max` as its `.max`.
    ]]
---@see TickerClock
---@param Max? number Ticks required for a full rotation [Default: `60`]
---@return TickerClock
function Util.Clock(Max) end
