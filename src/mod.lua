-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

---@class KriegModReference : ModReference
local mod = RegisterMod("Krieg", 1)

local DEBUG = true

--[[Print stuff to the console but only in debug mode
    ]]
_G.dprint = DEBUG and function(...)
    print(...)
end or function()
    -- Do nothing
end

return mod
