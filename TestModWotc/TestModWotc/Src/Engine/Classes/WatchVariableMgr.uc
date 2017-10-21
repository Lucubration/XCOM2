//---------------------------------------------------------------------------------------
//  FILE:    WatchVariableMgr.uc
//  AUTHOR:  Ryan McFall  --  03/10/2010
//  PURPOSE: Implements a system of monitored variables and callback functions associated
//           with those variables. Actors which rely on polling can use this system to
//           receive callbacks when their variables of interest have changed instead of 
//           ticking.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class WatchVariableMgr extends Actor 
	inherits(FTickableObject)
	native
	dependson(WatchVariable);

var array<WatchVariable> WatchVariables;
var bool bInWatchVariableUpdate;
var init array<WatchVariable> WatchVariablesToRemove; //Array to hold watch variables pending removal, since we can't remove them immediately if we're 
													  //actively processing the variable array.

/**
 *  Associate a variable with a callback such that the callback will be issued when the variable changes. The variable
 *  specified by kWatchName must be a field of kWatchVarOwner. Supported types are all primitive types plus structs and arrays.
 *  
 *  Return value is a handle that can be used to enable / disable the watch variable
 */
native function int RegisterWatchVariable( Object kWatchVarOwner, name kWatchName, 
									       Object kCallbackOwner, delegate<WatchVariable.WatchVariableCallback> CallbackFn,
									       optional int ArrayIndex = -1);
/**
 *  Allows the registration of a single variable within a struct - so that if the variable with the struct changes the
 *  function specified by CallbackFn on kCallbackOwner will be called.
 *  
 *  kStruct name must be the name of a struct variable somewhere within the field hierarchy of kWatchVarOwner
 *  kWatchName is the name of the variable to be watched for changes
 *  
 *  Return value is a handle that can be used to enable / disable the watch variable
 */
native function int RegisterWatchVariableStructMember( Object kWatchVarOwner, name kStructName, name kWatchName, 
													   Object kCallbackOwner, delegate<WatchVariable.WatchVariableCallback> CallbackFn,
													   optional int ArrayIndex = -1 );

native function UnRegisterWatchVariable( int Handle );
native function EnableDisableWatchVariable( int Handle, bool Enable );
native function bool IsHandleValid( int Handle );

cpptext
{

	// FTickableObject interface
	virtual void Tick(FLOAT DeltaTime);
	
	virtual UBOOL IsTickable() const
	{	
		return !HasAnyFlags( RF_Unreachable | RF_AsyncLoading );
	}

	virtual UBOOL IsTickableWhenPaused() const
	{
		return FALSE;
	}
}

defaultproperties
{
	TickGroup=TG_PostAsyncWork
	bInWatchVariableUpdate = false
}