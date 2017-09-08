class XComGameState_Lucu_Infantry_Effect_ZoneOfControl extends XComGameState_BaseObject
	config (LucubrationsInfantryClassWotc);

var name AbilityToActivate;	// Deprecated
var name ActionPointName;	// Deprecated
var int ReactionFireRadius;	// Deprecated

var StateObjectReference ShooterRef;
var privatewrite array<StateObjectReference> ReactionFireTargets;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Lucubration Infantry Class: Zone of Control 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;

	EventManager.UnRegisterFromEvent(ListenerObj, 'ObjectMoved');
	EventManager.UnRegisterFromEvent(ListenerObj, 'UnitMoveFinished');
	EventManager.UnRegisterFromEvent(ListenerObj, 'PlayerTurnEnded');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Zone of Control states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Lucubration Infantry Class: Zone of Control passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local X2AbilityTemplate EventAbilityTemplate;
	local StateObjectReference ActiveAbilityRef;
	local XComGameStateContext_Ability EventAbilityContext;
	local XComGameState_Ability ActiveAbilityState;
	local XComGameState_Unit Shooter, Target;
	local GameRulesCache_Unit UnitCache;
	local int TargetDistanceInTiles, i, j;
	local name CanShootCode;
	local XComGameState NewGameState;
	
	History = `XCOMHISTORY;
	
	//`LOG("Lucubration Infantry Class: Zone of Control 'AbilityActivated' event listener delegate invoked.");
	
	// Grab the ability context
	EventAbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (EventAbilityContext == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated (no ability context).");

		return ELR_NoInterrupt;
	}
	
	EventAbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(EventAbilityContext.InputContext.AbilityTemplateName);
	if (EventAbilityTemplate == none)
	{
		//`LOG("Lucubration Infantry Class: Stick and Move not activated by ability " @ string(EventAbilityTemplate.DataName) @ " (no ability template).");

		return ELR_NoInterrupt;
	}
	
	// Grab the ability source unit (which we will designate "target" because we're considering trying to shoot them)
	Target = XComGameState_Unit(GameState.GetGameStateForObjectID(EventAbilityContext.InputContext.SourceObject.ObjectID));
	if (Target == none)
		Target = XComGameState_Unit(History.GetGameStateForObjectID(EventAbilityContext.InputContext.SourceObject.ObjectID));
	if (Target == none)
	{
		//`LOG("Lucubration Infantry Class: Zone of Control not activated (no target).");

		return ELR_NoInterrupt;
	}
	
	// Grab the shooter unit
	Shooter = XComGameState_Unit(GameState.GetGameStateForObjectID(ShooterRef.ObjectID));
	if (Shooter == none)
		Shooter = XComGameState_Unit(History.GetGameStateForObjectID(ShooterRef.ObjectID));
	if (Shooter == none)
	{
		//`LOG("Lucubration Infantry Class: Zone of Control not activated against unit " @ Target.GetFullName() @ " (no shooter).");

		return ELR_NoInterrupt;
	}

	// Check if the target is an enemy to the shooter
	if (!Shooter.TargetIsEnemy(Target.ObjectID))
	{
		//`LOG("Lucubration Infantry Class: Zone of Control not activated by unit " @ Shooter.GetFullName() @ " against unit " @ Target.GetFullName() @ " (not an enemy).");

		return ELR_NoInterrupt;
	}

	// Check if this is an offensive ability or has a movement component
	if (EventAbilityTemplate.Hostility != eHostility_Offensive &&
		EventAbilityContext.InputContext.MovementPaths.Length == 0)
	{
		//`LOG("Lucubration Infantry Class: Zone of Control not activated by unit " @ Shooter.GetFullName() @ " against unit " @ Target.GetFullName() @ " (ability is not offensive or movement).");

		return ELR_NoInterrupt;
	}

	TargetDistanceInTiles = Shooter.TileDistanceBetween(Target);

	// Check if we should counterattack
	if (TargetDistanceInTiles <= 1 &&
		EventAbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt &&
		X2AbilityToHitCalc_StandardAim(EventAbilityTemplate.AbilityToHitCalc) != none &&
		X2AbilityToHitCalc_StandardAim(EventAbilityTemplate.AbilityToHitCalc).bMeleeAttack &&
		EventAbilityContext.InputContext.PrimaryTarget.ObjectID == Shooter.ObjectID &&
		(EventAbilityContext.ResultContext.HitResult == eHit_Miss || EventAbilityContext.ResultContext.HitResult == eHit_Graze) &&
		!Shooter.IsImpaired())
	{
	
    	//`LOG("Lucubration Infantry Class: Zone of Control observing a melee attack against us (" @ EventAbilityTemplate.DataName @ ").");

		// New branch in logic, manually triggering the counterattack on miss/graze instead of using an event listener
		ActiveAbilityRef = Shooter.FindAbility(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlCounterAttackAbilityName);
		if (ActiveAbilityRef.ObjectID != 0)
		{
			// Give the unit an action point so they can activate counterattack
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			Shooter = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', ShooterRef.ObjectID));
			Shooter.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);
			NewGameState.AddStateObject(Shooter);
			
			`TACTICALRULES.SubmitGameState(NewGameState);
		
			// Find the available action corresponding to the Zone of Control counterattack
			if (`TACTICALRULES.GetGameRulesCache_Unit(ShooterRef, UnitCache))
			{
    	        //`LOG("Lucubration Infantry Class: Zone of Control found shooter unit cache.");

				for (i = 0; i < UnitCache.AvailableActions.Length; ++i)
				{
					if (UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == ActiveAbilityRef.ObjectID)
					{
    	                //`LOG("Lucubration Infantry Class: Zone of Control found counterattack action.");

						for (j = 0; j < UnitCache.AvailableActions[i].AvailableTargets.Length; ++j)
						{
							if (UnitCache.AvailableActions[i].AvailableTargets[j].PrimaryTarget == EventAbilityContext.InputContext.SourceObject)
							{
        	                    //`LOG("Lucubration Infantry Class: Zone of Control found counterattack target (" @ Target.GetFullName() @ ").");

								if (UnitCache.AvailableActions[i].AvailableCode == 'AA_Success')
								{
									// Activate it
									class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], j);

									//`LOG("Lucubration Infantry Class: Zone of Control triggered counterattack against " @ Target.GetFullName() @ ".");
		
									return ELR_NoInterrupt;
								}
                                else
                                {
									//`LOG("Lucubration Infantry Class: Zone of Control counterattack against " @ Target.GetFullName() @ " not triggered (" @ string(UnitCache.AvailableActions[i].AvailableCode) @ ").");
                                }
								break;
							}
						}
   	                    //`LOG("Lucubration Infantry Class: Zone of Control failed to find counterattack target.");
						break;
					}
				}
   	            //`LOG("Lucubration Infantry Class: Zone of Control failed to find counterattack action.");
			}
            else
            {
    	        //`LOG("Lucubration Infantry Class: Zone of Control failed to find shooter unit cache.");
            }
		}
	}
	
	//`LOG("Lucubration Infantry Class: Zone of Control observing something other than melee attack against us (" @ EventAbilityTemplate.DataName @ ").");

	// We now only shoot a limited number of times per turn (outside of counterattacks).
	// Look for the array length in addition to uniqueness
	if (ReactionFireTargets.Length >= class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlReactionFireShotsPerTurn ||
		ReactionFireTargets.Find('ObjectID', Target.ObjectID) != INDEX_NONE)
	{
		//`LOG("Lucubration Infantry Class: Zone of Control not activated (Zone of Control reaction fire unit limit reached).");

		return ELR_NoInterrupt;
	}
		
	// Check range from shooter to target. Radius in config is given in tiles
	if (TargetDistanceInTiles > class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlReactionFireRadius)
	{
		//`LOG("Lucubration Infantry Class: Zone of Control not activated by unit " @ Shooter.GetFullName() @ " against unit " @ Target.GetFullName() @ " (out of range, " @ string(TargetDistanceInTiles) @ " > " @ string(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlReactionFireRadius) @ ").");

		return ELR_NoInterrupt;
	}

	ActiveAbilityRef = Shooter.FindAbility(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlReactionFireAbilityName);

	ActiveAbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(ActiveAbilityRef.ObjectID));
	if (ActiveAbilityState == none)
		ActiveAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ActiveAbilityRef.ObjectID));
	if (ActiveAbilityState == none)
	{
		//`LOG("Lucubration Infantry Class: Zone of Control not activated by unit " @ Shooter.GetFullName() @ " against unit " @ Target.GetFullName() @ " (no reaction fire ability).");

		return ELR_NoInterrupt;
	}
	
	//`LOG("Lucubration Infantry Class: Zone of Control adding action point to unit " @ Shooter.GetFullName() @ ".");
	
	// Grant an ability point for the shooter
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	Shooter = XComGameState_Unit(NewGameState.CreateStateObject(Shooter.Class, Shooter.ObjectID));
	Shooter.ReserveActionPoints.AddItem(class'X2Ability_Lucu_Infantry_InfantryAbilitySet'.default.ZoneOfControlActionPointName);
	NewGameState.AddStateObject(Shooter);
	
	CanShootCode = ActiveAbilityState.CanActivateAbilityForObserverEvent(Target, Shooter);
	if (CanShootCode != 'AA_Success')
	{
		//`LOG("Lucubration Infantry Class: Zone of Control not activated by unit " @ Shooter.GetFullName() @ " against unit " @ Target.GetFullName() @ " (shooter can't fire at this unit: " @ string(CanShootCode) @ ").");
			
		// If the unit can't activate the ability, pick up our toys and go home
		History.CleanupPendingGameState(NewGameState);

		return ELR_NoInterrupt;
	}
	
	`TACTICALRULES.SubmitGameState(NewGameState);

	//`LOG("Lucubration Infantry Class: Zone of Control reaction fire action point added to unit " @ Shooter.GetFullName() @ ".");
	
	ReactionFireTargets.AddItem(Target.GetReference());

	//`LOG("Lucubration Infantry Class: Zone of Control reaction fire target added " @ Target.GetFullName() @ ".");
	
	return ELR_NoInterrupt;
}

function int TileDistanceBetween(const out XComGameState_Unit Unit, const out TTile TileLocation)
{
	local XComWorldData WorldData;
	local vector UnitLoc, TargetLoc;
	local float Dist;
	local int Tiles;

	if (Unit.TileLocation == TileLocation)
		return 0;

	WorldData = `XWORLD;
	UnitLoc = WorldData.GetPositionFromTileCoordinates(Unit.TileLocation);
	TargetLoc = WorldData.GetPositionFromTileCoordinates(TileLocation);
	Dist = VSize(UnitLoc - TargetLoc);
	Tiles = Dist / WorldData.WORLD_StepSize;      //@TODO gameplay - surely there is a better check for finding the number of tiles between two points
	return Tiles;
}

function EventListenerReturn OnPlayerTurnEnded(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	//`LOG("Lucubration Infantry Class: Zone of Control 'PlayerTurnEnded' event listener delegate invoked.");
	
	// We only care about the human player's turn, not the AI's
	if (`TACTICALRULES.GetLocalClientPlayerObjectID() != XComGameState_Player(EventSource).ObjectID)
		return ELR_NoInterrupt;

	// Just to make sure we didn't miss anything, we're going to clear our reaction fire targets after every turn
	ReactionFireTargets.Length = 0;
	
	//`LOG("Lucubration Infantry Class: Zone of Control targets cleared.");

	return ELR_NoInterrupt;
}
