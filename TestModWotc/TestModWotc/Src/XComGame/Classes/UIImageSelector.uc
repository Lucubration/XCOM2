//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIImageSelector.uc
//  AUTHOR:  Brittany Steiner 9/1/2014
//  PURPOSE: UIPanel to for a Image selector grid. 
//----------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------

class UIImageSelector extends UIPanel;

var float ITEM_PADDING;
var float EDGE_PADDING;
var float				ChipHeight; 
var float				ScrollbarPadding;
var UIScrollbar			Scrollbar;
var UIMask				Mask;
var UIPanel				ChipContainer;
var array<UIImageChip>	ImageChips; 
var array<string>		ImagePaths;
var int					InitialSelection; 
var bool				bAnimateChips;

delegate OnPreviewDelegate(int iImageIndex);
delegate OnSetDelegate(int iImageIndex);

simulated function UIImageSelector InitImageSelector(optional name InitName, 
													 optional float initX = 500,
													 optional float initY = 500,
													 optional float initWidth = 500,
													 optional float initHeight = 500,
												 	 optional array<string> initImagePaths,
												 	 optional delegate<OnPreviewDelegate> initPreviewDelegate,
													 optional delegate<OnSetDelegate> initSetDelegate,
													 optional int initSelection = 0,
													 optional array<string> iniSecondaryImages) //TODO: implement secondary chips
{
	InitPanel(InitName);

	width = initWidth;
	height = initHeight;
	SetPosition(initX, initY);
	
	ChipContainer = Spawn(class'UIPanel', self).InitPanel();
	ChipContainer.bCascadeFocus = false;
	ChipContainer.bAnimateOnInit = false;
	ChipContainer.SetY(5); // offset slightly so the highlight for the chips shows up in the masked area
	ChipContainer.SetSelectedNavigation();

	if(initImagePaths.length == 0 )
		initImagePaths = GenerateRandomImages();

	OnPreviewDelegate = initPreviewDelegate; 
	OnSetDelegate = initSetDelegate; 

	InitialSelection = initSelection;

	CreateImageChips(initImagePaths);

	return self; 
}

simulated function CreateImageChips( array<string> _ImagePaths)
{
	local UIImageChip Chip, LeftNavTargetChip, RightNavTargetChip, UpNavTargetChip, DownNavTargetChip; 
	local int iChip, iRow, iCol, iMaxChipsPerRow, iLastRowLength, iOffset; 
	
	ImagePaths = _ImagePaths;

	iMaxChipsPerRow = int( (width - ITEM_PADDING) / ( class'UIImageChip'.default.width + ITEM_PADDING ) );

	iRow = 0;
	iCol = -1; 

	// Create chips ----------------------------------------------------
	for( iChip = 0; iChip < ImagePaths.Length; iChip++ )
	{
		iCol++; 
		if( iCol >= iMaxChipsPerRow )
		{
			iCol = 0;
			iRow++; 
		}

		Chip = Spawn( class'UIImageChip', ChipContainer);
		Chip.InitImageChip( '',
							iChip, 
							ImagePaths[iChip], 
							string(iChip), 
							GetChipX(iCol), 
							GetChipY(iRow), 
							class'UIImageChip'.default.width, 
							iRow, 
							iCol,
							OnPreviewImage, 
							OnAcceptImage);
		Chip.OnMouseEventDelegate = OnChildMouseEvent;
		if( bAnimateChips )
				Chip.AnimateIn(iChip * (class'UIUtilities'.const.INTRO_ANIMATION_DELAY_PER_INDEX / 2));
		ImageChips.AddItem(Chip);
	}
	//Save height to use for the mask/scrollbar comparison 
	ChipHeight = GetChipY(iRow) + class'UIImageChip'.default.height; 

	// Hook up navigation ---------------------------------------------
	for( iChip = 0; iChip < ImageChips.Length; iChip++ )
	{
		Chip = ImageChips[iChip];

		LeftNavTargetChip = none; 
		RightNavTargetChip = none; 
		UpNavTargetChip = none; 
		DownNavTargetChip = none; 

		iLastRowLength = ImageChips.length % iMaxChipsPerRow; 

		iOffset = iChip % iMaxChipsPerRow;

		// LEFT - RIGHT -------------------------------------------------
		if( Chip.Col == 0 ) // Left column
		{
			// In the last row, the left chip needs to wrap to the last chip, 
			// regardless of width of that last row which may be an incomplete row. 
			if( Chip.index >= ImageChips.Length - iMaxChipsPerRow ) 
				LeftNavTargetChip = ImageChips[ImageChips.length-1];
			else
				LeftNavTargetChip = ImageChips[iChip + iMaxChipsPerRow - 1];
		}
		else if( Chip.Col == iMaxChipsPerRow - 1 )// right column 
			RightNavTargetChip = ImageChips[iChip - iMaxChipsPerRow+1];
		else if( Chip.index == ImageChips.length-1 )
			RightNavTargetChip = ImageChips[iChip - iLastRowLength+1];

		
		if( LeftNavTargetChip == none )
			LeftNavTargetChip = ImageChips[iChip-1];
		if( RightNavTargetChip  == none )
			RightNavTargetChip = ImageChips[iChip+1];

		Chip.Navigator.AddNavTargetLeft( LeftNavTargetChip );
		Chip.Navigator.AddNavTargetRight( RightNavTargetChip );

		// UP - DOWN -------------------------------------------------
		
		if( Chip.Row == 0 ) // first row 
		{
			if( iOffset >= iLastRowLength )
				UpNavTargetChip = ImageChips[ ImageChips.Length - iLastRowLength - iMaxChipsPerRow + iOffset ];
			else
				UpNavTargetChip = ImageChips[ ImageChips.Length - iLastRowLength  + iOffset ];
		}
		else if( Chip.index >=ImageChips.Length - iMaxChipsPerRow) // last edge, may wrap row 
		{
			DownNavTargetChip = ImageChips[ iOffset ];
		}

		if( UpNavTargetChip == none )
			UpNavTargetChip = ImageChips[iChip-iMaxChipsPerRow];
		if( DownNavTargetChip == none )
			DownNavTargetChip = ImageChips[iChip+iMaxChipsPerRow];

		Chip.Navigator.AddNavTargetUp( UpNavTargetChip );
		Chip.Navigator.AddNavTargetDown( DownNavTargetChip );
		
	}

	RealizeMaskAndScrollbar();
	SetInitialSelection();
}

simulated function SetInitialSelection()
{
	if (ImageChips.Length > 0)
	{
		if (InitialSelection > -1 && InitialSelection < ImageChips.Length )
		{
				ChipContainer.Navigator.SetSelected(ImageChips[InitialSelection]);
		}
		else
		{
			ChipContainer.Navigator.SetSelected(ImageChips[0]);
		}
	}
}

simulated function float GetChipX( int iCol )
{
	return ((class'UIImageChip'.default.width + ITEM_PADDING) * iCol) + (EDGE_PADDING); 
}

simulated function float GetChipY( int iRow )
{
	return ((class'UIImageChip'.default.height + ITEM_PADDING) * iRow) + (EDGE_PADDING); 
}

simulated function array<string> GenerateRandomImages()
{
	local array<string> NewImages; 

	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_StasisLanced  );
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Stunned		  );
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Unconscious	  );
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_MindControlled);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Haywire		  );
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Berserk		  );

	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_StasisLanced);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Stunned);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Unconscious);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Haywire);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Berserk);

	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Burning);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Disoriented);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Poisoned);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Bound);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Panicked);
	
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_StasisLanced);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Stunned);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Unconscious);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_MindControlled);

	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Burning);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Poisoned);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Bound);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Panicked);

	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Haywire);
	NewImages.AddItem(class'UIUtilities_Image'.const.UnitStatus_Berserk);
		
	return NewImages; 
}


simulated function OnPreviewImage(int iIndex)
{
	if(OnPreviewDelegate != none)
		OnPreviewDelegate( iIndex );
}

simulated function OnAcceptImage(int iIndex)
{
	if(OnSetDelegate != none)
		OnSetDelegate( iIndex );
}

simulated function OnCancelImage()
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
