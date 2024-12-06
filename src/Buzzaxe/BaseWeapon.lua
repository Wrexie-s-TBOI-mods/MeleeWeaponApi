-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local mod = require "src.mod" ---@class KriegModReference
local Buzzaxe = mod.__Buzzaxe or include "src.Buzzaxe.Buzzaxe" ---@class Buzzaxe

---@param player EntityPlayer
function Buzzaxe:DestroyBaseWeapon(player)
    local weapon = player:GetWeapon(1)
    if not weapon then return end

    local state = self.state[player]
    state.weapon = weapon:GetWeaponType()
    Isaac.DestroyWeapon(weapon)
end

---@param player EntityPlayer
function Buzzaxe:RestoreBaseWeapon(player)
    local state = self.state[player]
    local weapon = Isaac.CreateWeapon(state.weapon, player)

    player:SetWeapon(weapon, 1)
end

mod.__Buzzaxe = Buzzaxe
