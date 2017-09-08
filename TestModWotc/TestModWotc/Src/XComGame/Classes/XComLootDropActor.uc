//---------------------------------------------------------------------------------------
//  FILE:    XComLootDropActor.uc
//  AUTHOR:  Dan Kaplan  --  10/30/2015
//  PURPOSE: Provides the visualizer for loot drop objects
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComLootDropActor extends DynamicPointInSpace
	implements(X2VisualizationMgrObserverInterface)
	native(Destruction);

// Looting variables
var protected StaticMeshComponent LootMarkerMesh;
var protected StaticMeshComponent PsiLootMarkerMesh;
var protected ParticleSystemComponent PsiLootMarkerEnded;

native function SetLootMarker(bool bVisible, int ExpirationCount, const out TTile TileLocation, bool bUsePsiMarker);
native function UpdateLootMarkersForSelectedUnit(XComGameState_Unit NewActiveUnit);

function InitMaterials()
{
	local int Scan;
	local MaterialInstanceConstant NewMaterial;

	for( Scan = 0; Scan < LootMarkerMesh.GetNumElements(); ++Scan )
	{
		NewMaterial = new(self) class'MaterialInstanceConstant';
		NewMaterial.SetParent(LootMarkerMesh.GetMaterial(Scan));
		LootMarkerMesh.SetMaterial(Scan, NewMaterial);
	}

	for( Scan = 0; Scan < PsiLootMarkerMesh.GetNumElements(); ++Scan )
	{
		NewMaterial = new(self) class'MaterialInstanceConstant';
		NewMaterial.SetParent(PsiLootMarkerMesh.GetMaterial(Scan));
		PsiLootMarkerMesh.SetMaterial(Scan, NewMaterial);
	}
}

event OnActiveUnitChanged(XComGameState_Unit NewActiveUnit)
{
	UpdateLootMarkersForSelectedUnit(NewActiveUnit);
}

event OnVisualizationBlockComplete(XComGameState AssociatedGameState)
{

}

event OnVisualizationIdle()
{

}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=LootMarkerMeshComponent
		HiddenEditor = true
		HiddenGame = true
		HideDuringCinematicView = true
		AbsoluteRotation = true // the billboard shader will break if rotation is in the matrix
		AbsoluteTranslation = true
		StaticMesh = StaticMesh'UI_3D.Waypoint.LootStatus'
	End Object
	Components.Add(LootMarkerMeshComponent)
	LootMarkerMesh = LootMarkerMeshComponent

	Begin Object Class=StaticMeshComponent Name=PsiLootMarkerMeshComponent
		HiddenEditor = true
		HiddenGame = true
		HideDuringCinematicView = true
		AbsoluteRotation = true // the billboard shader will break if rotation is in the matrix
		AbsoluteTranslation = true
		StaticMesh = StaticMesh'UI_3D.Waypoint.Psi_Loot_Status'
	End Object
	Components.Add(PsiLootMarkerMeshComponent)
	PsiLootMarkerMesh = PsiLootMarkerMeshComponent

	Begin Object Class=ParticleSystemComponent Name=PsiLootMarkerParticleSystemComponent
		HiddenEditor = true
		HiddenGame = true
		HideDuringCinematicView = true
		AbsoluteRotation = true // the billboard shader will break if rotation is in the matrix
		AbsoluteTranslation = true
		Template = ParticleSystem'FX_Psi_Loot.P_Psi_Loot_Border_Expired';
	End Object
	Components.Add(PsiLootMarkerParticleSystemComponent)
	PsiLootMarkerEnded = PsiLootMarkerParticleSystemComponent
}