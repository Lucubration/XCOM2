//---------------------------------------------------------------------------------------
//  FILE:    X2Action_PlayWorldMessage.uc
//  AUTHOR:  Brit Steiner
//  DATE:    11/11/2016
//  PURPOSE: Visualization for scrolling world messages.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Action_PlayMessageBanner extends X2Action;

struct BannerData
{
	var() string Message;
	var() string Subtitle;
	var() string Value;
	var() EUIState eState;
	var() string IconPath;
	var delegate<UIEventNotices.OnMouseEventDel> OnMouseEvent;
};

var array<BannerData> BannerMessages;
var bool bDontPlaySoundEvent;

function AddMessageBanner(
	string Message, 
	optional string IconPath = "img:///UILibrary_XPACK_Common.WorldMessage", 
	optional string Subtitle = "", 
	optional string Value = "",  
	optional EUIState eState = eUIState_Normal, 
	optional delegate<UIEventNotices.OnMouseEventDel> NewOnMouseEvent)
{
	local BannerData NewMessage;

	NewMessage.Message = Message;
	NewMessage.IconPath = IconPath;
	NewMessage.Subtitle = Subtitle;
	NewMessage.Value = Value;
	NewMessage.eState = eState;
	NewMessage.OnMouseEvent = NewOnMouseEvent;

	BannerMessages.AddItem(NewMessage);
}

//------------------------------------------------------------------------------------------------
simulated state Executing
{
	function PlayAllMessages()
	{
		local int Index;
		local XComPresentationLayer Presentation;
		local BannerData Data; 
		local bool AnyNegativeBanners;

		Presentation = `PRES;

		AnyNegativeBanners = false;

		for( Index = 0; Index < BannerMessages.Length; ++Index )
		{
			Data = BannerMessages[Index];
			Presentation.NotifyBanner(	Data.Message, Data.IconPath, Data.Subtitle, Data.Value, Data.eState, Data.OnMouseEvent);

			switch( Data.eState )
			{
			case eUIState_Bad:
			case eUIState_Warning:
			case eUIState_Warning2:
			case eUIState_TheLost: AnyNegativeBanners = true; break;
			}
		}

		if( !bDontPlaySoundEvent )
		{
			`SOUNDMGR.PlayPersistentSoundEvent((AnyNegativeBanners) ? "UI_Blade_Negative" : "UI_Blade_Positive");
		}
	}
Begin:
	PlayAllMessages();

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return false;
}

event bool ShouldForceCompleteWhenStoppingAllPreviousActions()
{
	return false;
}

defaultproperties
{
}

