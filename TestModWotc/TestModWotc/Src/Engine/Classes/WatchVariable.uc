//---------------------------------------------------------------------------------------
//  FILE:    WatchVariable.uc
//  AUTHOR:  Ryan McFall  --  03/10/2010
//  PURPOSE: Base class for the WatchVariables tracked by the WatchVariableMgr
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class WatchVariable extends Object native;

struct native WatchPointer
{
	var pointer     WatchAddr;
	var int         BitMask;

	structcpptext
	{	
	FWatchPointer() : 
	WatchAddr(NULL),
	BitMask(0)
	{}

	UBOOL operator== (const FWatchPointer& Other) const
	{
		return Other.WatchAddr == WatchAddr && Other.BitMask == BitMask;
	}
	}
};

struct native WatchCallback
{
	var function CallbackFunction;
	var Object   CallbackOwner;

	structcpptext
	{	
	FWatchCallback() : 
	CallbackFunction(NULL),
	CallbackOwner(NULL)
	{}

	UBOOL operator== (const FWatchCallback& Other) const
	{
		return Other.CallbackFunction == CallbackFunction && Other.CallbackOwner == CallbackOwner;
	}
	}
};

cpptext
{
	void CheckVariableChanged();
	DWORD GetValueCRC();
}

var Object      WatchOwner;
var Object      CallbackOwner;
var bool        Enabled;

//Local caching
var const native property       Watch;
var const native int            WatchPrevCRC;
var const native WatchPointer   PropertyValueAddress;
var const native int            BitMask;
var const native pointer        CallbackAddr; 
var const native int            WatchGroupHandle;
var const native bool           IsFunction;
var const native int            ArrayIndex;
var const native name           WatchName;

var delegate<WatchVariableCallback> CallbackFn;
delegate WatchVariableCallback();