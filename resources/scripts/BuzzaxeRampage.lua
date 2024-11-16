-- BL2 Krieg - TBOI: Repentance character mod (c) by Sir Wrexes
--
-- BL2 Krieg - TBOI: Repentance character mod is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by-nc-sa/4.0/>.

local BuzzaxeRampage = {
    ID = Isaac.GetItemIdByName "Buzzaxe Rampage"
}

local Multiplier = {
    MULT_DAMAGE = 4,
    MULT_SPEED = 1.4
}

local MAX_SPEED = 2

---@param player EntityPlayer
function BuzzaxeRampage:isActive(player)
    local has = (player and player:GetEffects():HasCollectibleEffect(self.ID))
    return has
end

---@param player EntityPlayer
function BuzzaxeRampage:onEvalCacheDamage(player)
    if not hasBuzzaxeRampage(player) then return end
    player.Damage = player.Damage * Multiplier.MULT_DAMAGE
end

---@param player EntityPlayer
function BuzzaxeRampage:onEvalCacheSpeed(player)
    if not hasBuzzaxeRampage(player) then return end
    local speed = player.MoveSpeed * Multiplier.MULT_SPEED
    player.MoveSpeed = speed <= MAX_SPEED and speed or MAX_SPEED
end

function BuzzaxeRampage.init(mod)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BuzzaxeRampage.onEvalCacheDamage, CacheFlag.CACHE_DAMAGE)
    mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BuzzaxeRampage.onEvalCacheSpeed, CacheFlag.CACHE_SPEED)
end

return BuzzaxeRampage
