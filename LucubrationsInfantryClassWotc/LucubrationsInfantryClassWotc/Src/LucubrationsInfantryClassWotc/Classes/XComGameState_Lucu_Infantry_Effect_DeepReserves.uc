class XComGameState_Lucu_Infantry_Effect_DeepReserves extends XComGameState_BaseObject
	config (LucubrationsInfantryClassWotc);
	
var int HealAmountPerTurn;
var int MaxTotalHealAmount;
var float HealDamagePercent;
var name HealthRegeneratedName;
var name DamageTakenName;
var StateObjectReference UnitRef;

function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local X2EventManager EventManager;
	local Object ListenerObj;
    local XComGameState NewGameState;
	
    //`LOG("Lucubration Infantry Class: Deep Reserves 'TacticalGameEnd' event listener delegate invoked.");
	
	EventManager = `XEVENTMGR;

	// Unregister our callbacks
	ListenerObj = self;

	EventManager.UnRegisterFromEvent(ListenerObj, 'UnitTakeEffectDamage');
	EventManager.UnRegisterFromEvent(ListenerObj, 'TacticalGameEnd');
	
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Deep Reserves states cleanup");
	NewGameState.RemoveStateObject(ObjectID);
	`GAMERULES.SubmitGameState(NewGameState);

	`LOG("Lucubration Infantry Class: Deep Reserves passive effect unregistered from events.");
	
	return ELR_NoInterrupt;
}

function EventListenerReturn OnUnitTakeEffectDamage(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local UnitValue						LastEffectDamage, DamageTaken;
	local XComGameState					NewGameState;
	local XComGameState_Unit			Unit;
	
	//`LOG("Lucubration Infantry Class: Deep Reserves 'UnitTakeEffectDamage' event listener delegate invoked.");
	
	// Grab the unit
	Unit = XComGameState_Unit(EventSource);
	if (Unit.ObjectID != UnitRef.ObjectID)
	{
		//`LOG("Lucubration Infantry Class: Deep Reserves not activated (not Deep Reserves unit).");

		return ELR_NoInterrupt;
	}
	
	// Get the damage taken from the effect
	Unit.GetUnitValue('LastEffectDamage', LastEffectDamage);

	// Get the total damage taken counter
	Unit.GetUnitValue(DamageTakenName, DamageTaken);

	// Update the total damage taken counter
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	Unit = XComGameState_Unit(NewGameState.CreateStateObject(Unit.Class, Unit.ObjectID));
	Unit.SetUnitFloatValue(DamageTakenName, DamageTaken.fValue + LastEffectDamage.fValue, eCleanup_BeginTactical);
	NewGameState.AddStateObject(Unit);
	
	`TACTICALRULES.SubmitGameState(NewGameState);
	
	//`LOG("Lucubration Infantry Class: Deep Reserves damage taken by unit " @ Unit.GetFullName() @ " updated to " @ string(DamageTaken.fValue + LastEffectDamage.fValue) @ ".");

	return ELR_NoInterrupt;
}
