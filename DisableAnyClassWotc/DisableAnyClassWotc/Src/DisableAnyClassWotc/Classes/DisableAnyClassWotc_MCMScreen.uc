// Not actually a "screen" or other UI element, this object is instantiated when showing
// the MCM screen for this mod. We do it this way to avoid creating instance-scoped vars
// on the UIScreenListener. Which is bad.
class DisableAnyClassWotc_MCMScreen extends Object;

`include(DisableAnyClassWotc\Src\ModConfigMenuAPI\MCM_API_Includes.uci)
`include(DisableAnyClassWotc\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

var localized string                MCMPageLabel;
var localized string				MCMPageTitle;
var localized string				EnabledClassesGroupTitle;

var MCM_API_SettingsGroup            Group;
var array<X2SoldierClassTemplate>    ClassTemplates;
var array<name>                      ExcludeClassTemplateNames;

function OnInit(UIScreen Screen)
{
    `MCM_API_Register(Screen, ClientModCallback);
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    local MCM_API_SettingsPage Page;
	local X2SoldierClassTemplateManager ClassTemplateManager;
	local X2SoldierClassTemplate ClassTemplate;
	local int i;
    
	`LOG("Disable Any Class: MCM callback invoked; creating mod config page.");

	// If the class template values haven't been initialized yet, do it now
	class'DisableAnyClassWotc_Config'.static.InitClassValues();
	
    Page = ConfigAPI.NewSettingsPage(default.MCMPageLabel);
    Page.SetPageTitle(default.MCMPageTitle);
    Page.SetSaveHandler(SaveButtonClicked);
    
    Group = Page.AddGroup('EnabledClasses', default.EnabledClassesGroupTitle);
    
	ClassTemplateManager = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
    ClassTemplates = ClassTemplateManager.GetAllSoldierClassTemplates();
    
	for (i = ClassTemplates.Length - 1; i >= 0; i--)
	{
		// Some classes shouldn't appear in this list
		if (ExcludeClassTemplateNames.Find(ClassTemplates[i].DataName) != INDEX_NONE || ClassTemplates[i].bMultiplayerOnly || (/*ClassTemplates[i].NumInForcedDeck == 0 &&*/ ClassTemplates[i].NumInDeck == 0 && !class'DisableAnyClassWotc_Config'.static.IsDisabledClass(ClassTemplates[i].DataName)))
			ClassTemplates.Remove(i, 1);
	}
    
	// Create checkboxes for all class names in the same order as the class templates list
	foreach ClassTemplates(ClassTemplate)
    {
        Group.AddCheckbox(
            ClassTemplate.DataName,
            ClassTemplate.DisplayName @ "[" $ string(ClassTemplate.DataName) $ "]",
            "",
            !class'DisableAnyClassWotc_Config'.static.IsDisabledClass(ClassTemplate.DataName));
    }
    
    Page.ShowSettings();

	`LOG("Disable Any Class: MCM mod config page shown.");
}

simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	local X2SoldierClassTemplate ClassTemplate;
    local MCM_API_Setting Setting;
	local bool IsChecked, IsDisabled;

	// Update the list of disabled class names
	foreach ClassTemplates(ClassTemplate)
    {
        Setting = Group.GetSettingByName(ClassTemplate.DataName);
		IsChecked = MCM_API_Checkbox(Setting).GetValue();
		IsDisabled = class'DisableAnyClassWotc_Config'.static.IsDisabledClass(ClassTemplate.DataName);
		if (!IsChecked && !IsDisabled)
			class'DisableAnyClassWotc_Config'.static.AddDisabledClass(ClassTemplate.DataName);
		else if (IsChecked && IsDisabled)
			class'DisableAnyClassWotc_Config'.static.RemoveDisabledClass(ClassTemplate.DataName);
	}

	// Save the updated list
	class'DisableAnyClassWotc_Config'.static.StaticSaveConfig();
}

DefaultProperties
{
	ExcludeClassTemplateNames(0)="Rookie"
	ExcludeClassTemplateNames(1)="PsiOperative"
}
