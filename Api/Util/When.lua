-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Util = mod.Api.Util

function Util.When(value, cases, default)
    if value == nil then return default end
    return cases[value]
end

function Util.CallWhen(value, cases, default)
    local f = Util.When(value, cases)
    local v = (f and f()) or (default and default())
    return v
end
