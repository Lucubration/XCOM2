class UIPhotoboothMovie extends UIMovie_2D;

var int PhotoboothDimensionX, PhotoboothDimensionY;

simulated function InitMovie(XComPresentationlayerBase InitPres)
{
	Pres = InitPres;	

	//---------------------------------------------

	ConsoleType = CONSOLE_Any;

	//---------------------------------------------

	RenderTextureMode = RTM_AlphaComposite;

	// Kick of Flash loading
	Start();
}

simulated function OnInit()
{
	super(UIMovie).OnInit();

	Pres.OnMovieInitialized();
}

// The order of creating the parameters to send to flash is awkward, because the latter params were added late, 
// and many flash elements depend on the order of the parameters for testing, so I opted to add the new params 
// and keep the awkwardness here, so that all flash testing could stay neat. -bsteiner 6/9/2012
simulated function SetResolutionAndSafeArea()
{
	local ASValue myValue;
	local Array<ASValue> myArray;
	local int RenderedWidth, RenderedHeight, FullWidth, FullHeight;
	local float RenderedAspectRatio, GfxAspectRatio, FullAspectRatio;
	local int AlreadyAdjustedVerticalSafeZone;

	GetScreenDimensions(RenderedWidth, RenderedHeight, RenderedAspectRatio, FullWidth, FullHeight, FullAspectRatio, AlreadyAdjustedVerticalSafeZone);

	myValue.Type = AS_Number;

	m_v2FullscreenDimension.X = PhotoboothDimensionX;
	m_v2FullscreenDimension.Y = PhotoboothDimensionY;

	m_v2ViewportDimension.X = PhotoboothDimensionX;
	m_v2ViewportDimension.Y = PhotoboothDimensionY;

	GfxAspectRatio = float(UI_RES_Y) / float(UI_RES_X);
	
	myValue.n = PhotoboothDimensionX;
	myArray.AddItem(myValue);
	myValue.n = PhotoboothDimensionY;
	myArray.AddItem(myValue);

	m_v2ScaledDimension.X = PhotoboothDimensionX;
	m_v2ScaledDimension.Y = PhotoboothDimensionY;
	
	m_v2ScaledFullscreenDimension.X = UI_RES_X;
	m_v2ScaledFullscreenDimension.Y = UI_RES_Y;

	// Safe area - 
	// * This is the important part, for flash to calculate the actual anchoring placements. 
	// 4/12/2016 bsteiner - removing old console safe frame values that no longer apply to ps4 / xboxone 
	myValue.n = 0.0;  // no safe area
	myArray.AddItem( myValue );

	if( RenderedAspectRatio == GfxAspectRatio || bool(AlreadyAdjustedVerticalSafeZone) ) 
	{
		myValue.n = 0;
		myArray.AddItem( myValue );
		m_v2ScaledOrigin.X = myValue.n; 
		myValue.n = 0;
		myArray.AddItem( myValue );
		m_v2ScaledOrigin.Y = myValue.n; 
	}
	else if( RenderedAspectRatio > GfxAspectRatio ) //taller than normal 
	{
		myValue.n = 0;
		myArray.AddItem( myValue );
		m_v2ScaledOrigin.X = myValue.n; 

		myValue.n = 0 - (0.5 * (m_v2ScaledDimension.Y - PhotoboothDimensionY));
		myArray.AddItem( myValue );
		m_v2ScaledOrigin.Y = myValue.n; 
	}
	else if( RenderedAspectRatio < GfxAspectRatio ) //wider than normal 
	{
		myValue.n = 0 - (0.5 * (m_v2ScaledDimension.X - PhotoboothDimensionX));
		myArray.AddItem( myValue );
		m_v2ScaledOrigin.X = myValue.n; 

		myValue.n = 0; 
		myArray.AddItem( myValue );
		m_v2ScaledOrigin.Y = myValue.n; 
	}
	
	//Set console type directly 
	if (ConsoleType == CONSOLE_PS3)
		myValue.n = 2;	
	else if( ConsoleType == CONSOLE_Xbox360)
		myValue.n = 1;
	else
		myValue.n = 0;	

	myArray.AddItem( myValue );

	// Does the vertical location already have the safe zone accounted for? 
	myValue.Type = AS_Boolean;
	myValue.b = bool(AlreadyAdjustedVerticalSafeZone);	
	myArray.AddItem( myValue );

	`log( "SetResolutionAndSafeArea: " ,,'uixcom');
	`log( "REZ_X:   "$ myArray[0].n,,'uixcom');
	`log( "REZ_Y:   "$ myArray[1].n ,,'uixcom');
	`log( "Percent: "$ myArray[2].n ,,'uixcom');
	`log( "X_LOC:   "$ myArray[3].n ,,'uixcom');
	`log( "Y_LOC:   "$ myArray[4].n ,,'uixcom');
	`log( "PLATFORM:"$ myArray[5].n ,,'uixcom');
	`log( "bAlreadyAdjustedVerticalSafeZone: " $AlreadyAdjustedVerticalSafeZone,,'uixcom');

	Invoke(MCPath $ ".SetUIView", myArray);
}

defaultproperties
{
	UI_RES_X = 800;
	UI_RES_Y = 1200;
	PhotoboothDimensionX = 800;
	PhotoboothDimensionY = 1200;
	
	MCPath = "_level0.thePhotoboothInterfaceMgr";
	MovieInfo = SwfMovie'gfxXPACK_PhotoboothInterfaceMgr.XPACK_PhotoboothInterfaceMgr';

	bIsVisible = true;
	bAdjustToFullRenderViewport = false
}