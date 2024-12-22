-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

local mod = include "Api.mod"
local Custom = mod.Api.Callbacks

---@param _mod      ApiModReference
---@param weapon    EntityMelee
local function RenderChargeBar(_mod, weapon)
    local state = weapon:GetState(true)
    local bar = state.Chargebar

    if not bar then return end

    local percent = math.max(0, weapon.ChargePercentage)

    if state.IsCharging then
        if percent < 99 then
            bar:SetFrame("Charging", math.floor(percent))
        elseif bar:IsFinished "StartCharged" or bar:IsFinished "Charged" then
            bar:Play("Charged", true)
        elseif not bar:IsPlaying "StartCharged" and not bar:IsPlaying "Charged" then
            bar:Play("StartCharged", true)
        end
    elseif not bar:IsPlaying "Disappear" then
        if bar:IsFinished "Disappear" then
            state.Chargebar = nil
        else
            bar:Play("Disappear", true)
        end
    end

    bar:Render(weapon:GetChargebarPosition())
    bar:Update()
end

return {
    force = true,
    {
        key = Custom.MC_POST_WEAPON_RENDER,
        fn = RenderChargeBar,
    },
}
