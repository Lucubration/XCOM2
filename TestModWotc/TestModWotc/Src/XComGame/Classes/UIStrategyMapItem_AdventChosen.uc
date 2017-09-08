//---------------------------------------------------------------------------------------
//  FILE:   UIStrategyMapItem_AdventChosen.uc
//  AUTHOR:  Mark Nauta  --  05/10/2016
//  PURPOSE: This object represents the UI map item for an ADVENT Chosen on the world map 
//           in the XCOM 2 strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UIStrategyMapItem_AdventChosen extends UIStrategyMapItem;

//---------------------------------------------------------------------------------------
simulated function UIStrategyMapItem InitMapItem(out XComGameState_GeoscapeEntity Entity)
{
	super.InitMapItem(Entity);
	UpdateMaterial();

	return self;
}

//---------------------------------------------------------------------------------------
function UpdateMaterial()
{
	local string MaterialPath;
	local MaterialInstanceConstant NewMaterial, NewMIC;
	local Object MaterialObject;
	local int idx;


	MaterialPath = "UI_3D.Overwold_Final.MIC_Red";

	MaterialObject = `CONTENT.RequestGameArchetype(MaterialPath);

	if(MaterialObject != none && MaterialObject.IsA('MaterialInstanceConstant'))
	{
		NewMaterial = MaterialInstanceConstant(MaterialObject);
		NewMIC = new class'MaterialInstanceConstant';
		NewMIC.SetParent(NewMaterial);
		MapItem3D.SetMeshMaterial(0, NewMIC);

		for(idx = 0; idx < MapItem3D.NUM_TILES; idx++)
		{
			MapItem3D.ReattachComponent(MapItem3D.OverworldMeshs[idx]);
		}
	}
}

DefaultProperties
{
}