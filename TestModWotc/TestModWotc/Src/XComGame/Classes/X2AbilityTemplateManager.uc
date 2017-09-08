//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityTemplateManager.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AbilityTemplateManager extends X2DataTemplateManager
	native(Core) config(GameData);

var const config array<name> AbilityAvailabilityCodes;          //  values passed in code to determine why something is failing.
var localized array<string>  AbilityAvailabilityStrings;        //  user facing strings to describe the above codes. assumes the arrays line up exactly.
var const config array<name> EffectUpdatesOnMove;               //  names of effects to be updated on each tile change while a unit is moving.
var const config array<name> AffectingEffectRedirectors;        //  names of effects affecting a unit that could trigger an effect redirect.
var const config array<name> EffectsForProjectileVolleys;       //  names of effects that want to add projectiles conditionally to a volley.

var const config array<name> PreBleedoutCheckEffects;				//  names of effects that want to change what happens to a unit when it dies.
var const config array<name> PreDeathCheckEffects;				//  names of effects that want to change what happens to a unit when it dies.

var protected array<name> StandardMoveAbilityActionTypes;

var config array<name> AbilityUnlocksHeavyWeapon;               //  having any of these abilities will allow a unit to have a heavy weapon (regardless of armor)
var config array<name> AbilityUnlocksGrenadePocket;             //  having any of these abilities will allow a unit to have the grenade slot
var config array<name> AbilityUnlocksAmmoPocket;                //  having any of these abilities will allow a unit to have the ammo slot
var config array<name> AbilityUnlocksExtraUtilitySlot;          //  having any of these abilities will allow a unit to have an extra utility slot (but not more than 2)
var config array<name> AbilityRetainsConcealmentVsInteractives; //  having any of these abilities will allow a unit to retain concealment when otherwise detected by an interactive object

var config int SuperConcealShotMax;								//	shots with the vektor rifle will cap the conceal loss chance at this value, regardless of their modifier
var config int SuperConcealmentNormalLoss;                      //  when an ability template's SuperConcealmentLoss is -1, this value will be used instead
var config int SuperConcealmentMoveLoss;                        //  move abilities should use this value during template creation
var config int SuperConcealmentStandardShotLoss;                //  standard shot and similar abilities should use this value during template creation

var config int NormalChosenActivationIncreasePerUse;                      //  when an ability template's ChosenActivateIncreasePerUse is -1, this value will be used instead
var config int MoveChosenActivationIncreasePerUse;                        //  move abilities should use this value during template creation
var config int NonAggressiveChosenActivationIncreasePerUse;               //  non aggressive abilities should use this value during template creation
var config int StandardShotChosenActivationIncreasePerUse;                //  standard shot and similar abilities should use this value during template creation

var config int NormalLostSpawnIncreasePerUse;                      //  when an ability template's LostSpawnIncreasePerUse is -1, this value will be used instead
var config int MoveLostSpawnIncreasePerUse;                        //  move abilities should use this value during template creation
var config int StandardShotLostSpawnIncreasePerUse;                //  standard shot and similar abilities should use this value during template creation
var config int MeleeLostSpawnIncreasePerUse;					   //  sword slash and similar abilities should use this value during template creation
var config int GrenadeLostSpawnIncreasePerUse;					   //  throwing and launching grenades and similar abilities should use this value during template creation
var config int HeavyWeaponLostSpawnIncreasePerUse;				   //  firing heavy weapons and similar abilities should use this value during template creation

var config array<name> AbilityProvidesStartOfMatchConcealment;  //  e.g. Phantom

var config array<name> NonBreaksConcealmentEffects;				// A unit affected by the effects listed here does not break the concealment of a spotted unit 

//  Names for various abilities & effects that need to be accessed in native code.
var name BeingCarriedEffectName;
var name ConfusedName;
var name DisorientedName;
var name BoundName;
var name PanickedName;
var name BerserkName;
var name ObsessedName;
var name ShatteredName;
var name StunnedName;
var name BurrowedName;
var name BlindedName;
var name TemplarFocusName;
var name SquadsightName;
var name DazedName;

native static function X2AbilityTemplateManager GetAbilityTemplateManager();

static function string GetDisplayStringForAvailabilityCode(const name Code)
{
	local int Idx;

	Idx = default.AbilityAvailabilityCodes.Find(Code);
	if (Idx != INDEX_NONE)
	{
		if (Idx < default.AbilityAvailabilityStrings.Length)
			return default.AbilityAvailabilityStrings[Idx];

		`RedScreenOnce("AbilityAvailabilityCode" @ Code @ "is out of bounds for the list of corresponding display strings. -jbouscher @gameplay");
	}
	else
	{
		`RedScreenOnce("AbilityAvailabilityCode" @ Code @ "was not found to be valid! -jbouscher @gameplay");
	}

	return "";
}

function array<name> GetStandardMoveAbilityActionTypes()
{
	local X2AbilityTemplate MoveTemplate;
	local X2AbilityCost Cost;
	
	if (StandardMoveAbilityActionTypes.Length == 0)
	{
		MoveTemplate = FindAbilityTemplate('StandardMove');
		`assert(MoveTemplate != none);
		foreach MoveTemplate.AbilityCosts(Cost)
		{
			if (Cost.IsA('X2AbilityCost_ActionPoints'))
			{
				StandardMoveAbilityActionTypes = X2AbilityCost_ActionPoints(Cost).AllowedTypes;
				break;
			}
		}
	}
	return StandardMoveAbilityActionTypes;
}

function bool AddAbilityTemplate(X2AbilityTemplate Template, bool ReplaceDuplicate = false)
{
	return AddDataTemplate(Template, ReplaceDuplicate);
}

function X2AbilityTemplate FindAbilityTemplate(name DataName)
{
	local X2DataTemplate kTemplate;

	kTemplate = FindDataTemplate(DataName);
	if (kTemplate != none)
		return X2AbilityTemplate(kTemplate);
	return none;
}

function FindAbilityTemplateAllDifficulties(name DataName, out array<X2AbilityTemplate> AbilityTemplates)
{
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
	local X2AbilityTemplate AbilityTemplate;

	FindDataTemplateAllDifficulties(DataName, DataTemplates);
	
	AbilityTemplates.Length = 0;
	
	foreach DataTemplates(DataTemplate)
	{
		AbilityTemplate = X2AbilityTemplate(DataTemplate);
		if( AbilityTemplate != none )
		{
			AbilityTemplates.AddItem(AbilityTemplate);
		}
	}
}

DefaultProperties
{
	TemplateDefinitionClass=class'X2Ability'
	ManagedTemplateClass=class'X2AbilityTemplate'
	
	BeingCarriedEffectName="BeingCarried"
	ConfusedName="Confused"
	DisorientedName="Disoriented"
	BoundName="Bind"    // Changed this because animation had already named theirs as Bind
	PanickedName = "Panicked"
	BerserkName = "Berserk"
	ObsessedName = "Obsessed"
	ShatteredName = "Shattered"
	StunnedName="Stunned"
	BurrowedName="Burrowed"
	BlindedName="Blinded"
	TemplarFocusName="TemplarFocus"
	SquadsightName="Squadsight"
	DazedName="Dazed"
}