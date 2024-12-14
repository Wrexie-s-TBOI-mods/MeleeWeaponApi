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

--[[
    Perform a Switch/Case-like selection.  
    `value` is used to index `cases`.  
    When `value` is `nil`, returns `default`.  
    <br>
    **Note:** Type inference on this function is decent, but not perfect.
    In some cases, you might want to use things such as [casting](https://luals.github.io/wiki/annotations/#as)
    the returned value.  
    This is a limitation of LuaLS. [More info](https://github.com/LuaLS/lua-language-server/issues/1861)
    ]]
---@generic In, Out, Default
---@param value     In
---@param cases     { [In]: Out }
---@param default?  Default
---@return Out | Default
function Util.When(value, cases, default) end

---@generic Out
---@alias WhenFn<Out> fun(): Out

---@generic In
---@alias WhenFnCases<In, Out> { [In]: WhenFn<Out> }

--[[
    Perform a Switch/Case-like selection, like `Util.When`, but takes a table of functions and runs
    the found matching case to return its result.  
    `value` is used to index `cases`.  
    When `value` is `nil`, calls `default` and returns its result.  
    <br>
    **Note:** Type inference on this function is worse than on `Util.When`, as it can only infer
    the returned type from `default`. You will most likely want to [cast](https://luals.github.io/wiki/annotations/#as)
    te result of this call.  
    This is a limitation of LuaLS. [More info](https://github.com/LuaLS/lua-language-server/issues/1861)
    ]]
---@see Util.When
---@generic In: any, Out, Default
---@param value    In
---@param cases    { [any]: fun(): Out? }
---@param default? fun(): Default?
---@return Out | Default
function Util.CallWhen(value, cases, default) end
