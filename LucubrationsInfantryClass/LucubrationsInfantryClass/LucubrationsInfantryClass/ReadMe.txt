Adds an Infantry class to the game with many new abilities.

Version 1.5.6: 9/7/2017

Updated Korean localization.

Version 1.5.3: 3/18/2016

Updated Zone of Control counterattack to have an animation.

Updated Flare description to indicate that it's a free action.

Version 1.5.1: 3/18/2016

Fixed Escape and Evade activating at the start of stealth missions and revealing the Infantry on the next turn.

Fixed Fire for Effect's targeting method.

Version 1.5: 3/15/2016

Removed Shotgun as a primary weapon for the Infantry. This was a tough decision; I really want the extra flexibility of the shotgun as a choice for the Infantry, but it seems like the shotgun is just an overly powerful weapon in the vanilla game. I want the class to be strong offensively, but not ludicrously so.

Adjusted Fire for Effect to not be targetable through solid walls. It has been given some height adjustment to overcome LoS issues over low cover.

Reduced Flare to 2 charges. It's useful enough now as a free action to justify it as a perk, but it shouldn't be available for every pod on a mission given its position on the tree.

Updated GTS perk image (thanks, S-Flo!)

Version 1.4.6: 3/14/2016

Changed Fire for Effect to cost 3 ammo and end your turn after use.
Added Workshop tags.

Version 1.4.5: 3/13/2016

Added localization for French (thanks zaranheim).
Updated localization for Korean with fixed Stick and Move description (thanks thunderbeast).
Fixed file encoding for Russian localization.

Version 1.4.4: 3/10/2016

Fixed description for Stick and Move ability. It now properly reflects that the soldier gains +20 defense while moving until they attack.
Fixed Established Defenses icon to show among the soldier's passive buffs during missions.
Added localization for Korean (thanks thunderbeast).
Added localization for Russian (thanks 1ion).

Version 1.4.3: 3/9/2016

Changed Shake it Off into a passive ability that gives +10 will and reduces the duration of or cleanses impairments applied to the Regular at the start of every turn. The new form should make it more effective in its intended utility of keeping the Regular from being sidelined by impairments (at least too badly).

Adjusted Fire for Effect's targeting method to a sphere rather than a narrow cone. This change is intended to lower the need to reposition to use this ability, something runs counter to the typical role of the Regular.

Adjusted Zone of Control to have a 75% chance to counter the first melee attack in a turn. Following attacks are countered only if they miss or graze the Infantry.

Version 1.4: 3/7/2016

Removed defense as a leveling stat for the Infantry and increased their offense gain in turn. This change will not be applied retroactively to any levels already gained by Infantry in ongoing campaigns.
Damage mitigation in the form of dodge turns out to be less desirable than I had expected because of the way the wound system works in Xcom 2. Rather than stacking damage mitigation though dodge, the Irregular will now gain access to temporary concealment to avoid being shot at and can gain a situational bonus to the defense stat for damage avoidance. The Regular has the option to reduce the time they spend recovering from wounds between missions.

Changed Cool Under Pressure to Opportunist, which is functionally identical but allows me to support it better because it's not a default ability from the game.

Increased Flare range and charges, and made it a free action with a 1 turn cooldown. In practice, using Flare was rarely beneficial over either attacking or moving and it was cumbersome to get targets in range. Now it should be a straightforward but limited-use benefit.

Changed Crippling Shot's name to Staggering Shot. Instead of reducing mobility, the target loses 1 action point on its turn if the attack hits. It retains the dodge reduction, which has been slightly increased. Its damage penalty and cooldown have been slightly reduced but it may no longer crit. In its updated form, it is now comparable in effect but applicable in a wider variety of situations.

Changed Established Defenses to increase the Infantry's number of Overwatch shots and armor by 1 per remaining action point when the Overwatch skill is activated. This should better reflect the intent of this skill in letting the Regular dig in and prepare to receive the enemy.

Changed Stick and Move to provide the Irregular with +4 mobility through their next move when attacking, and +2 damage and +20 defense through their next attack when moving. This should better reflect the intent of this skill in providing the Irregular wilthbetter opportunities to reposition for more powerful attacks.

Changed Zone of Control to allow one reaction fire attack with your pistol against an enemy moving or attacking within 5 tiles, and to allow the soldier to counter the first melee attack against them each turn. Zone of Control became slightly redundant with the change to Established Defenses, and this change should keep it distinguished in its role of close-in defensive support for the Infantry.

Changed Escape and Evade into an active ability that puts the Irregular into an improved form of concealment until the start of their next turn. This ability should allow the Irregular the opportunity to escape if they have overcommitted, or to perform a hidden flanking maneuver.

Limited the total healing available from Deep Reserves, but modified the ability to reduce the soldier's recovery time from wounds sustained during a mission. This reflects the Regular's ability to recover more quickly from grevious injury due to their strong constitution.

Moved the Explosive Action penalty to the turn following activation. This should make its penalty effect easier to plan for.

Reduced the action point cost for Fire for Effect by 1 and changed its targeting style to a free-targeted cone. In practice, the ability was rarely used due to the high action point cost and clumsy targeting method. This should allow the Infantry more opportunities to put Fire for Effect to use.

Version 1.3: 2/29/2016

Fixed a crash that occurred when going to a loading screen between the Avenger and a mission some time after using an Infantry with at least one of: Zone of Control, Escape and Evade, Stick and Move, and Deep Reserves.
If you have a game stuck at a loading screen with these symptoms, after updating this mod you should be able to progress past the loading screen by first disabling the Infantry mod, going through the loading screen, then re-enabling the mod afterwards.

Version 1.2.1: 2/28/2016

Fixed an issue with config file formatting preventing the Infantry from receiving the proper stat increases when achieving Corporal rank.

Version 1.2: 2/27/2016

Added default nicknames list (sourced from Enemy Within's Assault class).
Added 'Extra Conditioning' perk to the GTS for Infantry.
Prevented 'Zone of Control' reaction fire from shooting at targets outside of its intended range.
Reviewed and adjusted the eligibility of Infantry skills for AWC perks. The following Infantry perks are now avaiable as cross-class skills through the AWC: Harrier, Crippling Shot, Explosive Action, Fire for Effect.

Version 1.1: 2/26/2016

Fixed Stick and Move not activating correctly on the soldier's actions.
Fixed Deep Reserves error calculating amount to heal.
Added a visual effect for Flare. It's not quite where I want it to be yet, but at least it looks better!

Initial Release: 2/25/2016

This is a pet mod I've been working on for a little while. I began to miss the basic rifleman class from the Long War mod and decided to create one of my own. The Infantry use a rifle as their primary weapon and a pistol as their secondary weapon.

The Infantry class has two perk trees: the "Regular" Infantry and the "Irregular" Infantry. The Regular is intended to be a tough customer, able to take some hits and act as a roadblock to the enemy advance if necessary. The Irregular is intended to put pressure on the enemy, having means to exploit positions of advantage and some way of escaping the tight spots they can put themselves in.

In the interest of full disclosure, I must caution the user that many of the abilities I've created for this class are the product of looking for new things to learn and practice in the Xcom 2 Development Tools. That's not to say that I didn't consider fun and balance while building this class, but I may have sometimes been influenced in my decision making, thinking "Hey, wouldn't that be a cool ability? I wonder if I could make the game do that?"

In any case, I had a lot of fun designing, implementing and testing this class, and I hope you have as much playing with it.

If you want to mess around with the parameters for the custom abilities, many of them are exposed in the 'XComLucubrationsInfantryClass.ini' file (search for it in your Steam directory).

Compatibility:
No compatability issues that I have tested, and generally there should not be any, but I strongly suspect that it will conflict specifically with other mods that add an "Infantry" class to the game due to resource naming conflicts.

Known Bugs:
While the mechanics for the Zone of Control counterattack work fine, when the counterattack occurs there is currently has no animation. This is because Xcom humans have no counterattack animation. This may be beyond me to fix.