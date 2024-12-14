-- MeleeWeaponApi - TBOI: Repentance script extension (c) by Sir Wrexes
--
-- MeleeWeaponApi - TBOI: Repentance script extension is licensed under a
-- Creative Commons Attribution 4.0 International License.
--
-- You should have received a copy of the license along with this
-- work. If not, see <https://creativecommons.org/licenses/by/4.0/>.

--[[
    ORDER MATTERS !!  
    `Api.mod` MUST be included before anything else.  
    Also use `require` to ensure caching of the module.
    ]]
require "Api.mod"

--[[
    Start the whole initialisation chain.  
    ]]
include "Api.init"

--[[
    Api init is complete, remove mod reference from global namespace.  
    Keep the empty line between this block comment and the next statement, or else  
    this will appear as documentation of `_G.mod`.

    selene: allow(global_usage)
    ]]

_G.mod = nil
