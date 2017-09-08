Hey, everybody! This is a project that I've been working on for the last couple of weeks here: the classes for Beaglerush's Escalation rebalancing.

The Escalation classes are intended to be thematically similar to the Long War classes from Xcom: Enemy Unknown, but updated to incorporate some of the new gameplay features of Xcom 2. We ultimately intend to recreate all eight of the Long War classes: Assault, Infantry, Scout, Sniper, Rocketeer, Gunner, Engineer and Medic.

In our initial release, we're bringing you the Scout and Rocketeer classes. These classes are largely complete in implementation and should be entirely playable in Xcom 2 campaigns. They are intended to be played in campaigns with increased difficulty and are not necessarily balanced for vanilla Xcom 2 difficulty levels. The goal of this mod is to create classes that enable the player to enjoy a "Long War-like" experience in Xcom 2.

For the time being, the Escalation classes will be released in a single mod due the amount of shared assets required to create these classes. I hope to be able to provide a more elegant solution in the not-too-distant future for users to pick and choose between the Escalation classes that appear in their campaigns.


The Scout

The Scout is a nimble yet powerful soldier who operates on the front lines. The Scout does reconnaissance and close-in combat work while relying on their skills at stealth and evasion for protection.

The Scout can use the following weapons: Shotguns, Rifles (and SMGs), Pistols, and Swords. Note: the Scout may only blue move and attack with swords.

The Scout's current perk tree is:

Squaddie:
Lightning Reflexes - The hit chance of reaction fire against this unit is reduced by 90 percent for the first shot, and by 70 percent for additional shots.

Corporal:
Holo Targeting - Any directed primary weapon shot, hit or miss, will mark the target, increasing your squad's aim by +15 against this target.
Executioner - Confers +10 aim and +10 critical chance against targets at or below 50% health.

Sergeant:
Conceal - When the squad is revealed, this soldier remains concealed. Once per mission, immediately enter concealment.
Lightning Hands - Slash your sword/fire your pistol at the target. This attack does not cost an action. 4 turn cooldown.

Lieutenant:
Battle Scanner - Two uses of the Battle Scanner ability per mission.
Flush - Fire a shot that encourages enemies to move. +30 aim. -50% base weapon damage. Uses 2 ammo.

Captain:
Assassinate - Your attacks will not break concealment if they kill the target.
Hit and Run - Your first attack of each turn against an uncovered or flanked target does not cost an action.

Major:
Awareness - The soldier listens very carefully, detecting the presence of nearby enemies. 10 tile radius.
Smoke and Mirrors - Allows one additional use of all equipped support grenades during each mission. It also increases charges from Smoke Grenade and Battle Scanner perks by 1.

Colonel:
Ghost - Greatly reduces the Scout's detection radius by enemies while concealed. -50% detection radius.
Reaper - Your kills with a sword or pistol refund your action points for the turn.

Sergeant GTS (All Soldiers):
Recon - All soldiers gain +1 tile of vision.

Captain GTS:
Low Profile - Scouts treat low cover as high cover.

The Rocketeer

Rocketeers are heavy weapons units that support their team through the application of overwhelming heavy ordnance. The rockets they employ are an effective, if volatile, solution to the alien threat.

The Rocketeer can use the following weapons: Rifles (and SMGs), Rocket Launchers.

The Rocket Launcher is a unique weapon type for the Rocketeer. Currently it uses the Grenade Launcher model. Rockets will experience a certain amount of scatter from the intended target based on the To Hit % of shot taken by the Rocketeer.

The rocket launcher currently fires two types of rockets as ammunition: the High Explosive rocket and the Shredder rocket.
High explosive rockets deal high base damage and can destroy cover, but have a smaller impact radius and do not inherently pierce or shred armor.
Shredder rockets deal lower damage and do not destroy or penetrate cover. They have a much larger explosion radius, shred 2 armor and apply 1 point of Rupture on the target.

Rockets may be upgraded to more powerful versions by researching the Advanced Explosives technology.

bountygiver's Grenades Damage Falloff mod will be applied to rocket damage if installed.

The Rocketeer's current perk tree is:

Squaddie:
Launch Rocket - The Rocketeer uses a rocket launcher to fire rockets. This allows for delivering large explosive payloads at greater range. The Rocketeer packs one High Explosive Rocket as standard equipment.

Corporal:
HEAT Warheads - Your rocket attacks have +3 armor penetration (+6 with Advanced Explosives).
Suppression - Reduces Aim of the unit by 50 and triggering an Overwatch shot if the unit moves. The suppression can be broken if the unit dies and sometimes when it receives damage.

Sergeant:
Fire in the Hole - Grants +10 aim and +3 range for rockets if the soldier has not moved this turn.
Rapid Reaction - If on Overwatch, confers a bonus reaction shot (to a maximum three shots total) for every reaction shot that is a hit.

Lieutenant:
Shredder Rocket - The Rocketeer packs one Shredder Rocket as standard equipment.
Ready for Anything - If you fire without taking any other costly action, you automatically enter Overwatch at the end of your turn.

Captain:
Salvo - Using the rocket launcher or a heavy weapon as your first action does not end the turn.
Opportunist - Eliminates the Aim penalty on reaction shots, and allows reaction shots to cause critical hits.

Major:
Javelin Rockets - Your rockets now travel 33% further.
Danger Zone - Increases area of effect of Suppression and explosives. +2 explosive radius. +3 suppression radius.

Colonel:
Bunker Buster - Launch a high payload H.E. Rocket with an increased blast radius. The Bunker Buster breaks through obstacles in its path before exploding at the point of impact.
Double Tap - Allows you to perform an extra attack if you remain stationary for the turn. Does not include the use of grenades or rockets.

Sergeant GTS (All Soldiers):
Weapons Team - As a single action that ends a trooper’s turn, assist an adjacent Rocketeer, reducing their aim penalty for launching a rocket after taking a costly action by 50%.

Captain GTS:
Snapshot - Reduces the aim penalty for launching a rocket after taking a costly action by 50%.

The Gunner

Gunners are equipped with heavy squad support weapons, excelling at laying down suppressing fire to cover and their teammates in the fight.

Gunners can use the following weapons: Cannons (LMGs), HMGs, and pistols.

Heavy Machine Guns (HMGs) are heavier cousins to the LMG and may only be used by the Gunner class. They gain +1 damage and +1 ammo over the LMG, but apply -1 mobility to the soldier.
The HMG also grants the soldier 8 tiles of squadsight beyond their visual range, but may not be fired after the soldier moves.
HMGs are currently acquired by the Proving Grounds projects Gauss Weapons and Heavy Plasma.

The Gunner's current perk tree is:

Squaddie:
Suppression - Fire a barrage that pins down targets in an area, granting reaction fire against them if they move, and imposing a -50 penalty to the targets' aim.

Corporal:
Holo Targeting - Any directed primary weapon shot, hit or miss, will mark the target, increasing your squad's aim by +15 against this target.
Flush - Fire a shot that encourages enemies to move. +30 aim. -50% base weapon damage. Uses 2 ammo.

Sergeant:
Shredder Ammo - Applies +1/+2/+3 Rupture damage with your primary weapon targets based on weapon tech level.
Opportunist - Eliminates the Aim penalty on reaction shots, and allows reaction shots to cause critical hits.

Lieutenant:
Collateral Damage - Area of effect attack that destroys most cover. 3 ammo.
Ready for Anything - If you fire without taking any other costly action, you automatically enter Overwatch at the end of your turn.

Captain:
Double Tap - Allows you to perform an extra attack if you remain stationary for the turn. Does not include the use of grenades or rockets.
Rapid Reaction - If on Overwatch, confers a bonus reaction shot (to a maximum three shots total) for every reaction shot that is a hit.

Major:
Danger Zone - Increases area of effect of Suppression and explosives. +2 explosive radius. +3 suppression radius.
Fire Superiority - While suppressing, you will take an additional reaction fire shot at your Suppression target if they perform an attack, and against enemies who attack a friendly unit within 3 tiles of you.

Colonel:
Saturation Fire - Fire a cone shaped barrage of bullets at every enemy in an area. In addition, the cover of those enemies can be damaged or destroyed. Uses a lot of ammunition.
Iron Curtain - Area of effect attack that deals very little damage but staggers targets, reducing their action points by 1 on their next turn. 3 ammo. 5 turn cooldown.

Sergeant GTS (All Soldiers):
Brace - As a single action that ends a soldier’s turn, assist an adjacent Gunner, reloading their primary weapon and allowing them to fire an HMG after moving with a -10 aim penalty.

Captain GTS:
Suppressing Fire - Firing at or suppressing an enemy applies a -5 stacking aim penalty on them for 1 turn.


Credits:
bountygiver, for your help in integrating your damage falloff and suppressable range reduction behavior to rockets.
bountygiver, also for your help displaying the rocket scatter standard deviation by the targeting cursor.
WONEYE, for your interesting class nickname lists.

Known issues:
Flush does not behave very well against melee enemies right now, typically encouraging them to move towards the shooter. More investigation into AI behavior trees required.