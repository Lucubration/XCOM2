class X2TargetingMethod_Beags_Escalation_Rocket extends X2TargetingMethod_Grenade;

var name FiringAimName, FiringDistanceRatioName;
var vector NewTargetLocation;
var XComGameState_Item WeaponItem;
var X2RocketLauncherTemplate_Beags_Escalation WeaponTemplate;
var float StandardRangeModifier, FiringDistance;
var bool PenetratesCover;
var protected UIText ScatterText;

function Init(AvailableAction InAction)
{
	local float BaseRangeInTiles, ModifiedRangeInTiles;

	super.Init(InAction);
	
	WeaponItem = Ability.GetSourceWeapon();
	WeaponTemplate = X2RocketLauncherTemplate_Beags_Escalation(WeaponItem.GetMyTemplate());

	BaseRangeInTiles = WeaponItem.GetItemRange(Ability);
	ModifiedRangeInTiles = BaseRangeInTiles;
	if (WeaponTemplate != none)
		ModifiedRangeInTiles = WeaponTemplate.ModifyRocketRange(UnitState, Ability, BaseRangeInTiles);

	StandardRangeModifier = ModifiedRangeInTiles / BaseRangeInTiles;
}

function Canceled()
{
	local Beags_Escalation_RocketScatterDisplay EventData;

	super.Canceled();
	
	EventData = new class'Beags_Escalation_RocketScatterDisplay';
	EventData.Show = false;
	`XEVENTMGR.TriggerEvent('Beags_Escalation_RocketScatter', EventData,, none);
}

static function bool UseGrenadePath() { return false; }

function Update(float DeltaTime)
{
	local XComWorldData World;
	local VoxelRaytraceCheckResult Raytrace;
	local array<Actor> CurrentlyMarkedTargets;
	local int Direction, CanSeeFromDefault;
	local UnitPeekSide PeekSide;
	local int OutRequiresLean;
	local TTile PeekTile, UnitTile;
	local bool GoodView;
	local CachedCoverAndPeekData PeekData;
	local array<TTile> Tiles;
	local vector FiringUnitLocation, BlockedPosition, BackPath;
	
	World = `XWORLD;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	NewTargetLocation.Z += World.WORLD_FloorHeight;

	if( NewTargetLocation != CachedTargetLocation )
	{
		GoodView = false;
		FiringUnitLocation = FiringUnit.Location;
		FiringUnitLocation.Z += World.WORLD_FloorHeight;
		if (!PenetratesCover)
		{
			if (World.VoxelRaytrace_Locations(FiringUnitLocation, NewTargetLocation, Raytrace))
			{
				BlockedPosition = Raytrace.TraceBlocked;
				//  check left and right peeks
				FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

				if (PeekSide != eNoPeek)
				{
					UnitTile = World.GetTileCoordinatesFromPosition(FiringUnit.Location);
					PeekData = World.GetCachedCoverAndPeekData(UnitTile);
					if (PeekSide == ePeekLeft)
						PeekTile = PeekData.CoverDirectionInfo[Direction].LeftPeek.PeekTile;
					else
						PeekTile = PeekData.CoverDirectionInfo[Direction].RightPeek.PeekTile;

					if (!World.VoxelRaytrace_Tiles(UnitTile, PeekTile, Raytrace))
						GoodView = true;
					else
						BlockedPosition = Raytrace.TraceBlocked;
				}				

				if (!GoodView)
				{
					// Move the blocked position several units backwards along the path in X and Y dimensions to try to prevent target cursor clipping.
					// This is mostly applicable for non-penetrating rockets like Shredders
					BackPath = FiringUnitLocation - BlockedPosition;
					if (BackPath.X != 0)
						BackPath.X = 10*Abs(BackPath.X / BackPath.X);
					if (BackPath.Y != 0)
						BackPath.Y = 10*Abs(BackPath.Y / BackPath.Y);
					BlockedPosition.X += BackPath.X;
					BlockedPosition.Y += BackPath.Y;
				}
			}		
			else
			{
				GoodView = true;
			}
		}
		else
		{
			GoodView = true;
		}

		if (!GoodView)
		{
			NewTargetLocation = BlockedPosition;
			Cursor.CursorSetLocation(NewTargetLocation);
			//`SHAPEMGR.DrawSphere(LastTargetLocation, vect(25,25,25), MakeLinearColor(1,0,0,1), false);
		}

		// Find the firing distance. Store it for later reference
		FiringUnitLocation = `XWORLD.GetPositionFromTileCoordinates(UnitState.TileLocation);
		FiringDistance = VSize(FiringUnitLocation - NewTargetLocation);

		// Firing distance ratio name is stored on unit state to calculate aim penalty for range
		UnitState.SetUnitFloatValue(default.FiringDistanceRatioName, FiringDistance / Cursor.m_fMaxChainedDistance, eCleanup_BeginTurn);

		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		DrawAOETiles(Tiles);
	}

	super.UpdateTargetLocation(DeltaTime);

	UpdateTacticalHUD(Ability.OwnerStateObject, Ability.GetMyTemplate());
}

// Update the hit/crit percentages on the shot hud. Total hackery
function UpdateTacticalHUD(StateObjectReference Shooter, X2AbilityTemplate AbilityTemplate)
{
	local StateObjectReference Target; // No target
	local ShotBreakdown ShotBreakdown;
	local int HitChance, CritChance;
	local XComPresentationLayer Pres;
	local UITacticalHUD TacticalHUD;
	local UITacticalHUD_ShotHUD ShotHUD;
	local UITacticalHUD_ShotWings ShotWings;

	Pres = XComPresentationLayer(XComPlayerController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController()).Pres);

	//---------------------------------------------------------------------------------------------------
	// ShotHUD
	//---------------------------------------------------------------------------------------------------

	ShotHUD = Pres.m_kTacticalHUD.m_kShotHUD;
	TacticalHUD = UITacticalHUD(ShotHUD.Screen);

	if (AbilityTemplate.AbilityToHitCalc != none && Ability.iCooldown == 0)
	{
		Ability.LookupShotBreakdown(Shooter, Target, Ability.GetReference(), ShotBreakdown);
		HitChance = Clamp(((ShotBreakdown.bIsMultishot) ? ShotBreakdown.MultiShotHitChance : ShotBreakdown.FinalHitChance), 0, 100);
		CritChance = ShotBreakdown.ResultTable[eHit_Crit];

		if (HitChance > -1 && !ShotBreakdown.HideShotBreakdown)
		{
			ShotHUD.AS_SetShotChance(class'UIUtilities_Text'.static.GetColoredText(class'UITacticalHUD_ShotHUD'.default.m_sShotChanceLabel, eUIState_Header), HitChance);
			ShotHUD.AS_SetCriticalChance(class'UIUtilities_Text'.static.GetColoredText(class'UITacticalHUD_ShotHUD'.default.m_sCritChanceLabel, eUIState_Header), CritChance);
			TacticalHUD.SetReticleAimPercentages(float(HitChance) / 100.0f, float(CritChance) / 100.0f);
		}
		else
		{
			ShotHUD.AS_SetShotChance("", -1);
			ShotHUD.AS_SetCriticalChance("", -1);
			TacticalHUD.SetReticleAimPercentages(-1, -1);
		}
	}
	else
	{
		ShotHUD.AS_SetShotChance("", -1);
		ShotHUD.AS_SetCriticalChance("", -1);
	}

	//---------------------------------------------------------------------------------------------------
	// ShotWings
	//---------------------------------------------------------------------------------------------------

	ShotWings = Pres.m_kTacticalHUD.m_kShotInfoWings;
	ShotWings.RefreshData(); // This doesn't seem to work with our rockets
}

simulated protected function Vector GetSplashRadiusCenter()
{
	return NewTargetLocation;
}

simulated protected function DrawSplashRadius()
{
	local Vector Center;
	local float Radius;
	local LinearColor CylinderColor;
	local Beags_Escalation_RocketScatterDisplay EventData;

	Center = GetSplashRadiusCenter();
	Radius = Ability.GetAbilityRadius();
	
	if (ExplosionEmitter != none)
	{
		ExplosionEmitter.SetLocation(Center); // Set initial location of emitter
		ExplosionEmitter.SetDrawScale(Radius / 48.0f);
		ExplosionEmitter.SetRotation( rot(0,0,1) );

		if( !ExplosionEmitter.ParticleSystemComponent.bIsActive )
		{
			ExplosionEmitter.ParticleSystemComponent.ActivateSystem();			
		}

		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(0, Name("RadiusColor"), CylinderColor);
		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(1, Name("RadiusColor"), CylinderColor);
	}
	EventData = new class'Beags_Escalation_RocketScatterDisplay';
	EventData.Center = Center;
	EventData.Show = true;
	EventData.StdDev = `UNITSTOTILES(GetScatterStdDev());
	`XEVENTMGR.TriggerEvent('Beags_Escalation_RocketScatter', EventData,, none);
}

function GetTargetLocations(out array<vector> TargetLocations)
{
	NewTargetLocation = GetScatterLocation(NewTargetLocation);

	TargetLocations.Length = 0;
	TargetLocations.AddItem(NewTargetLocation);
}

// Generates a scatter location for this rocket
function Vector GetScatterLocation(vector TargetLocation)
{
	local float StdDev, ScatterDistance, ScatterAngle;
	local vector ScatterLocation;

	StdDev = GetScatterStdDev();

	`LOG("Beags Escalation: Rocket StdDev=" @ string(StdDev));

	// Scatter based on normal distribution
	ScatterDistance = GetScatterLinear(StdDev); // Radius is unreal units
	ScatterAngle = 2.0f * PI * `SYNC_FRAND(); // Angle in radians
	ScatterLocation.X = TargetLocation.X + ScatterDistance * Cos(ScatterAngle);
	ScatterLocation.Y = TargetLocation.Y + ScatterDistance * Sin(ScatterAngle);
	ScatterLocation.Z = TargetLocation.Z;

	`LOG("Beags Escalation: Rocket Scatter Distance=" @ string(ScatterDistance));
	`LOG("Beags Escalation: Rocket Scatter X=" @ string(ScatterLocation.X - TargetLocation.X));
	`LOG("Beags Escalation: Rocket Scatter Y=" @ string(ScatterLocation.Y - TargetLocation.Y));
	
	return ScatterLocation;
}

function float GetScatterStdDev()
{
	local UnitValue Value;
	local float StandardScatter, StandardRange, MaxScatter, ToHit;

	// Use rocket radius and aim penalty to calculate scatter at that distance
	if (UnitState.GetUnitValue(FiringAimName, Value) && Value.fValue > 0)
		ToHit = Value.fValue;

	// Scatter with 0 aim at 20 meters range (LW numbers)
	StandardScatter = 7.8f;
	StandardRange = 20.0f;

	// Weapon overrides standard scatter
	if (WeaponTemplate != none)
		StandardScatter = WeaponTemplate.MaxRocketScatter;

	// Modified max range modifies standard range
	StandardRange *= StandardRangeModifier;

	// Calculate the max scatter in units based on our firing distance compared to the standard distance
	MaxScatter = `METERSTOUNITS(StandardScatter) * FiringDistance / `METERSTOUNITS(StandardRange);

	// Lower than perfect hit introduces scatter. 0 to hit will potentially scatter for the max calculated amount
	return MaxScatter * (100.0f - ToHit) / 100.0f;
}

function float GetScatterLinear(float StdDev)
{
	local float Rand, Scatter;

	// Let's be reasonable, here
	while (Rand <= 0.001f)
		Rand = `SYNC_FRAND();

	// Abbreviated normal distribution
	Scatter = StdDev * Sqrt(-2.0f * Loge(Rand)) * Sin(2.0f * PI * `SYNC_FRAND());

	return Scatter;
}

DefaultProperties
{
	PenetratesCover=false
	FiringDistanceRatioName="Beags_Escalation_RocketFiringDistanceRatio"
	FiringAimName="Beags_Escalation_RocketFiringAim"
}