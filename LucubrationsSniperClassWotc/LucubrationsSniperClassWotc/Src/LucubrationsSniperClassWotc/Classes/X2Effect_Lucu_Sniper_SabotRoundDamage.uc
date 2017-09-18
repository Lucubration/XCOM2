class X2Effect_Lucu_Sniper_SabotRoundDamage extends X2Effect_Persistent;

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local XComGameState_Item SourceWeapon;
	local int Pierce, Tier;
	
	if (AbilityState.GetMyTemplateName() == class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundAbilityName ||
		AbilityState.GetMyTemplateName() == class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundSetUpAbilityName)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
        {
            Tier = SourceWeapon.GetMyTemplate().Tier;
            // Some custom weapons seem to have really outlandish weapon tiers. Always give them the average damage bonus?
            if (Tier >= class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundArmorPenetration.Length)
            {
                Tier = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundArmorPenetration.Length / 2;
            }
			Pierce = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundArmorPenetration[Tier];
        }
	}

	return Pierce;
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local int ExtraDamage, Tier;
	
	if (AbilityState.GetMyTemplateName() == class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundAbilityName ||
		AbilityState.GetMyTemplateName() == class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundSetUpAbilityName)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
        {
            Tier = SourceWeapon.GetMyTemplate().Tier;
            // Some custom weapons seem to have really outlandish weapon tiers. Always give them the average damage bonus?
            if (Tier >= class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundDamageBonus.Length)
            {
                Tier = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundDamageBonus.Length / 2;
            }
			ExtraDamage = class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundDamageBonus[Tier];
        }
	}

	return ExtraDamage;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local GameRulesCache_VisibilityInfo VisInfo;
	local int BonusAim, TileDistance;
	local TTile UnitTileLocation, TargetTileLocation;
	local bool bShouldAddAngleToCoverBonus;
	local ECoverType NextTileOverCoverType;
	local float CoverValue, AngleToCoverModifier, Alpha;
	local ShotModifierInfo AccuracyInfo;
	
	if (AbilityState.GetMyTemplateName() == class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundAbilityName ||
		AbilityState.GetMyTemplateName() == class'X2Ability_Lucu_Sniper_SniperAbilitySet'.default.SabotRoundSetUpAbilityName)
	{
		// Copy of cover calculations from X2AbilityToHitCalc_StandardAim
		if (Attacker != none && Target != none)
		{
			if (!bIndirectFire)
			{
				if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
				{	
					if (Target.CanTakeCover())
					{
						if (VisInfo.TargetCover != CT_None)
						{
							switch (VisInfo.TargetCover)
							{
								case CT_MidLevel:
									BonusAim = class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS;
									CoverValue = class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS;
									break;
								case CT_Standing:           //  full cover
									BonusAim = class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS;
									CoverValue = class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS;
									break;
							}

							TileDistance = Attacker.TileDistanceBetween(Target);

							// from Angle 0 -> MIN_ANGLE_TO_COVER, receive full MAX_ANGLE_BONUS_MOD
							// As Angle increases from MIN_ANGLE_TO_COVER -> MAX_ANGLE_TO_COVER, reduce bonus received by lerping MAX_ANGLE_BONUS_MOD -> MIN_ANGLE_BONUS_MOD
							// Above MAX_ANGLE_TO_COVER, receive no bonus

							//`assert(VisInfo.TargetCoverAngle >= 0); // if the target has cover, the target cover angle should always be greater than 0
							if (VisInfo.TargetCoverAngle < class'X2AbilityToHitCalc_StandardAim'.default.MAX_ANGLE_TO_COVER &&
								TileDistance <= class'X2AbilityToHitCalc_StandardAim'.default.MAX_TILE_DISTANCE_TO_COVER)
							{
								bShouldAddAngleToCoverBonus = (Attacker.GetTeam() == eTeam_XCom);

								// We have to avoid the weird visual situation of a unit standing behind low cover 
								// and that low cover extends at least 1 tile in the direction of the attacker.
								if ((class'X2AbilityToHitCalc_StandardAim'.default.SHOULD_DISABLE_BONUS_ON_ANGLE_TO_EXTENDED_LOW_COVER && VisInfo.TargetCover == CT_MidLevel) ||
									(class'X2AbilityToHitCalc_StandardAim'.default.SHOULD_ENABLE_PENALTY_ON_ANGLE_TO_EXTENDED_HIGH_COVER && VisInfo.TargetCover == CT_Standing))
								{
									Attacker.GetKeystoneVisibilityLocation(UnitTileLocation);
									Target.GetKeystoneVisibilityLocation(TargetTileLocation);
									NextTileOverCoverType = NextTileOverCoverInSameDirection(UnitTileLocation, TargetTileLocation);

									if (class'X2AbilityToHitCalc_StandardAim'.default.SHOULD_DISABLE_BONUS_ON_ANGLE_TO_EXTENDED_LOW_COVER && VisInfo.TargetCover == CT_MidLevel && NextTileOverCoverType == CT_MidLevel)
									{
										bShouldAddAngleToCoverBonus = false;
									}
									else if (class'X2AbilityToHitCalc_StandardAim'.default.SHOULD_ENABLE_PENALTY_ON_ANGLE_TO_EXTENDED_HIGH_COVER && VisInfo.TargetCover == CT_Standing && NextTileOverCoverType == CT_Standing)
									{
										bShouldAddAngleToCoverBonus = false;

										Alpha = FClamp((VisInfo.TargetCoverAngle - class'X2AbilityToHitCalc_StandardAim'.default.MIN_ANGLE_TO_COVER) / (class'X2AbilityToHitCalc_StandardAim'.default.MAX_ANGLE_TO_COVER - class'X2AbilityToHitCalc_StandardAim'.default.MIN_ANGLE_TO_COVER), 0.0, 1.0);
										AngleToCoverModifier = Lerp(
											class'X2AbilityToHitCalc_StandardAim'.default.MAX_ANGLE_PENALTY,
											class'X2AbilityToHitCalc_StandardAim'.default.MIN_ANGLE_PENALTY,
											Alpha);
										BonusAim -= Round(-1.0 * AngleToCoverModifier);
									}
								}

								if (bShouldAddAngleToCoverBonus)
								{
									Alpha = FClamp((VisInfo.TargetCoverAngle - class'X2AbilityToHitCalc_StandardAim'.default.MIN_ANGLE_TO_COVER) / (class'X2AbilityToHitCalc_StandardAim'.default.MAX_ANGLE_TO_COVER - class'X2AbilityToHitCalc_StandardAim'.default.MIN_ANGLE_TO_COVER), 0.0, 1.0);
									AngleToCoverModifier = Lerp(
										class'X2AbilityToHitCalc_StandardAim'.default.MAX_ANGLE_BONUS_MOD,
										class'X2AbilityToHitCalc_StandardAim'.default.MIN_ANGLE_BONUS_MOD,
										Alpha);
									BonusAim -= Round(CoverValue * AngleToCoverModifier);
								}
							}
						}
					}
				}
			}
		}
	}

	if (BonusAim > 0)
	{
		AccuracyInfo.ModType = eHit_Success;
		AccuracyInfo.Value = BonusAim;
		AccuracyInfo.Reason = FriendlyName;
		ShotModifiers.AddItem(AccuracyInfo);
	}
}

// Copy this because it isn't static in X2AbilityToHitCalc_StandardAim
function ECoverType NextTileOverCoverInSameDirection(const out TTile SourceTile, const out TTile DestTile)
{
	local TTile TileDifference, AdjacentTile;
	local XComWorldData WorldData;
	local int AnyCoverDirectionToCheck, LowCoverDirectionToCheck, CornerCoverDirectionToCheck, CornerLowCoverDirectionToCheck;
	local TileData AdjacentTileData, DestTileData;
	local ECoverType BestCover;

	WorldData = `XWORLD;

	AdjacentTile = DestTile;

	TileDifference.X = SourceTile.X - DestTile.X;
	TileDifference.Y = SourceTile.Y - DestTile.Y;

	if( Abs(TileDifference.X) > Abs(TileDifference.Y) )
	{
		if( TileDifference.X > 0 )
		{
			++AdjacentTile.X;

			CornerCoverDirectionToCheck = WorldData.COVER_West;
			CornerLowCoverDirectionToCheck = WorldData.COVER_WLow;
		}
		else
		{
			--AdjacentTile.X;

			CornerCoverDirectionToCheck = WorldData.COVER_East;
			CornerLowCoverDirectionToCheck = WorldData.COVER_ELow;
		}

		if( TileDifference.Y > 0 )
		{
			AnyCoverDirectionToCheck = WorldData.COVER_North;
			LowCoverDirectionToCheck = WorldData.COVER_NLow;
		}
		else
		{
			AnyCoverDirectionToCheck = WorldData.COVER_South;
			LowCoverDirectionToCheck = WorldData.COVER_SLow;
		}
	}
	else
	{
		if( TileDifference.Y > 0 )
		{
			++AdjacentTile.Y;

			CornerCoverDirectionToCheck = WorldData.COVER_North;
			CornerLowCoverDirectionToCheck = WorldData.COVER_NLow;
		}
		else
		{
			--AdjacentTile.Y;

			CornerCoverDirectionToCheck = WorldData.COVER_South;
			CornerLowCoverDirectionToCheck = WorldData.COVER_SLow;
		}

		if( TileDifference.X > 0 )
		{
			AnyCoverDirectionToCheck = WorldData.COVER_West;
			LowCoverDirectionToCheck = WorldData.COVER_WLow;
		}
		else
		{
			AnyCoverDirectionToCheck = WorldData.COVER_East;
			LowCoverDirectionToCheck = WorldData.COVER_ELow;
		}
	}

	WorldData.GetTileData(DestTile, DestTileData);

	BestCover = CT_None;

	if( (DestTileData.CoverFlags & CornerCoverDirectionToCheck) != 0 )
	{
		if( (DestTileData.CoverFlags & CornerLowCoverDirectionToCheck) == 0 )
		{
			// high corner cover
			return CT_Standing;
		}
		else
		{
			// low corner cover - still need to check for high adjacent cover
			BestCover = CT_MidLevel;
		}
	}
	
	if( !WorldData.IsTileFullyOccupied(AdjacentTile) ) // if the tile is fully occupied, it won't have cover information - we need to check the corner cover value instead
	{
		WorldData.GetTileData(AdjacentTile, AdjacentTileData);

		// cover flags are valid - if they don't provide ANY cover in the specified direction, return CT_None
		if( (AdjacentTileData.CoverFlags & AnyCoverDirectionToCheck) != 0 )
		{
			// if the cover flags in the specified direction don't have the low cover flag, then it is high cover
			if( (AdjacentTileData.CoverFlags & LowCoverDirectionToCheck) == 0 )
			{
				// high adjacent cover
				BestCover = CT_Standing;
			}
			else
			{
				// low adjacent cover
				BestCover = CT_MidLevel;
			}
		}
	}
	else
	{
		// test if the adjacent tile is occupied because it is the base of a ramp
		++AdjacentTile.Z;
		if( WorldData.IsRampTile(AdjacentTile) )
		{
			BestCover = CT_Standing;
		}
	}

	return BestCover;
}
