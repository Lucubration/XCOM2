//=============================================================================
// Scout used for path generation.
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class Scout extends Pawn
	native(Pawn)
	config(Game)
	notplaceable
	transient;

/**
 * Represents what type of cover this node provides.
 */
enum ECoverType
{
	/** Default, no cover */
	CT_None,	
	/** Mid-level crouch cover, stand to fire */
	CT_MidLevel,
	/** Full standing cover */
	CT_Standing,
};

cpptext
{
	NO_DEFAULT_CONSTRUCTOR(AScout)

#if WITH_EDITOR

	/**
	* Toggles collision on all actors for path building.
	*/
	virtual void SetPathCollision(UBOOL bEnabled);

	/**
	* Moves all interp actors to the path building position.
	*/
	virtual void UpdateInterpActors(UBOOL &bProblemsMoving, TArray<USeqAct_Interp*> &InterpActs);

	/**
	* Moves all updated interp actors back to their original position.
	*/
	virtual void RestoreInterpActors(TArray<USeqAct_Interp*> &InterpActs);

	/**
	* Clears all the paths and rebuilds them.
	*
	* @param	bShowMapCheck	If TRUE, conditionally show the Map Check dialog.
	*/
	virtual void DefinePaths( UBOOL bShowMapCheck );

	/**
	* Clears all pathing information in the level.
	*/
	virtual void UndefinePaths();

	virtual void Exec( const TCHAR* Str );
	virtual void AdjustCover( UBOOL bFromDefinePaths = FALSE );
	virtual void BuildCover(  UBOOL bFromDefinePaths = FALSE );
	virtual void FinishPathBuild();

#endif
	static AScout* GetGameSpecificDefaultScoutObject();
};

var int MinNumPlayerStarts;


simulated event PreBeginPlay()
{
	// make sure this scout has all collision disabled
	if (bCollideActors)
	{
		SetCollision(FALSE,FALSE);
	}
}

defaultproperties
{
	Components.Remove(Sprite)
	Components.Remove(Arrow)

	RemoteRole=ROLE_None
	AccelRate=+00001.000000
	bCollideActors=false
	bCollideWorld=false
	bBlockActors=false
	bProjTarget=false
	bPathColliding=true
}
