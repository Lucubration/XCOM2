class UIScreenListener_Lucu_Garage_AfterAction extends UIScreenListener;

var UIArmory_MainMenu						ArmoryMainMenu;
var delegate<UIList.OnItemSelectedCallback>	ArmoryMainMenuItemClickedCallback;

event OnInit(UIScreen Screen)
{
	if (Screen.IsA('UIAfterAction'))
	{
		ResetXtopodXP();

		`LOG("Xtopod Garage: Updated armory main menu list clicked delegate.");
	}
}

function ResetXtopodXP()
{
	local XComGameStateHistory							History;
	local XComGameState_HeadquartersXCom				XComHQ;
	local XComGameState									NewGameState;
	local XComGameState_Unit							UnitState;
	local XComGameState_Lucu_Garage_XtopodUnitState		XtopodState;
	local int											i, NumKills;

	History = `XCOMHISTORY;
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	
	for (i = 0; i < XComHQ.Squad.Length; ++i)
	{
		if (XComHQ.Squad[i].ObjectID > 0)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[i].ObjectID));
			if (UnitState.GetMyTemplateName() == 'Lucu_Garage_Sectopod')
			{
				NumKills = UnitState.GetNumKills();
				if (NumKills > 0)
				{
					if (NewGameState == none)
						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Xtopod states cleanup");
					UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
					XtopodState = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(UnitState);
					XtopodState = XComGameState_Lucu_Garage_XtopodUnitState(NewGameState.CreateStateObject(class'XComGameState_Lucu_Garage_XtopodUnitState', XtopodState.ObjectID));
					UnitState.ClearKills();
					NewGameState.AddStateObject(XtopodState);
					NewGameState.AddStateObject(UnitState);
				}
			}
		}
	}

	if (NewGameState != none && NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}
