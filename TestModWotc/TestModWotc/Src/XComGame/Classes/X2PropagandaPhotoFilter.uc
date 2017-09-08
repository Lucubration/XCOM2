//---------------------------------------------------------------------------------------
//  FILE:    X2PropagandaPhotoFilter.uc
//  AUTHOR:  Joe Cortese
//  PURPOSE: 
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2PropagandaPhotoFilter extends Object native;

struct native PropagandaPhotoFilterCallback
{
	var function CallbackFunction;
	var Object   CallbackOwner;

	structcpptext
	{	
		FPropagandaPhotoFilterCallback() : 
			CallbackFunction(NULL),
			CallbackOwner(NULL)
		{}

		UBOOL operator== (const FPropagandaPhotoFilterCallback& Other) const
		{
			return Other.CallbackFunction == CallbackFunction && Other.CallbackOwner == CallbackOwner;
		}
	}
};


var Object      WatchOwner;
var Object      CallbackOwner;

var delegate<FilterCallback> CallbackFn;
delegate bool FilterCallback( X2PropagandaPhotoTemplate Template);