//-----------------------------------------------------------
// An object that can have states.
// Note this object does not tick, there fore cannot run "state code" (the kind that uses Labels, Goto, etc)
// For that functionality, see TickableStateObject
//-----------------------------------------------------------
class StateObject extends Object
	native
	abstract;


// Reference to WorldInfo - may be none depending on when the object is constructed
// FIRAXIS BEGIN jboswell: This causes PIE to crash if a GFXMovie was created
//var transient WorldInfo					WorldInfo;
// FIRAXIS END

// Called immediately after the object is constructed
//
event PostBeginPlay();

// Called after PostBeginPlay.
//
simulated event SetInitialState()
{
	GotoState( 'Auto' );
}
	
cpptext
{
	/**
	 * Minimal initialization constructor.
	 */
	UStateObject();
}

DefaultProperties
{

}
