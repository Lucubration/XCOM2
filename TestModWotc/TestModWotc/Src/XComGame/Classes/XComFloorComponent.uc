/** XComFloorComponent 
 *  Overhauled 10/19/2012 - Jeremy Shopf
 *  
 *  The purpose of this component is to control transitions between a level actor's various visibility states. It
 *      effectively acts as a wrapper around level/frac level actors..
 *      
 *   The floor component only ticks when a transition for it's owner's primtivies is in progress. Note that the actual
 *      setting of the fade values are set by the renderthread in UpdatePrimitiveCutoutFade(). The floor component's job 
 *      is to make sure the state of the primitive (bCutoutMask, etc.) doesn't change until the fade is finished. */

class XComFloorComponent extends ActorComponent
	hidecategories(Object)
	native(Level);

struct native VisSettings
{
	/** Whether the actor should be cutdown when it is finished fading. */
	var native bool bCutdown;
	/** Whether the actor should be cutout when it is finished fading. */
	var native bool bCutout;
	/** Whether the actor should hidden when it is done fading. */
	var native bool bHidden;
	/** Whether the actor should "toggle hidden" when it is done fading. This means it renders to the Occluded render
	*     channel but not to the Main render channel. */
	var native bool bToggleHidden;
	/** Whether the actor should be hidden due to periphery hiding. */
	var native bool bPeripheryHidden;

	// These variables are set from the gameplay controlled variables above. Allows above variables to modify seperate values without having multiple systems fight for control over a variable.
	var native bool bWorkingCutdown;
	var native bool bWorkingCutout;
	var native bool bWorkingHidden;
	var native bool bWorkingToggleHidden;

	// Keeps track of combined hidden flags. Useful to not allow one flag to unhide a mesh that the other flag is tryign to tell to hide.
	var native bool bTrackHidden;

	structcpptext
	{
		UBOOL Equals(const FVisSettings& Other);
	}

	structdefaultproperties
	{
		bCutout = false
		bCutdown = false
		bHidden = false
		bToggleHidden = false
		bPeripheryHidden = false

		bWorkingCutdown=false
		bWorkingCutout=false
		bWorkingHidden=false
		bWorkingToggleHidden=false

		bTrackHidden=false
	}
};

var transient VisSettings CurrentVisSettings;
var transient VisSettings NewVisSettings;

/** Will be true inside of any frame in which the cutout flag is changed. */
var native transient bool bCutoutStateChanged;
var native transient bool bCutdownStateChanged;
var native transient bool bHeightStateChanged;
var native transient bool bHiddenStateChanged;
var native transient bool bToggleHiddenStateChanged;
var native transient bool bVisStateChanged;
var native transient bool bRestoreLOD_TickRate;

var native transient bool bOwnerUsesPeripheryHiding;

/** Cached target fade value */
var native transient float fTargetFade;

/** Cached target opacity mask heights. The previous opacity mask height is the cutout or cutdown height when the current transition
 *  began. The opacity mask height is last cutdown or cutout height set during the transition.  */
var native float fTargetOpacityMaskHeight;

var native float fTargetCutoutMaskHeight;
var native float fTargetCutdownMaskHeight;

/** Whether a cutout transition is currently occuring. */
var transient bool bFadeTransition;
/** Whether the last trigger transition was a fade out, or not. */
var transient bool bCurrentFadeOut;

var native transient bool bComponentNeedsTick;

/* If true, don't allow the component to be cutout from cutout boxes or vis traces. */
var transient bool bIsCutoutFromExternalMeshGroup;

var transient int iFramesSinceTransition;

/** The owner actor is transitioning to/from a cutdown state. 
 *  Note that the target height is set direction on the primitive by ::ChangeVisibility*() **/
native simulated function SetTargetCutdown( bool bInCutdown );

/** The owner actor is transitioning to/from a cutout state. **/
native simulated function SetTargetCutout( bool bInCutout );

/** The owner actor is transition to a hidden state. **/
native simulated function SetTargetHidden( bool bInHidden );

native simulated function SetTargetPeripheryHidden(bool bInPeripheryHidden);

native simulated function SetIsHidingFromExternalMeshGroup(bool bIsHidingFromExternalMeshGroup);
native simulated function bool IsHidingFromExternalMeshGroup();

/** The owner actor is transition to a "toggle hidden" state. **/
native simulated function SetTargetToggleHidden( bool bInToggleHidden );

/** Cache cutdown/cutout heights. */
native simulated function SetTargetVisHeights( float fInTargetCutdownHeight, float fInTargetCutoutHeight );
native simulated function GetTargetVisHeights( out float fOutTargetCutdownHeight, out float fOuttargetCutoutHeight );

native simulated private function PreTransition();

//native simulated private function PostTransition();

/** Perform actions when a cutout transition is requested. **/
native simulated private function OnBeginFadeTransition( bool bFadeOut, bool bResetFade, out float fCutoutFade, out float fTargetCutoutFade );

/** Perform actions when we've finished our transition to the cutout state **/
native simulated private function OnFinishedFadeTransition( float fCutdownHeight, float fCutoutHeight );

native simulated private function StopTransition();

native simulated private function bool HasRenderedRecently();
native simulated private function SetFadeValuesOnOwner(float fCutoutFade);

cpptext
{
	virtual void PostLoad();
	virtual void Tick(FLOAT DeltaTime);
	virtual UBOOL InStasis();
}

defaultproperties
{
	bFadeTransition=false
	bCurrentFadeOut=true // initialize this to true because the first transition will be out
	bComponentNeedsTick=false
	bOwnerUsesPeripheryHiding=false

	bIsCutoutFromExternalMeshGroup=false

	fTargetOpacityMaskHeight=999999.0
	fTargetCutoutMaskHeight=999999.0
	fTargetCutdownMaskHeight=999999.0

	TickGroup=TG_PostAsyncWork
}
