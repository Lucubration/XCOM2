
class X2Photobooth_TacticalLocationController extends Object
	native(Core);

var array<XComGroupSpawn> m_arrAllExits;
var int m_iCurrentStudioIndex;

var XComBlueprint m_kStudio;
var array<Actor> m_kBlueprintActors;

var delegate<OnStudioLoaded>	m_OnStudioLoaded;
delegate OnStudioLoaded();

function GetAllStudioLocations()
{
	local XComGroupSpawn kExit;
	local array<Vector> FloorPoints;
	local int i, minTiles;
	local int minStudioLocations;

	minStudioLocations = 5;

	if (m_arrAllExits.length == 0)
	{
		for (i = 2; i >= 0; --i)
		{
			m_arrAllExits.Length = 0;
			foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'XComGroupSpawn', kExit)
			{
				FloorPoints.Length = 0;
				kExit.GetValidFloorLocationsXYZ(FloorPoints, i + 1, 1);

				minTiles = (i * 2) + 1;
				minTiles = minTiles * minTiles;

				if (FloorPoints.Length >= minTiles)
					m_arrAllExits.AddItem(kExit);
			}

			if (m_arrAllExits.length >= minStudioLocations)
			{
				m_arrAllExits.RandomizeOrder();
				break;
			}
		}
	}
}

function Init(delegate<OnStudioLoaded> delOnStudioLoaded)
{
	GetAllStudioLocations();

	m_OnStudioLoaded = delOnStudioLoaded;
	SpawnStudio();
}

function Cleanup()
{
	if (m_kStudio != none)
	{
		m_kStudio.Destroy();
	}
}

function SpawnStudio()
{
	local XComParcel Obj;
	local XComGroupSpawn SpawnLoc;
	local vector vLookAtExit, vModifiedSpawnLoc;

	SpawnLoc = m_arrAllExits[m_iCurrentStudioIndex];

	if (m_kStudio != none)
	{
		m_kStudio.Destroy();
	}

	Obj = `PARCELMGR.ObjectiveParcel;
	if (Obj != none)
	{
		vLookAtExit = Obj.Location - SpawnLoc.Location;
		vLookAtExit.z = 0;

		m_kStudio = `PHOTOBOOTH.Spawn(class'XComBlueprint');
		vModifiedSpawnLoc = SpawnLoc.Location;
		vModifiedSpawnLoc.Z = `XWORLD.GetFloorZForPosition(SpawnLoc.Location);
		SpawnStudioNative(vModifiedSpawnLoc, rotator(vLookAtExit));
	}
}

native function SpawnStudioNative(vector InLocation, Rotator InRotation);
native function BlueprintLoadedNative();

function NextStudio(delegate<OnStudioLoaded> delOnStudioLoaded)
{
	m_iCurrentStudioIndex = (m_iCurrentStudioIndex + 1) % m_arrAllExits.Length;
	m_OnStudioLoaded = delOnStudioLoaded;

	SpawnStudio();
}

function PreviousStudio(delegate<OnStudioLoaded> delOnStudioLoaded)
{
	m_iCurrentStudioIndex = (m_iCurrentStudioIndex - 1 + m_arrAllExits.Length) % m_arrAllExits.Length;
	m_OnStudioLoaded = delOnStudioLoaded;

	SpawnStudio();
}

event BlueprintLoaded()
{
	if (m_kStudio != none)
		m_kStudio.GetLoadedLevelActors(m_kBlueprintActors);

	if (m_OnStudioLoaded != none)
		m_OnStudioLoaded();
}

function PointInSpace GetFormationPlacementActor()
{
	local int i;
	local PointInSpace PlacementActor;

	for (i = 0; i < m_kBlueprintActors.Length; ++i)
	{
		PlacementActor = PointInSpace(m_kBlueprintActors[i]);
		if (PlacementActor != none && 'BlueprintLocation' == PlacementActor.Tag)
			return PlacementActor;
	}

	return none;
}

function CameraActor GetCameraActor()
{
	local CameraActor CamActor;
	local int i;

	for (i = 0; i < m_kBlueprintActors.length; i++)
	{
		CamActor = CameraActor(m_kBlueprintActors[i]);
		if (CamActor != none && string(CamActor.Tag) == "CameraPhotobooth")
			return CamActor;
	}

	return none;
}