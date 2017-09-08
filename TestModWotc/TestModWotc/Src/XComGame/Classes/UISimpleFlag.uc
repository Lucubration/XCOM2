//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UISimpleFlag.uc
//  AUTHOR:  Joe Cortese
//  PURPOSE: Information displayed next to a unit in the tactical game.
//           Supercedes functionality of UIUnitBillboard & UIUnitPoster
//---------------------------------------------------------------------------------------
//  Copyright (c) 2010-2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UISimpleFlag extends UIPanel
	dependson(XComGameState_Unit);

enum EUnitFlagTargetingState
{
	eUnitFlagTargeting_None,
	eUnitFlagTargeting_Dim, 
	eUnitFlagTargeting_Active
};

var public float WorldMessageAnchorX;
var public float WorldMessageAnchorY;

var int StoredObjectID; //Hook up to the object we're attached to 
var XComGameStateHistory History; 

var bool m_bIsFriendly;
var			vector2D		m_positionV2;
var			int				m_scale;
var			bool			m_bIsDead;
var			bool			m_bSpotted;
var			bool			m_bIsOnScreen; 
var			bool			m_bIsSelected;
var			int				m_iScaleOverride;
var EUnitFlagTargetingState m_eState; 
var public	bool			m_bShowDuringTargeting;
var			bool			m_bIsSpecial;

var bool m_bLockToReticle; 
var UITargetingReticle m_kReticle; 

var float m_LocalYOffset;

var int VisualizedHistoryIndex;

// kUnit, the unit this flag is associated with.
simulated function InitFlag(StateObjectReference ObjectRef)
{
	InitPanel();

	History = `XCOMHISTORY;
	
	StoredObjectID = ObjectRef.ObjectID; 

	UpdateFriendlyStatus();

	m_bIsDead = false;
}

// CALLBACK when Flash is initialized and ready to receive values.
simulated function OnInit()
{	
	local XComGameState_BaseObject StartingState;
	local XComGameState_Unit UnitState;

	super.OnInit();

	VisualizedHistoryIndex = `XCOMVISUALIZATIONMGR.LastStateHistoryVisualized;
	StartingState = History.GetGameStateForObjectID(StoredObjectID, , VisualizedHistoryIndex);

	UnitState = XComGameState_Unit(StartingState);
	if ((UnitState != none) && !UnitState.GetMyTemplate().bDisplayUIUnitFlag)
	{
		Remove();
	}
	else
	{
		UpdateFromState(StartingState, true);
	}
}

simulated function RespondToNewGameState( XComGameState NewState, bool bForceUpdate=false )
{
	local XComGameState_BaseObject ObjectState;	
	
	//the manager responds to a game state before on init is called on this flag in a replay or a tutorial.
	//do not allow calls too early, because unit flag uses direct invoke which results in bad calls pre-init 
	if( !bIsInited )
	{
		return;
	}

	if( bForceUpdate || bIsVisible )
	{				
		if( NewState != None )
		{
			VisualizedHistoryIndex = NewState.HistoryIndex;
			ObjectState = NewState.GetGameStateForObjectID(StoredObjectID);
		}
		else
		{
			ObjectState = History.GetGameStateForObjectID(StoredObjectID);
		}

		if (ObjectState != None)
			UpdateFromState(ObjectState, , bForceUpdate);
	}
}

simulated function UpdateFromState(XComGameState_BaseObject NewState, bool bInitialUpdate = false, bool bForceUpdate = false)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Destructible DestructibleState;

	UnitState = XComGameState_Unit(NewState);
	if(UnitState != none)
	{
		UpdateFromUnitState(UnitState, bInitialUpdate, bForceUpdate);
	}
	else
	{
		DestructibleState = XComGameState_Destructible(NewState);
		if(DestructibleState != none)
		{
			UpdateFromDestructibleState(DestructibleState, bInitialUpdate, bForceUpdate);
		}
	}
}

//----------------------------------------------------------------------------
//  Called in response to new game states
simulated function UpdateFromDestructibleState(XComGameState_Destructible NewDestructibleState, bool bInitialUpdate = false, bool bForceUpdate = false)
{
	local X2VisualizerInterface Visualizer;

	Visualizer = X2VisualizerInterface(NewDestructibleState.GetVisualizer());
	
	MC.FunctionString("setBGColor", class'UIUtilities_Colors'.static.GetHexColorFromState(Visualizer.GetMyHUDIconColor()));
	MC.FunctionString("loadIcon", "img:///" $ Visualizer.GetMyHUDIcon());
}

//----------------------------------------------------------------------------
//  Called in response to new game states
simulated function UpdateFromUnitState(XComGameState_Unit NewUnitState, bool bInitialUpdate = false, bool bForceUpdate = false)
{
	local X2VisualizerInterface Visualizer;

	Visualizer = X2VisualizerInterface(NewUnitState.GetVisualizer());

	MC.FunctionString("setBGColor", class'UIUtilities_Colors'.static.GetHexColorFromState(Visualizer.GetMyHUDIconColor()));
	MC.FunctionString("loadIcon", "img:///" $ Visualizer.GetMyHUDIcon());
		
	//Used to indicate which units are visible from the path cursor. 
	//It should always be FALSE here ( moving the path cursor should never submit new game states )
	RealizeLOSPreview(false);
}

//----------------------------------------------------------------------------
//  Called from the UIUnitFlagManager's OnTick
simulated function Update( XGUnit kNewActiveUnit )
{
	local vector2d UnitPosition; //Unit position as a percentage of total screen space
	local vector2D unitScreenPos; //Unit position in pixels within the current resolution
	local vector vUnitLoc;
	local float flagScale;
	//local XComGameState_Unit UnitState;
	local Actor VisualizedActor;
	local X2VisualizerInterface VisualizedInterface;
	local XComGameState_Unit UnitState, ActiveUnitState;
	local XGUnit VisualizedUnit, ActiveUnit;
	local array<StateObjectReference> VisibleTargets;

	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent EffectTemplate;

	const WORLD_Y_OFFSET = 40;

	// If not shown or ready, leave.
	if( !bIsInited )
		return;
	
	if( m_bIsDead)
	{
		return;
	}

	// Do nothing if unit isn't visible.  (And hide if not already hidden).
	VisualizedActor = History.GetVisualizer(StoredObjectID);
	VisualizedUnit = XGUnit(VisualizedActor);
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(StoredObjectID));
	if( VisualizedActor == none || !VisualizedActor.IsVisible() || (UnitState != None && UnitState.IsBeingCarried()) || (VisualizedUnit != none && VisualizedUnit.GetPawn().IsInState('RagDollBlend')) )
	{
		Hide();
		return;
	}
	else 
	{
		if (UIUnitFlagManager(Owner).m_bHideEnemies)
		{
			Hide();
			return;
		}

		// check for LOS-modifier on the active unit, and hide us if the active unit can't see us directly
		ActiveUnit = XComTacticalController(PC).GetActiveUnit(); // get the active unit directly since the passed in value is none when on frames where the active unit didn't change
		if (ActiveUnit != none)
		{
			ActiveUnitState = XComGameState_Unit( History.GetGameStateForObjectID( ActiveUnit.ObjectID ) );
			foreach ActiveUnitState.AffectedByEffects(EffectRef)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				if (EffectState != None)
				{
					EffectTemplate = EffectState.GetX2Effect();
					if (EffectTemplate.IsA( 'X2Effect_Blind' )) // LOS-modifiers
					{
						// can they see us
						class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyTargetsForUnit( ActiveUnitState.ObjectID, VisibleTargets );
						if (VisibleTargets.Find( 'ObjectID', StoredObjectID ) == INDEX_NONE)
						{
							Hide();
							return;
						}
					}
				}
			}
		}
	}

	// Now get the unit's location data 
	VisualizedInterface = X2VisualizerInterface(VisualizedActor);
	if(VisualizedInterface != none)
	{
		vUnitLoc = VisualizedInterface.GetUnitFlagLocation();
	}
	else
	{
		vUnitLoc = VisualizedActor.Location;
	}
	
	m_bIsOnScreen = class'UIUtilities'.static.IsOnscreen(vUnitLoc, UnitPosition, 0, WORLD_Y_OFFSET);
	
	//Reticle lock is triggered by watch vars, not this update trigger.
	//(Make sure we don't abort before computing m_bIsOnScreen, though!)
	if (m_bLockToReticle)
	{
		return;
	}

	if( !m_bIsOnScreen || !m_bShowDuringTargeting )
	{
		//Hiding off screen 
		Hide();
	}
	else
	{
		Show();

		unitScreenPos =  Movie.ConvertNormalizedScreenCoordsToUICoords(UnitPosition.X, UnitPosition.Y, false);
		unitScreenPos.Y += m_LocalYOffset;

		if( m_iScaleOverride > 0 )
		{
			SetFlagPosition( unitScreenPos.X, unitScreenPos.Y - m_iScaleOverride, m_iScaleOverride );
		}
		else
		{
			// Don't scale the flag if we're attached to a flag (even if our position is not locked to it)
			if(m_kReticle != none || m_bIsSelected)
				flagScale = 100;
			else
				flagScale = (unitScreenPos.Y / 22.5) + 52.0;

			SetFlagPosition( unitScreenPos.X , unitScreenPos.Y, flagScale );
		}
	}
}

// Set the location and scale of the unit flag.
// ( Formally was SetLoc )
// x, horizontal position
// y, vertical position
// scale, a value 1-100 (technically can be > 100) for poster size.
simulated function SetFlagPosition(int flagX, int flagY, int scale)
{
	local ASValue myValue;
	local Array<ASValue> myArray;

	// Only update if a new value has been passed in.
	if ((m_positionV2.X != flagX) || (m_positionV2.Y != flagY) || (m_scale != scale))
	{
		m_scale = scale;
		m_positionV2.X = flagX;
		m_positionV2.Y = flagY;

		myValue.Type = AS_Number;

		myValue.n = m_positionV2.X;
		myArray.AddItem( myValue );
		myValue.n = m_positionV2.Y;
		myArray.AddItem( myValue );
		myValue.n = m_scale;
		myArray.AddItem( myValue );

		Invoke("SetPosition", myArray);
	}
}

simulated function SetScaleOverride( int iOverride )
{
	m_iScaleOverride = iOverride;
}

simulated function RealizeLOSPreview(bool bSeen)
{
	SetSpottedState(bSeen);
}

simulated function SetSpottedState(bool bShow)
{
	local ASValue myValue;
	local Array<ASValue> myArray;

	if (bShow == m_bSpotted) return;

	m_bSpotted = bShow;

	myValue.Type = AS_Boolean;
	myValue.b = m_bSpotted;
	myArray.AddItem(myValue);

	Invoke("SetSpottedState", myArray);
}

simulated function UpdateFriendlyStatus()
{
	local XGUnit UnitVisualizer;
	local XComGameState_Player LocalPlayerObject;
	local XComGameState_Destructible DestructibleObject;

	UnitVisualizer = XGUnit(History.GetVisualizer(StoredObjectID));

	if (UnitVisualizer != none)
	{
		m_bIsFriendly = UnitVisualizer != none ? UnitVisualizer.IsFriendly(PC) : false;
	}
	else
	{
		LocalPlayerObject = XComGameState_Player(History.GetGameStateForObjectID(`TACTICALRULES.GetLocalClientPlayerObjectID()));
		DestructibleObject = XComGameState_Destructible(History.GetGameStateForObjectID(StoredObjectID));
		m_bIsFriendly = DestructibleObject != none ? !DestructibleObject.IsTargetable(LocalPlayerObject.GetTeam()) : false;
	}
}


simulated function SetSelected(bool isSelected)
{
	m_bIsSelected = isSelected;
	RealizeAlphaSelection();
}

//HACK: shifting the alpha as a visual test for Greg 
simulated function RealizeAlphaSelection()
{
	if( m_bIsSelected || !m_bIsFriendly || m_kReticle != none )
		SetAlpha(100);
	else
		SetAlpha(40);
}

simulated function Show()
{
	if ( XComTacticalCheatManager(`XCOMGRI.GetALocalPlayerController().CheatManager) != none && 
		!XComTacticalCheatManager(`XCOMGRI.GetALocalPlayerController().CheatManager).bShowUnitFlags )
		return;

	if( m_bIsDead )
		return;

	if( !m_bIsOnScreen )
		return;

	// don't show flags on destructible actors that are not mission objectives unless we are actively targeting them 
	if(!m_bLockToReticle 
		&& XComGameState_Destructible(History.GetGameStateForObjectID(StoredObjectID)) != none
		&& History.GetGameStateComponentForObjectID(StoredObjectID, class'XComGameState_ObjectiveInfo') == none)
	{
		return;
	}

	super.Show();
}
simulated function Hide()
{
	super.Hide();
}

simulated function bool IsAttachedToUnit( XGUnit possibleUnit )
{
	return( StoredObjectID == possibleUnit.ObjectID );
}

simulated function LockToReticle( bool bShouldLock, UITargetingReticle kReticle )
{
	m_kReticle = kReticle; 
	
	if( m_kReticle != none )
	{
		m_bLockToReticle = bShouldLock;

		if(m_bLockToReticle)
			Movie.Pres.SubscribeToUIUpdate(UpdateLocationFromReticle);
		else
			Movie.Pres.UnsubscribeToUIUpdate(UpdateLocationFromReticle);
	}
	else if(m_bLockToReticle)
	{
		m_bLockToReticle = false;
		Movie.Pres.UnsubscribeToUIUpdate(UpdateLocationFromReticle);
		if(XComDestructibleActor(History.GetVisualizer(StoredObjectID)) != none)
			Hide();
	}
}

simulated function UpdateLocationFromReticle()
{
	local Vector2D vLocation;

	if(m_kReticle != none)
	{
		if(m_kReticle.bIsVisible)
		{
			Show();
			if(bIsVisible)
			{
				vLocation = Movie.ConvertNormalizedScreenCoordsToUICoords(m_kReticle.Loc.X, m_kReticle.Loc.Y);

				//Prevent the unit flag from being off the top of the screen, if the reticle is very near to it
				if (vLocation.Y < 200)
					SetFlagPosition(vLocation.X + 40, 160, 100);
				else
					SetFlagPosition( vLocation.X + 40, vLocation.Y - 40, 100 );
					
			}
		}
		else
			Hide();
	}
	else
		LockToReticle(false, none);
}

simulated function Remove()
{
	UIUnitFlagManager(Owner).RemoveSimpleFlag(self);
	super.Remove();
}

event Destroyed()
{
	Movie.Pres.UnsubscribeToUIUpdate(UpdateLocationFromReticle);
	super.Destroyed();
}

defaultproperties
{
	m_bIsFriendly   = true;
	m_bIsSelected   = false; 
	m_kReticle = none; 
	m_iScaleOverride = 0;
	m_bShowDuringTargeting = true; 
	
	WorldMessageAnchorX = 65.0;
	WorldMessageAnchorY = -170.0;
}