//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    XComTerrainCaptureControl.uc
//  AUTHOR:  Ken Derda -- 10/20/16
//  PURPOSE: Actor that manages a terrain capture actor and vertex color texture generation.
//			 Terrain capture is used to modify grass color based on the color of the terrain.
//			 Vertex color texture is used to mask out grass from certain parts of the terrain (e.g., water).
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class XComTerrainCaptureControl extends Actor
	config(game)
	native(Graphics)
	placeable;

var bool						m_bInitialized;

var SceneCapture2DComponent		m_kTerrainUnlitColorCapture;
var TextureRenderTarget2D		m_kTerrainUnlitColorTexture;
var SceneCapture2DComponent		m_kTerrainVertexColorCapture;
var TextureRenderTarget2D		m_kTerrainVertexColorTexture;
var Vector						m_kCapturePosition;
var float						m_kOrthoSize;

var private const globalconfig int		XenoformTextureSize;
var private const globalconfig float	XenoformOrthoPadding;
var private const globalconfig bool		XenoformEditorPreview;


final native function InitNative();
final native function CaptureTerrainNative();
final native function ResetCapturesNative();
final native function UpdateGrassMaterialInstances();

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	m_bInitialized = false;
}

defaultproperties
{
	m_bInitialized=false;

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)

	// 2D scene capture 
	Begin Object Class=SceneCapture2DComponent Name=SceneCapture2DComponent0
		bSkipUpdateIfOwnerOccluded=false
		MaxUpdateDist=0.0
		MaxStreamingUpdateDist=0.0
		bUpdateMatrices=false
		NearPlane=10000
		FarPlane=1
	End Object
	m_kTerrainUnlitColorCapture=SceneCapture2DComponent0

	Begin Object Class=SceneCapture2DComponent Name=SceneCapture2DComponent1
		bSkipUpdateIfOwnerOccluded=false
		MaxUpdateDist=0.0
		MaxStreamingUpdateDist=0.0
		bUpdateMatrices=false
		NearPlane=10000
		FarPlane=1
	End Object
	m_kTerrainVertexColorCapture=SceneCapture2DComponent1

	// we are spawned if an instance hasnt been placed in the level so we can't be static or no delete -tsmith 
	bStatic=false
	bNoDelete=false

	// network variables -tsmith
	m_bNoDeleteOnClientInitializeActors=true

	RemoteRole=ROLE_Authority
}

