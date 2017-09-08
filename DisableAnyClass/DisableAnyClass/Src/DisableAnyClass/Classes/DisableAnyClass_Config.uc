class DisableAnyClass_Config extends Object
	config(DisableAnyClass);

var config array<name>						ClassNames;

var() DisableAnyClass_ClassValuesCollection	ClassValues;

static function InitClassValues()
{
	local X2SoldierClassTemplateManager		ClassTemplateManager;
	local X2SoldierClassTemplate			ClassTemplate;
	local DisableAnyClass_ClassValues		ClassValue;
	local int								i;

	if (!default.ClassValues.Initialized)
	{
		ClassTemplateManager = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();

		for (i = 0; i < default.ClassNames.Length; i++)
		{
			ClassTemplate = ClassTemplateManager.FindSoldierClassTemplate(default.ClassNames[i]);
			if (ClassTemplate != none)
			{
				//ClassValue.NumInForcedDeck = ClassTemplate.NumInForcedDeck;
				ClassValue.NumInDeck = ClassTemplate.NumInDeck;

				default.ClassValues.Items.AddItem(ClassValue);

				//ClassTemplate.NumInForcedDeck = 0;
				ClassTemplate.NumInDeck = 0;
			}
			else
			{
				// They must have removed a disabled class. Drop it from the names list
				`LOG("Disable Any Class: Dropping missing disabled class template " @ string(default.ClassNames[i]) @ ".");

				default.ClassNames.Remove(i, 1);
				i--;
			}
		}

		default.ClassValues.Initialized = true;
	}
}

static function bool IsDisabledClass(name ClassName)
{
	return (default.ClassNames.Find(ClassName) != INDEX_NONE);
}

static function AddDisabledClass(name ClassName)
{
	local X2SoldierClassTemplateManager		ClassTemplateManager;
	local X2SoldierClassTemplate			ClassTemplate;
	local DisableAnyClass_ClassValues		ClassValue;
	local int								i;

	i = default.ClassNames.Find(ClassName);
	if (i != INDEX_NONE)
	{
		`REDSCREEN("Disable Any Class: Found class " @ string(ClassName) @ " already disabled.");
		return;
	}
	
	ClassTemplateManager = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplate = ClassTemplateManager.FindSoldierClassTemplate(ClassName);
	if (ClassTemplate == none)
	{
		`REDSCREEN("Disable Any Class: Couldn't find class template " @ string(ClassName) @ ".");
		return;
	}

	//ClassValue.NumInForcedDeck = ClassTemplate.NumInForcedDeck;
	ClassValue.NumInDeck = ClassTemplate.NumInDeck;

	default.ClassNames.AddItem(ClassName);
	default.ClassValues.Items.AddItem(ClassValue);

	//ClassTemplate.NumInForcedDeck = 0;
	ClassTemplate.NumInDeck = 0;

	`LOG("Disable Any Class: Added disabled class " @ ClassName @ ".");
}

static function RemoveDisabledClass(name ClassName)
{
	local X2SoldierClassTemplateManager		ClassTemplateManager;
	local X2SoldierClassTemplate			ClassTemplate;
	local int								i;

	i = default.ClassNames.Find(ClassName);
	if (i == INDEX_NONE)
	{
		`REDSCREEN("Disable Any Class: Couldn't find disabled class " @ string(ClassName) @ ".");
		return;
	}
	
	ClassTemplateManager = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplate = ClassTemplateManager.FindSoldierClassTemplate(ClassName);
	if (ClassTemplate == none)
	{
		`REDSCREEN("Disable Any Class: Couldn't find disabled class template " @ string(ClassName) @ ".");
		return;
	}

	//ClassTemplate.NumInForcedDeck = default.ClassValues.Items[i].NumInForcedDeck;
	ClassTemplate.NumInDeck = default.ClassValues.Items[i].NumInDeck;

	default.ClassNames.Remove(i, 1);
	default.ClassValues.Items.Remove(i, 1);

	`LOG("Disable Any Class: Removed disabled class " @ ClassName @ ".");
}

DefaultProperties
{
	Begin Object Class=DisableAnyClass_ClassValuesCollection Name=DefaultClassValues
	End Object
	ClassValues=DefaultClassValues;
}
