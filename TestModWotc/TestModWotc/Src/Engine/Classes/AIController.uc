//=============================================================================
// AIController, the base class of AI.
//
// Controllers are non-physical actors that can be attached to a pawn to control
// its actions.  AIControllers implement the artificial intelligence for the pawns they control.
//
//Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class AIController extends Controller
	native(AI);

/** auto-adjust around corners, with no hitwall notification for controller or pawn
	if wall is hit during a MoveTo() or MoveToward() latent execution. */
var		bool		bAdjustFromWalls;	

/** skill, scaled by game difficulty (add difficulty to this value) */
var     float		Skill;

/** Move target from last scripted action */
var Actor ScriptedMoveTarget;

/** view focus from last scripted action */
var Actor ScriptedFocus;

cpptext
{
	INT AcceptNearbyPath(AActor *goal);
	void AdjustFromWall(FVector HitNormal, AActor* HitActor);
	virtual FVector DesiredDirection();
	
	/** Called when the AIController is destroyed via script */
	virtual void PostScriptDestroyed();
}

event PreBeginPlay()
{
	Super.PreBeginPlay();
	if ( bDeleteMe )
		return;

	if ( WorldInfo.Game != None )
		Skill += WorldInfo.Game.GameDifficulty;
	Skill = FClamp(Skill, 0, 3);
}

/* Reset()
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();
}

/**
 * list important AIController variables on canvas.  HUD will call DisplayDebug() on the current ViewTarget when
 * the ShowDebug exec is used
 *
 * @param	HUD		- HUD with canvas to draw on
 * @input	out_YL		- Height of the current font
 * @input	out_YPos	- Y position on Canvas. out_YPos += out_YL, gives position to draw text for next debug line.
 */
simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	super.DisplayDebug(HUD, out_YL, out_YPos);
}

event SetTeam(int inTeamIdx)
{
	WorldInfo.Game.ChangeTeam(self,inTeamIdx,true);
}

simulated event GetPlayerViewPoint(out vector out_Location, out Rotator out_Rotation)
{
	// AI does things from the Pawn
	if (Pawn != None)
	{
		out_Location = Pawn.Location;
		out_Rotation = Pawn.Rotation;
	}
	else
	{
		Super.GetPlayerViewPoint(out_Location, out_Rotation);
	}
}

function NotifyWeaponFired(Weapon W, byte FireMode);
function NotifyWeaponFinishedFiring(Weapon W, byte FireMode);

function bool CanFireWeapon( Weapon Wpn, byte FireModeNum ) { return TRUE; }


defaultproperties
{
	 bAdjustFromWalls=true
	 MinHitWall=-0.5f
}
