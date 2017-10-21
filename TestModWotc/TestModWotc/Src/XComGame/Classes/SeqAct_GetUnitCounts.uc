/**
 * Retrieves information about the number of members on a team
 */
class SeqAct_GetUnitCounts extends SequenceAction;

var int Total;
var int RemainingPlayable;
var int Alive;
var int Dead;
var int OnMap;
var int Incapacitated;
var int Confused;
var int Active; // Not in Green Alert and revealed.
var() string CharacterTemplateFilter; // Only characters of this type are counted.  Takes precedence over IgnoreCharactersExcludedFromEvacZoneCounts.
var() array<string> CharacterTemplateFilters; // Only characters of this type are counted.  Takes precedence over IgnoreCharactersExcludedFromEvacZoneCounts.
var() bool bSkipTurrets; // Turrets are not counted by default.
var() bool bIgnoreGhostUnits; // Exclude templar ghosts from the count
var() bool bIgnoreStasisUnits; // Exclude units in stasis from the count
var() bool IgnoreCharactersExcludedFromEvacZoneCounts; // Specified in XComMissions.ini, array 'CharactersExcludedFromEvacZoneCounts' 
var() string VolumeTag;

event Activated()
{
	local XGPlayer RequestedPlayer;
	local array<XComGameState_Unit> TotalUnits;
	local array<XComGameState_Unit> AliveUnits;
	local array<XComGameState_Unit> DeadUnits;
	local array<XComGameState_Unit> OnMapUnits;
	local array<XComGameState_Unit> IncapacitatedUnits;
	local array<XComGameState_Unit> ConfusedUnits;
	local array<XComGameState_Unit> ActiveUnits;
	local array<XComGameState_Unit> RemovedUnits;
	local array<XComGameState_Unit> PlayableUnits;

	Total = 0;
	RemainingPlayable = 0;
	Alive = 0;
	Dead = 0;
	OnMap = 0;
	Incapacitated = 0;
	Confused = 0;
	Active = 0;

	RequestedPlayer = GetRequestedPlayer();
	if (RequestedPlayer != none)
	{
		RequestedPlayer.GetUnits(TotalUnits, bSkipTurrets,, true);
		Total = FilterUnitList(TotalUnits);

		RequestedPlayer.GetAliveUnits(AliveUnits, bSkipTurrets, true);
		Alive = FilterUnitList(AliveUnits);

		RequestedPlayer.GetDeadUnits(DeadUnits, bSkipTurrets, true);
		Dead = FilterUnitList(DeadUnits);

		RequestedPlayer.GetUnitsOnMap(OnMapUnits, bSkipTurrets, true);
		OnMap = FilterUnitList(OnMapUnits);

		RequestedPlayer.GetIncapacitatedUnits(IncapacitatedUnits, bSkipTurrets);
		Incapacitated = FilterUnitList(IncapacitatedUnits);

		RequestedPlayer.GetConfusedUnits(ConfusedUnits, bSkipTurrets);
		Confused = FilterUnitList(ConfusedUnits);

		RequestedPlayer.GetAllActiveUnits(ActiveUnits, bSkipTurrets);
		Active = FilterUnitList(ActiveUnits);

		// derive remaining playable. This criteria should be kept in sync with KismetGameRulesetEventObserver::DidPlayerRunOutOfPlayableUnits
		RemovedUnits = TotalUnits;
		SetRemove( RemovedUnits, OnMapUnits );

		PlayableUnits = AliveUnits;
		SetRemove( PlayableUnits, IncapacitatedUnits );
		RemainingPlayable = SetRemove( PlayableUnits, RemovedUnits );
	}
}

function protected int FilterUnitList(out array<XComGameState_Unit> Units)
{
	local XComGameState_Unit UnitState;
	local XComWorldData WorldData;
	local Volume TestVolume;
	local string Template;
	local XComGameState_Effect TestEffect;
	local XComGameState_Unit Carrier;
	local TTile UnitLocation;
	local array<Name> FilteredCharacters;
	local bool bFilteredOut;
	local array<XComGameState_Unit> FilteredUnits;

	if(CharacterTemplateFilter != "" || CharacterTemplateFilters.Length > 0)
	{
		if(CharacterTemplateFilter != "")
		{
			FilteredCharacters.AddItem(name(CharacterTemplateFilter));
		}

		foreach CharacterTemplateFilters(Template)
		{
			FilteredCharacters.AddItem(name(Template));
		}

		bFilteredOut = false;
	}
	else if(IgnoreCharactersExcludedFromEvacZoneCounts)
	{
		FilteredCharacters = class'XComTacticalMissionManager'.default.CharactersExcludedFromEvacZoneCounts;
		bFilteredOut = true;
	}

	TestVolume = FindVolume();
	if((FilteredCharacters.Length != 0) || (TestVolume != none))
	{
		WorldData = `XWORLD;

		foreach Units(UnitState)
		{
			UnitLocation = UnitState.TileLocation;

			if (TestVolume != none)
			{
				TestEffect = UnitState.GetUnitAffectedByEffectState( class'X2AbilityTemplateManager'.default.BeingCarriedEffectName );
				if (TestEffect != None)
				{
					Carrier = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID( TestEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID ));
					UnitLocation = Carrier.TileLocation;
				}
			}

			// check if the template filter passes
			if( FilteredCharacters.Length == 0 // No filters at all
			   || (!bFilteredOut && FilteredCharacters.Find(UnitState.GetMyTemplateName()) != INDEX_NONE) // Filtered-in characters
			   || (bFilteredOut && FilteredCharacters.Find(UnitState.GetMyTemplateName()) == INDEX_NONE) ) // Filtered-out characters
			{
				// check if the volume filter passes
				if( TestVolume == None || TestVolume.EncompassesPoint(WorldData.GetPositionFromTileCoordinates(UnitLocation)) )
				{
					// If we are flagged to ignore stasis units
					if (!bIgnoreStasisUnits || (bIgnoreStasisUnits && UnitState.AffectedByEffectNames.Find('Stasis') == INDEX_NONE))
					{
					// Last if we are flagged to ignore templar ghosts, then verify then this isn't a ghost
					if(!bIgnoreGhostUnits || (bIgnoreGhostUnits && UnitState.GhostSourceUnit.ObjectID == 0) )
					{
						FilteredUnits.AddItem( UnitState );
					}
				}
			}
		}
		}

		Units = FilteredUnits;
	}

	return Units.Length;
}

private function int SetRemove( out array<XComGameState_Unit> Set, const out array<XComGameState_Unit> Remove )
{
	local int Idx, FindIdx;

	for (Idx = 0; Idx < Remove.Length; ++Idx)
	{
		FindIdx = Set.Find( Remove[ Idx] );
		if (FindIdx != INDEX_NONE)
		{
			Set.Remove( FindIdx, 1 );
		}
	}

	return Set.Length;
}

private function Volume FindVolume()
{
	local Volume CheckVolume;
	local name VolumeTagName;

	if(VolumeTag != "")
	{
		VolumeTagName = name(VolumeTag);
		foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Volume', CheckVolume)
		{
			if(CheckVolume.Tag == VolumeTagName)
			{
				return CheckVolume;
			}
		}
	}

	return none;
}


function protected XGPlayer GetRequestedPlayer()
{
	local XComTacticalGRI TacticalGRI;
	local XGBattle_SP Battle;
	local XGPlayer RequestedPlayer;

	TacticalGRI = `TACTICALGRI;
	Battle = (TacticalGRI != none)? XGBattle_SP(TacticalGRI.m_kBattle) : none;
	if(Battle != none)
	{
		if(InputLinks[0].bHasImpulse)
		{
			RequestedPlayer = Battle.GetHumanPlayer();
		}
		else if(InputLinks[1].bHasImpulse)
		{
			RequestedPlayer = Battle.GetAIPlayer();
		}
		else if(InputLinks[2].bHasImpulse)
		{
			RequestedPlayer = Battle.GetCivilianPlayer();
		}
		else if(InputLinks[3].bHasImpulse)
		{
			RequestedPlayer = Battle.GetTheLostPlayer();
		}
		else
		{
			RequestedPlayer = Battle.GetResistancePlayer();
		}
	}

	return RequestedPlayer;
}

defaultproperties
{
	ObjName="Get Unit Count"
	ObjCategory="Unit"
	bCallHandler=false;

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	InputLinks.Empty;
	InputLinks(0)=(LinkDesc="Human")
	InputLinks(1)=(LinkDesc="Alien")
	InputLinks(2)=(LinkDesc="Civilian")
	InputLinks(3)=(LinkDesc="TheLost")
	InputLinks(4)=(LinkDesc="Resistance")

	VariableLinks.Empty;
	VariableLinks(0)=(ExpectedType=class'SeqVar_Int', LinkDesc="Total", PropertyName=Total, bWriteable=TRUE)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int', LinkDesc="Alive", PropertyName=Alive, bWriteable=TRUE)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Int', LinkDesc="Dead",  PropertyName=Dead,  bWriteable=TRUE)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Int', LinkDesc="OnMap", PropertyName=OnMap, bWriteable=TRUE)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Int', LinkDesc="Incapacitated",  PropertyName=Incapacitated,  bWriteable=TRUE)
	VariableLinks(5)=(ExpectedType=class'SeqVar_Int', LinkDesc="Confused",  PropertyName=Confused,  bWriteable=TRUE)
	VariableLinks(6)=(ExpectedType=class'SeqVar_Int', LinkDesc="Active",  PropertyName=Active,  bWriteable=TRUE)
	VariableLinks(7)=(ExpectedType=class'SeqVar_Int', LinkDesc="RemainingPlayable",  PropertyName=RemainingPlayable,  bWriteable=TRUE)

	bSkipTurrets=true; 
}
