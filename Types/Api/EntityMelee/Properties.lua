-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

---@meta

---@class EntityMeleeProps
--[[
    If your weapon should have an offset to its rotation angle for whatever reason, you can store it here.  
    Note that this property is just for convenient storage, you sitll have to apply the rotation logic yourself.  
    
    Default: 0
   ]]
---@field AimRotationOffset number
--[[
    If your weapon should have an offset to its rotation angle for whatever reason, you can store it here.  
    Note that this property is just for convenient storage, you sitll have to apply the rotation logic yourself.  

    Default: 0
    ]]
---@field MovementRotationOffset number
--[[
    Used to chose the appropriate frame of the chargebar during a charge.
    If the value is ever negative, it will be interpreted as `0`.  

    Default: 0
    ]]
---@field ChargePercentage number
--[[
    Sprite for the weapon's chargebar.  
    By default, the Api will try to load the game's default chargebar.  
    **Note:** Charge callbacks rely on animations (for now) to function, meaning that if you want to use your
    own chargebar sprite, it needs to have the following animations:  
    &nbsp;&nbsp;- Charging  
    &nbsp;&nbsp;- StartCharged  
    &nbsp;&nbsp;- Charged  
    &nbsp;&nbsp;- Disappear  

    Default: "gfx/chargebar.anm2"
    ]]
---@field ChargebarSprite string
--[[
    Null capsules defined in your sprite's `.anm2`.  
    They're the hitboxes of your weapon, and will be iterated over during a swing to simulate collision.  
    During a swing, `EntityMelee:OnSwingHit()` will be called for each entity found in any of the capsules,
    and the entities will be passed as the first argument (`target`) after `self`.  

    Default: {}
    ]]
---@field Capsules string[]
--[[
    Used to filter out what entities will be considered for `:OnSwingHit()` during a swing.  
    Set to `nil` to hit any entity.  
    **Note:** It is highly recommended to set this value properly if your weapon only hits certain
    types of entity, as swing callbacks are run on every update tick of a swing, for every capsule
    that your sprite has, which could impact performance depending on the complexity of your weapon.
    
    Default: nil
    ]]
---@field SwingTargets? EntityPartition
--[[
    This field is to store any arbitrary data of your choice.  
    
    Default: {}
    ]]
---@field CustomData any
