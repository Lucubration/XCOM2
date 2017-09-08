//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIIconSelector.uc
//  AUTHOR:  Brittany Steiner 9/1/2014
//  PURPOSE: UIPanel to for a Icon selector grid. 
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIIconSelector extends UIPanel;

var float ITEM_PADDING;
var float EDGE_PADDING;
var float				ChipHeight; 
var float				ScrollbarPadding;
var UIScrollbar			Scrollbar;
var UIMask				Mask;
var UIPanel				ChipContainer;
var array<UIIconChip>	IconChips; 
var array<string>		IconPaths;
var int					InitialSelection; 
var bool				bAnimateChips; 
var UIBGBox				BG; 

delegate OnPreviewDelegate(int iIconIndex);
delegate OnSetDelegate(int iIconIndex);

simulated function UIIconSelector InitIconSelector(optional name InitName, 
													 optional float initX = 500,
													 optional float initY = 500,
													 optional float initWidth = 1000,
													 optional float initHeight = 500,
												 	 optional array<string> initIconPaths,
												 	 optional delegate<OnPreviewDelegate> initPreviewDelegate,
													 optional delegate<OnSetDelegate> initSetDelegate,
													 optional int initSelection = 0,
													 optional array<string> iniSecondaryIcons) //TODO: implement secondary chips
{
	InitPanel(InitName);

	width = initWidth;
	height = initHeight;
	SetPosition(initX, initY);

	BG = Spawn(class'UIBGBox', self);
	BG.bAnimateOnInit = false;
	BG.InitBG();
	BG.SetSize(width, height);
	BG.ProcessMouseEvents(OnChildMouseEvent);

	ChipContainer = Spawn(class'UIPanel', self).InitPanel();
	ChipContainer.bCascadeFocus = false;
	ChipContainer.bAnimateOnInit = false;
	ChipContainer.SetY(5); // offset slightly so the highlight for the chips shows up in the masked area
	ChipContainer.SetSelectedNavigation();

	if(initIconPaths.length == 0 )
		initIconPaths = GenerateRandomIcons();

	OnPreviewDelegate = initPreviewDelegate; 
	OnSetDelegate = initSetDelegate; 

	InitialSelection = initSelection;

	CreateIconChips(initIconPaths);

	return self; 
}

simulated function CreateIconChips( array<string> _IconPaths)
{
	local UIIconChip Chip, LeftNavTargetChip, RightNavTargetChip, UpNavTargetChip, DownNavTargetChip; 
	local int iChip, iRow, iCol, iMaxChipsPerRow, iLastRowLength, iOffset; 
	
	IconPaths = _IconPaths;

	iMaxChipsPerRow = int( (width - ITEM_PADDING - ScrollbarPadding) / ( class'UIIconChip'.default.width + ITEM_PADDING ) );

	iRow = 0;
	iCol = -1; 

	// Create chips ----------------------------------------------------
	for( iChip = 0; iChip < IconPaths.Length; iChip++ )
	{
		iCol++; 
		if( iCol >= iMaxChipsPerRow )
		{
			iCol = 0;
			iRow++; 
		}

		Chip = Spawn( class'UIIconChip', ChipContainer);
		Chip.InitIconChip( '',
							iChip, 
							IconPaths[iChip], 
							GetChipX(iCol), 
							GetChipY(iRow), 
							class'UIIconChip'.default.width, 
							iRow, 
							iCol,
							OnPreviewIcon, 
							OnAcceptIcon);
		Chip.OnMouseEventDelegate = OnChildMouseEvent;
		if( bAnimateChips ) 
			Chip.AnimateIn(iChip * (class'UIUtilities'.const.INTRO_ANIMATION_DELAY_PER_INDEX / 2));
		IconChips.AddItem(Chip);
	}
	//Save height to use for the mask/scrollbar comparison 
	ChipHeight = GetChipY(iRow) + class'UIIconChip'.default.height; 

	// Hook up navigation ---------------------------------------------
	for( iChip = 0; iChip < IconChips.Length; iChip++ )
	{
		Chip = IconChips[iChip];

		LeftNavTargetChip = none; 
		RightNavTargetChip = none; 
		UpNavTargetChip = none; 
		DownNavTargetChip = none; 

		iLastRowLength = IconChips.length % iMaxChipsPerRow; 

		iOffset = iChip % iMaxChipsPerRow;

		// LEFT - RIGHT -------------------------------------------------
		if( Chip.Col == 0 ) // Left column
		{
			// In the last row, the left chip needs to wrap to the last chip, 
			// regardless of width of that last row which may be an incomplete row. 
			if( Chip.index >= IconChips.Length - iMaxChipsPerRow ) 
				LeftNavTargetChip = IconChips[IconChips.length-1];
			else
				LeftNavTargetChip = IconChips[iChip + iMaxChipsPerRow - 1];
		}
		else if( Chip.Col == iMaxChipsPerRow - 1 )// right column 
			RightNavTargetChip = IconChips[iChip - iMaxChipsPerRow+1];
		else if( Chip.index == IconChips.length-1 )
			RightNavTargetChip = IconChips[iChip - iLastRowLength+1];

		
		if( LeftNavTargetChip == none )
			LeftNavTargetChip = IconChips[iChip-1];
		if( RightNavTargetChip  == none )
			RightNavTargetChip = IconChips[iChip+1];

		Chip.Navigator.AddNavTargetLeft( LeftNavTargetChip );
		Chip.Navigator.AddNavTargetRight( RightNavTargetChip );

		// UP - DOWN -------------------------------------------------
		
		if( Chip.Row == 0 ) // first row 
		{
			if( iOffset >= iLastRowLength )
				UpNavTargetChip = IconChips[ IconChips.Length - iLastRowLength - iMaxChipsPerRow + iOffset ];
			else
				UpNavTargetChip = IconChips[ IconChips.Length - iLastRowLength  + iOffset ];
		}
		else if( Chip.index >=IconChips.Length - iMaxChipsPerRow) // last edge, may wrap row 
		{
			DownNavTargetChip = IconChips[ iOffset ];
		}

		if( UpNavTargetChip == none )
			UpNavTargetChip = IconChips[iChip-iMaxChipsPerRow];
		if( DownNavTargetChip == none )
			DownNavTargetChip = IconChips[iChip+iMaxChipsPerRow];

		Chip.Navigator.AddNavTargetUp( UpNavTargetChip );
		Chip.Navigator.AddNavTargetDown( DownNavTargetChip );
		
	}

	RealizeMaskAndScrollbar();
	SetInitialSelection();
}

simulated function SetInitialSelection()
{
	if (IconChips.Length > 0)
	{
		if (InitialSelection > -1 && InitialSelection < IconChips.Length )
		{
				ChipContainer.Navigator.SetSelected(IconChips[InitialSelection]);
		}
		else
		{
			ChipContainer.Navigator.SetSelected(IconChips[0]);
		}
	}
}

simulated function float GetChipX( int iCol )
{
	return ((class'UIIconChip'.default.width + ITEM_PADDING) * iCol) + (EDGE_PADDING); 
}

simulated function float GetChipY( int iRow )
{
	return ((class'UIIconChip'.default.height + ITEM_PADDING) * iRow) + (EDGE_PADDING); 
}

simulated function array<string> GenerateRandomIcons()
{
	local array<string> NewIcons; 

	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_unknown");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_aggression");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_aimcover");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_aim");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_aliengrenade");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_ambush");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_ammo_ap");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_bankshot");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_barage");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_battlefatigue");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_bigbooms");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_bladestorm");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_blasterlauncher");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_blindfire");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_bloodcall");
	NewIcons.AddItem("UILibrary_PerkIcons.UIPerk_body_shield");
		
	return NewIcons; 
}


simulated function OnPreviewIcon(int iIndex)
{
	if(OnPreviewDelegate != none)
		OnPreviewDelegate( iIndex );
}

simulated function OnAcceptIcon(int iIndex)
{
	if(OnSetDelegate != none)
		OnSetDelegate( iIndex );
}

simulated function OnCancelIcon()
{
	if(OnSetDelegate != none)
		OnSetDelegate( InitialSelection );
}

simulated function RealizeMaskAndScrollbar()
{
	if(ChipHeight > height)
	{
		if(Mask == none)
			Mask = Spawn(class'UIMask', self).InitMask();

		Mask.SetMask(ChipContainer);
		Mask.SetSize(width, height - EDGE_PADDING * 2);
		Mask.SetPosition(0, EDGE_PADDING);

		if(Scrollbar == none)
			Scrollbar = Spawn(class'UIScrollbar', self).InitScrollbar();

		Scrollbar.SnapToControl(Mask, -scrollbarPadding);
		Scrollbar.NotifyValueChange(ChipContainer.SetY, 5, 0 - ChipHeight + height - (EDGE_PADDING * 2));
	}
	else
	{
		if(Mask != none)
		{
			Mask.Remove();
			Mask = none;
		}
		
		if(Scrollbar != none)
		{
			Scrollbar.Remove();
			Scrollbar = none;
		}
	}
}

simulated function OnChildMouseEvent( UIPanel control, int cmd )
{
	if(cmd == class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_UP)
		Scrollbar.OnMouseScrollEvent(-1);
	else if(cmd == class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_DOWN)
		Scrollbar.OnMouseScrollEvent(1);
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local UIPanel Chip;

	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	Chip = ChipContainer.Navigator.GetSelected();
	if (Chip != none && Chip.Navigator.OnUnrealCommand(cmd, arg))
	{
		return true;			
	}

	return super.OnUnrealCommand(cmd, arg);
}

defaultproperties
{
	bIsNavigable = true;
	bAnimateOnInit = false;
	bCascadeFocus = false;

	ITEM_PADDING = 10;
	EDGE_PADDING = 20;
	ScrollbarPadding = 30; 
	bAnimateChips = false;
}
