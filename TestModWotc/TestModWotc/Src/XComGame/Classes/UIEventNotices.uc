//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIEventNotices.uc
//  AUTHOR:  Brit Steiner
//  PURPOSE: Display and manage the short lifespan of visual notices. 
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIEventNotices extends UIScreen;

struct UIEventNoticeItem
{
	var string DisplayString;
	var string ImagePath;
	var float DisplayTime;
	var string Value;
	var string Label;
	var EUIState eState; 
	var bool bIsBanner; 
	var delegate<OnMouseEventDel> OnMouseEvent;

	var UIPanel ListItem;
	var float MaxDisplayTime;

	structDefaultProperties
	{
		DisplayTime = 0.0;
		bIsBanner = false;
		MaxDisplayTime = 5.0;
	}
};

var UIPanel Container;
var UIList List; 
var array<UIEventNoticeItem> Notices;

delegate OnMouseEventDel(int cmd);

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);
	
	Container = Spawn(class'UIPanel', self);
	Container.InitPanel();

	if( XComPresentationLayer(Movie.Pres) != none ) //In tactical 
	{
		Container.AnchorBottomRight();
		Container.SetPosition( -10, -230);
	}
	else //in strategy 
	{
		Container.AnchorBottomLeft();
		Container.SetPosition(10, -200);
	}

	List = Spawn(class'UIList', Container);
	List.InitList('', 0, 0, 400, 400);

	Activate();
}


function Activate()
{
	GotoState('Active');
}
function Deactivate()
{
	GotoState('Inactive');
}

simulated state Inactive
{
Begin:
	Hide();
}

simulated function Show()
{
	super.Show();
}
simulated function Hide()
{
	super.Hide();
}

simulated state Active
{
	event Tick(float deltaTime)
	{
		local int i, iInitialNotices;
		local UIEventNoticeItem Notice;

		if( bIsVisible )
		{
			if( Notices.Length == 0 ) return;
			if( Movie.Stack.IsCurrentClass(class'UIDialogueBox') ) return;

			iInitialNotices = Notices.length;

			if( Notices.Length > 0 )
			{
				// Go from end to beginning because we may be removing items from the array. 
				for( i = Notices.Length - 1; i >= 0; i-- )
				{
					Notice = Notices[i];
					Notice.DisplayTime += deltaTime;

					if( Notice.DisplayTime > Notice.MaxDisplayTime )
					{
						Notice.ListItem.Remove();
						Notices.Remove(i, 1);
					}
					else
					{
						Notices[i] = Notice; // Copy back in! 
					}
				}
			}

			if( Notices.Length != iInitialNotices )
			{
				//List.ClearItems();
				UpdateEventNotices();
			}
		}
	}

Begin:
Show();
}

simulated function NotifyBanner(string NewInfo,
	optional string ImagePath = "",
	optional string Subtitle = "",
	optional string Value = "",
	optional EUIState eState = eUIState_Normal,
	optional delegate<OnMouseEventDel> NewOnMouseEvent)
{
	local UIEventNoticeItem Notice;

	Notice.DisplayString = NewInfo;
	Notice.ImagePath = ImagePath;
	Notice.Label = Subtitle;
	Notice.Value = Value;
	Notice.eState = eState;
	Notice.bIsBanner = true;
	Notice.MaxDisplayTime = 10.0;
	Notice.OnMouseEvent = NewOnMouseEvent;
	Notices.AddItem(Notice);
	UpdateEventNotices();
}

simulated function Notify(string NewInfo, optional string ImagePath = "")
{
	local UIEventNoticeItem Notice;

	Notice.DisplayString = NewInfo;
	Notice.ImagePath = ImagePath;
	Notices.AddItem(Notice);
	UpdateEventNotices();
}

simulated function UpdateEventNotices()
{
	local int i;
	local UIEventNoticeItem Notice; 

	if(Notices.Length > 0)
	{
		for(i = 0; i < Notices.Length; ++i)
		{
			Notice = Notices[i]; 
			
			// Check that type of list item matches update type 
			if( Notice.bIsBanner ) 
			{
				if (Notice.ListItem == none)
				{
					Notice.ListItem = Spawn(class'UIEventNotice_BannerListItem', List.itemContainer).InitPanel();
					Notices[i] = Notice;
				}
				UIEventNotice_BannerListItem(Notice.ListItem).PopulateBannerData(Notice.eState, Notice.DisplayString, Notice.Label, Notice.Value, Notice.ImagePath, Notice.OnMouseEvent);
			}
			else
			{
				if (Notice.ListItem == none)
				{
					Notice.ListItem = Spawn(class'UIEventNotice_ListItem', List.itemContainer).InitPanel();
					Notices[i] = Notice;
				}

				UIEventNotice_ListItem(Notice.ListItem).PopulateData(Notice.DisplayString, Notice.ImagePath);
			}

		}
		Show();
	}
	else
	{
		Hide();
	}

	List.SetY(-List.ShrinkToFit());
}

simulated function bool AnyNotices()
{
	return Notices.Length > 0;
}

defaultproperties
{
}