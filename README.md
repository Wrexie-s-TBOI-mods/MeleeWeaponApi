# Melee Weapon API

***A user-friendly way of implementing melee weapons in mods for The Binding of Isaac: Repentance.***

To use to API, with the mod installed and enabled, an global class serving as namespace is exposed: `MeleeWeaponApi`.
Inside this class you will find a function: `.Create(options)`, to create instances of `EntityMelee`.

The `EntityMelee` class is a subclass of `EntityEffect`, which means that you must provide it with the `EntityVariant` id of an *effect*, but it also means that you can you can use all properties and methods of `EntityEffect` and `Entity` as well!

`EntityMelee` is designed around calling specialised callbacks on various actions and states.
These callbacks are all functions with a name starting with `:On...` and that you can override with your own code, leaving to the API most of the worries of managing game/weapon/player state and all the `AddCallback` logic.
You still have easy access to your weapon's state, and, if you really want to, you can modify it, though I don't particularly recommend it.
When one such callback is run during the execution of a `ModCallback`, the corresponding `ModCallback` is mentioned in its documentation and in-editor annotations under `[Parent callback]`.

`MeleeWeaponApi` also contains an `Util` class, serving as a namespace for a whole bunch of neat little functions designed to make code more readable while also reducing boilerplate.

To access all the types and in-editor documentation, it is recommended to download the `Types`, and copy it anywhere into your mod's folder under any name you like, e.g. `path/to/game/mods/My AWESOME mod/MWA types`. A Virtual Studio Code extension *might* come in the future to rid the need for this step.

Full documentation and examples comming *soon:tm:*.

Requirements:

- Afterbirth+ and Repentance
- Repentogon

---

## FAQ*

> **What did you use to make this ?**  
> VS Code and the Binding of Isaac extension, StyLua for formatting and Selene for code linting.  
> Docs are generated from the typings in `Types` using LDoc.  
<!--  -->
> **Can I use it for my mod ?**  
> Of course, that's what it's made for !  
> Just make sure to mention the API somewhere in the mod's description, I'd love for more people to find it. 😊  
<!--  -->
> **Can I help you develop the API ?**  
> Sure, if you find any bugs or if you have some feature/improvement proposal, you're welcome to open a PR and I will gladly take a look at it !  
<!--  -->
> **What was your motivation to make this ?**  
> Well, I wanted to make my first mod a character with a melee weapon. I tried using things from the game like `EntityKnife` but didn't get anything good.  
> So I looked and asked on Discord for any kind of existing API to make weapons easily and my search yielded no results.  
> Why not just make that my first mod, and then use it in my second mod, you know ?  
<!--  -->
> **Hey, just wondering if you got your photos printed?**  
> bogos binted ?  

*Nobody asked anything about this API so I faked some "interesting" questions.

---

## TODOs in appromixate order of priority

- [x] Find a way to make modules peristent through `include`s
  - [ ] Leverage global usage and meta typings to get rid of the `x = mod.__x or include "..." // mod.__x = x` pattern
  - [x] Prevent registering the same callbacks repeatedly on `luamod`
- [x] Make `EntityMelee` a subclass of `EntityEffect`
- [x] Docs
  - [ ] Generate webview docs from comments
  - [x] Doc-comment *everything*
  - [x] Mention parent ModCallback that runs EntityMelee property callbacks (useful for things like tick rate etc)
- [ ] EntityMelee
  - [x] Swing
    - [x] Callbacks
      - [x] `OnSwingStart`
      - [x] `OnSwingHit`
      - [x] `OnSwingEnd`
    - [x] `IsSwinging`
    - [x] Animate
    - [x] Swing target discriminator
  - [x] Charge
    - [x] Callbacks
      - [x] `GetChargebarPosition`
      - [x] `OnChargeStart`
      - [x] `OnChargeUpdate`
      - [x] `OnChargeFull`
      - [x] `OnChargeEnd`
      - [x] `OnChargeRelease`
    - [x] `IsCharging`
    - [x] Chargebar
  - [x] Player input
    - [x] Callbacks
      - [x] `OnPlayerMoveStart`
      - [x] `OnPlayerMoveUpdate`
      - [x] `OnPlayerMoveEnd`
      - [x] `OnPlayerAimStart`
      - [x] `OnPlayerAimUpdate`
      - [x] `OnPlayerAimEnd`
    - [x] `IsPlayerAiming`
    - [x] `IsPlayerMoving`
  - [ ] Throw
    - [ ] Callbacks
      - [ ] `OnThrowStart`
      - [ ] `OnThrowHit`
      - [ ] `OnThrowEnd`
    - [ ] `IsThrown`
    - [ ] Throw types
      - [ ] None
      - [ ] Projectile
      - [ ] Boomerang
      - [ ] Custom ?
  - [ ] Sprite rotation
    - [ ] `:Rotate()` — I still don't know if rotating the effect with the sprite is necessary
    - [ ] `:SmootRotate()`
    - [ ] User friendly interpolation formula integration — with default(s)
      - [ ] Bézier generator ?
- [ ] Lock API metatables
  *Note: For convenience and dev flexibility, this should be done at the end*
- [ ] VS Code extension
- [ ] Test suites
- [ ] Github Actions
  - [ ] Doc generation
  - [ ] Releases
  - [ ] Changelog
- [x] Lose **The Game** <img src="https://media.tenor.com/mDQf_FmUMeQAAAAi/pokelawls-nooooo.gif" style="height:32px;"/>

---

### License

<!-- markdownlint-disable MD033 -->
 <p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/Wrexie-s-TBOI-mods/MeleeWeaponApi">MeleeWeaponApi - TBOI: Repentance script extension</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/SirWrexes">Ludovic F. (aka Sir Wrexes)</a> is licensed under <a href="https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""></a></p>
