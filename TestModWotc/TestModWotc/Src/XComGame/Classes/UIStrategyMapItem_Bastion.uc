//---------------------------------------------------------------------------------------
//  FILE:   UIStrategyMapItem_Bastion.uc
//  AUTHOR:  Mark Nauta  --  04/29/2016
//  PURPOSE: This object represents the UI map item for a Bastion on the world map 
//           in the XCOM 2 strategy game
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UIStrategyMapItem_Bastion extends UIStrategyMapItem;

var string CurrentMaterialPath;

//---------------------------------------------------------------------------------------
simulated function UIStrategyMapItem InitMapItem(out XComGameState_GeoscapeEntity Entity)
{
	super.InitMapItem(Entity);
	UpdateMaterial();

	return self;
}


//---------------------------------------------------------------------------------------
function UpdateFlyoverText()
{
	local XComGameState_Bastion BastionState;

	BastionState = XComGameState_Bastion(`XCOMHISTORY.GetGameStateForObjectID(GeoscapeEntityRef.ObjectID));
	SetLabel(BastionState.GetMyTemplate().DisplayName);
}

//---------------------------------------------------------------------------------------
event UpdateVisuals(bool bOnScreen)
{
	super.UpdateVisuals(bOnScreen);
	UpdateMaterial();
}

//---------------------------------------------------------------------------------------
function UpdateMaterial()
{
	local XComGameState_Bastion BastionState;
	local string DesiredMaterialPath;
	local MaterialInstanceConstant NewMaterial, NewMIC;
	local Object MaterialObject;
	local int idx;

	BastionState = XComGameState_Bastion(`XCOMHISTORY.GetGameStateForObjectID(GeoscapeEntityRef.ObjectID));

	if(BastionState.IsFactionControlled())
	{
		DesiredMaterialPath = "UI_3D.Overwold_Final.MIC_Green";
	}
	else if(BastionState.IsChosenControlled())
	{
		DesiredMaterialPath = "UI_3D.Overwold_Final.MIC_Red";
	}
	else
	{
		DesiredMaterialPath = "UI_3D.Overwold_Final.MIC_Blue";
	}

	if(CurrentMaterialPath != DesiredMaterialPath)
	{
		CurrentMaterialPath = DesiredMaterialPath;

		MaterialObject = `CONTENT.RequestGameArchetype(DesiredMaterialPath);

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
}

DefaultProperties
{
}