class DisableAnyClass_Utilities extends Object;

static function CheckXComHQSoldierClassDeck()
{
	local XComGameState								NewGameState;
	local XComGameState_HeadquartersXCom			XComHQ;
	local name										ClassName;
	local bool										UpdatedHQ;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Disable Any Class evaluate XCom HQ class deck");
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	// Initialize the soldier class templates (if it has't been done yet)
	class'DisableAnyClass_Config'.static.InitClassValues();

	// The XCom HQ soldier class deck is not empty. Check if it needs to be trimmed
	foreach XComHQ.SoldierClassDeck(ClassName)
	{
		if (class'DisableAnyClass_Config'.static.IsDisabledClass(ClassName))
		{
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(XComHQ.Class, XComHQ.ObjectID));
			NewGameState.AddStateObject(XComHQ);
			UpdatedHQ = true;

			// Trim the XCom HQ soldier class deck
			TrimXComHQSoldierClassDeck(XComHQ);

			break;
		}
	}

	/*
	// If the Xcom HQ soldier class deck is empty, re-build and trim it
	if (XComHQ.SoldierClassDeck.Length == 0)
	{
		if (!UpdatedHQ)
		{
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(XComHQ.Class, XComHQ.ObjectID));
			NewGameState.AddStateObject(XComHQ);
		}

		// Clear the soldier class distribution so that things aren't weighted heavily towards new classes if added
		XComHQ.SoldierClassDistribution.Length = 0;
		// Clear the soldier class deck so that it will contain only the rebuilt deck
		XComHQ.SoldierClassDeck.Length = 0;
	
		// Rebuild the normal deck for the Xcom HQ
		XComHQ.BuildSoldierClassDeck();

		`LOG("Disable Any Class: Rebuilt Xcom HQ class deck.");

		// Trim any disabled class names from the rebuilt deck
		TrimXComHQSoldierClassDeck(XComHQ);
	}
	*/

	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
}

static function CheckResistanceHQSoldierClassDeck()
{
	local XComGameState								NewGameState;
	local XComGameState_HeadquartersResistance		ResistanceHQ;
	local name										ClassName;
	local bool										UpdatedHQ;
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Disable Any Class evaluate Resistance HQ class deck");
	ResistanceHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();

	// Initialize the soldier class templates (if it has't been done yet)
	class'DisableAnyClass_Config'.static.InitClassValues();

	// Check if the Resistance HQ soldier class deck needs to be trimmed
	foreach ResistanceHQ.SoldierClassDeck(ClassName)
	{
		if (class'DisableAnyClass_Config'.static.IsDisabledClass(ClassName))
		{
			ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(ResistanceHQ.Class, ResistanceHQ.ObjectID));
			NewGameState.AddStateObject(ResistanceHQ);
			UpdatedHQ = true;

			// Trim the Resistance HQ soldier class deck
			TrimResistanceHQSoldierClassDeck(ResistanceHQ);

			break;
		}
	}

	/*
	// If the Resistance HQ soldier class deck is empty, re-build and trim it
	if (ResistanceHQ.SoldierClassDeck.Length == 0)
	{
		if (!UpdatedHQ)
		{
			ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(ResistanceHQ.Class, ResistanceHQ.ObjectID));
			NewGameState.AddStateObject(ResistanceHQ);
		}

		// Clear the soldier class deck so that it will contain only the rebuilt deck
		ResistanceHQ.SoldierClassDeck.Length = 0;

		// Rebuild the normal deck for the Resistance HQ
		ResistanceHQ.BuildSoldierClassDeck();

		`LOG("Disable Any Class: Rebuilt Resistance HQ class deck.");
	
		// Trim any disabled class names from the rebuilt deck
		TrimResistanceHQSoldierClassDeck(ResistanceHQ);
	}
	*/
	
	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
}

static function TrimXComHQSoldierClassDeck(XComGameState_HeadquartersXCom XComHQ)
{
	local array<name> DisabledClassNames;
	local name ClassName;
	local int i;

	DisabledClassNames = class'DisableAnyClass_Config'.default.ClassNames;
	
	// Trim disabled class names from the soldier class deck
	for (i = XComHQ.SoldierClassDeck.Length - 1; i >= 0; i--)
	{
		ClassName = XComHQ.SoldierClassDeck[i];
		if (DisabledClassNames.Find(ClassName) != INDEX_NONE)
		{
			XComHQ.SoldierClassDeck.Remove(i, 1);

			`LOG("Disable Any Class: Trimmed disabled class " @ ClassName @ " from XCom HQ deck.");
		}
	}

	// Trim the soldier class distribution list to prevent weighting from re-building the deck on us afterwards
	for (i = XComHQ.SoldierClassDistribution.Length - 1; i >= 0; i--)
	{
		ClassName = XComHQ.SoldierClassDistribution[i].SoldierClassName;
		if (DisabledClassNames.Find(ClassName) != INDEX_NONE)
		{
			XComHQ.SoldierClassDistribution.Remove(i, 1);

			`LOG("Disable Any Class: Trimmed disabled class " @ ClassName @ " from XCom HQ distribution.");
		}
	}
}

static function TrimResistanceHQSoldierClassDeck(XComGameState_HeadquartersResistance ResistanceHQ)
{
	local array<name> DisabledClassNames;
	local name ClassName;
	local int i;

	DisabledClassNames = class'DisableAnyClass_Config'.default.ClassNames;
	
	for (i = ResistanceHQ.SoldierClassDeck.Length - 1; i >= 0; i--)
	{
		ClassName = ResistanceHQ.SoldierClassDeck[i];
		if (DisabledClassNames.Find(ClassName) != INDEX_NONE)
		{
			ResistanceHQ.SoldierClassDeck.Remove(i, 1);

			`LOG("Disable Any Class: Trimmed disabled class " @ ClassName @ ".");
		}
	}
}
