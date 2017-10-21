//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TickableStateObject extends StateObject
	native
	abstract
	inherits(FTickableObject);
	
// if true, this object will continue ticking even if the game is paused
var() bool				bTickWhenGamePaused;

//struct native TimerData
//{
//	var bool			bLoop;
//	var Name			FuncName;
//	var float			Rate, Count;
//	var Object			TimerObj;
//	var bool			bPaused;
//};

var const array<TimerData>			Timers;			// list of currently active timers

// see Actor
native final function SetTimer(float inRate, optional bool inbLoop, optional Name inTimerFunc='Timer', optional Object inObj);
native final function ClearTimer(optional Name inTimerFunc='Timer', optional Object inObj);
native final function PauseTimer( bool bPause, optional Name inTimerFunc='Timer', optional Object inObj );
native final function bool IsTimerActive(optional Name inTimerFunc='Timer', optional Object inObj);

event Tick( float DeltaTime );

cpptext
{
// FTickableObject interface

	/**
	 * Returns whether it is okay to tick this object. E.g. objects being loaded in the background shouldn't be ticked
	 * till they are finalized and unreachable objects cannot be ticked either.
	 *
	 * @return	TRUE if tickable, FALSE otherwise
	 */
	virtual UBOOL IsTickable() const
	{
		// We cannot tick objects that are unreachable or are in the process of being loaded in the background.
		return !HasAnyFlags( RF_Unreachable | RF_AsyncLoading );
	}

	/**
	 * Used to determine if an object should be ticked when the game is paused.
	 *
	 * @return always TRUE as networking needs to be ticked even when paused
	 */
	virtual UBOOL IsTickableWhenPaused() const
	{
		return bTickWhenGamePaused;
	}

	/**
	 * Here to complete the interface but needs to be overriden
	 *
	 * @param ignored
	 */
	virtual void Tick(FLOAT DeltaTime);
	
// AActor Functionality
	void UpdateTimers(FLOAT DeltaSeconds);
	void ProcessState( FLOAT DeltaSeconds );
}

DefaultProperties
{

}
