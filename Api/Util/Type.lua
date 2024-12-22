-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Util = mod.Api.Util

function Util.InstanceOfIsaacApiClass(input, class)
    local mtInput = getmetatable(input)
    local mtClass = getmetatable(type(class) == "function" and class() or class)

    return mtInput.__class == mtClass.__class
end

function Util.GetIsaacApiClassName(object)
    if type(object) ~= "userdata" then return end

    local metatable = getmetatable(object)
    if metatable == nil then return end

    local type = metatable.__type
    if type(type) ~= "string" then return end

    local name = string.gsub(type, "const ", "")
    return name
end

function Util.Type(object)
    local T = type(object)

    if T == "userdata" then return Util.GetIsaacApiClassName(object) or "userdata" end

    return T
end
