//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    XComCutoutBox.cpp
//  AUTHOR:  Elliot Pace
//  PURPOSE: This is a box that moves around with the cursor, encapsulating the cutout.  This way
//           we can keep track of all cutout actors and unflag them as necessary.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComCutoutBox extends StaticMeshActor 
	native;

var transient native array<Actor> TouchedActors;

var transient bool m_bEnabled;

var transient vector m_vCameraPosition;

struct native DitherParameters
{
	var float DitherRadius;
	var float DitherFloor;
	var array<Actor> IgnorActors;
};

var transient DitherParameters m_kDitherParameters;

native function MoveCutoutCylinder();

simulated function SetEnabled(bool bEnable)
{
	local int i;

	if (bEnable != m_bEnabled)
	{
		m_bEnabled = bEnable;

		for (i = 0; i < TouchedActors.Length; ++i)
			TouchedActors[i].SetDitherEnable(bEnable);
	}
}

simulated event UpdateCutoutBox(vector CameraPosition, DitherParameters dParameters)
{
	local int i;
	local int idx;

	if (m_bEnabled)
	{
		// In some cases, an actor we want to ignore is already in the touched list from a previous camera. Remove here.
		for (i = TouchedActors.Length - 1; i >= 0; i--)
		{
			idx = dParameters.IgnorActors.Find(TouchedActors[i]);
			if(idx >= 0)
			{
				TouchedActors[i].SetDitherEnable(false);
				TouchedActors.Remove(i, 1);
			}
			else
			{
				TouchedActors[i].SetDitherEnable(true);
			}
		}

		m_vCameraPosition = CameraPosition;
		m_kDitherParameters = dParameters;

		MoveCutoutCylinder();
	}	
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local int Idx;

	super.Touch(Other,OtherComp,Hitlocation,HitNormal);

	Idx = m_kDitherParameters.IgnorActors.Find(Other);
	if (Idx == -1)
	{
		Other.SetDitherEnable(true);
		TouchedActors.AddItem(Other);
	}
}

event UnTouch( Actor Other )
{
	super.UnTouch(Other);

	Other.SetDitherEnable(false);
	TouchedActors.RemoveItem(Other);
}

defaultproperties
{
	bStatic=FALSE
	bWorldGeometry=FALSE
	bMovable=TRUE
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'FX_Visibility.Meshes.ASE_UnitCube'
		bOwnerNoSee=FALSE
		CastShadow=FALSE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		AlwaysCheckCollision=TRUE
		CanBlockCamera=FALSE
		AbsoluteTranslation=FALSE
		AbsoluteRotation=FALSE
		Translation=(X=0.0,Y=0.0,Z=0.0)
		Rotation=(Pitch=0,Yaw=0,Roll=0)
	End Object
	CollisionType=COLLIDE_TouchAll
	bCollideActors=TRUE
	bBlockActors=FALSE
	BlockRigidBody=FALSE
	bHidden=TRUE
	bNoEncroachCheck=true;

	TickGroup=TG_PostAsyncWork
}
