class UIArmory_Lucu_Garage_Modules extends UIArmory;

var localized string m_strModulesHeader;
var localized string m_strInstallModule;

var bool bShownClassPopup, bInstallSectopodPromotion;
var XComGameState_Lucu_Garage_XtopodUnitState Xtopod;

var UIArmory_PromotionItem ClassRowItem;
var UIList List;

simulated function InitModules(StateObjectReference UnitRef, bool bInstallSectopod, optional bool bInstantTransition)
{
	CameraTag = GetModulesBlueprintTag(UnitRef);
	DisplayTag = name(GetModulesBlueprintTag(UnitRef));

	bInstallSectopodPromotion = bInstallSectopod;
	
	// Don't show nav help during tutorial, or during the After Action sequence.
	bUseNavHelp = false;

	super.InitArmory(UnitRef,,,,,, bInstantTransition);

	List = Spawn(class'UIList', self).InitList('promoteList');
	List.OnSelectionChanged = PreviewRow;
	List.bStickyHighlight = false;
	List.bAutosizeItems = false;

	PopulateData();

	MC.FunctionVoid("animateIn");
}

simulated function PopulateData()
{
	local int i, maxModules, previewIndex;
	local string AbilityIcon2, AbilityName2, HeaderString;
	local XComGameState_Unit Unit;
	local X2SoldierClassTemplate ClassTemplate;
	local X2AbilityTemplate AbilityTemplate1, AbilityTemplate2;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local array<SoldierClassAbilityType> AbilityTree;
	local UIArmory_Lucu_Garage_ModuleItem Item;
	local Vector ZeroVec;
	local Rotator UseRot;
	local XComUnitPawn UnitPawn;

	// We don't need to clear the list, or recreate the pawn here -sbatista
	//super.PopulateData();
	Unit = GetUnit();
	Xtopod = class'Lucu_Garage_Utilities'.static.GetXtopodComponent(Unit);
	ClassTemplate = Unit.GetSoldierClassTemplate();

	HeaderString = m_strModulesHeader;

	AS_SetTitle(ClassTemplate.IconImage, HeaderString, "" /* ClassTemplate.LeftAbilityTreeTitle */, "" /* ClassTemplate.RightAbilityTreeTitle */, Caps(ClassTemplate.DisplayName));
	
	if(ActorPawn == none || Unit.GetRank() == 1 && bInstallSectopodPromotion)
	{
		//Get the current pawn so we can extract its rotation
		UnitPawn = Movie.Pres.GetUIPawnMgr().RequestPawnByID(none, UnitReference.ObjectID, ZeroVec, UseRot);
		UseRot = UnitPawn.Rotation;

		//Free the existing pawn, and then create the ranked up pawn. This may not be strictly necessary since most of the differences between the classes are in their equipment. However, it is easy to foresee
		//having class specific soldier content and this covers that possibility
		Movie.Pres.GetUIPawnMgr().ReleasePawn(none, UnitReference.ObjectID);
		CreateSoldierPawn(UseRot);
	}

	// Check to see if Unit has just leveled up to Squaddie, they will then receive a batch of abilities.
	if (Unit.GetRank() == 1 && Unit.HasAvailablePerksToAssign() && !bShownClassPopup)
	{
		AwardRankAbilities(ClassTemplate, 0);

		`HQPRES.UIClassEarned(Unit.GetReference());
		bShownClassPopup = true;

		Unit = GetUnit(); // we've updated the UnitState, update the Unit to reflect the latest changes
	}
	
	previewIndex = -1;
	maxModules = class'Lucu_Garage_Config'.default.MaxModules;
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if (ClassRowItem == none)
	{
		ClassRowItem = Spawn(class'UIArmory_PromotionItem', self);
		ClassRowItem.MCName = 'classRow';
		ClassRowItem.InitPromotionItem(0);
		ClassRowItem.OnMouseEventDelegate = OnClassRowMouseEvent;

		if (Unit.GetRank() == 1)
			ClassRowItem.OnReceiveFocus();
	}

	ClassRowItem.ClassName = ClassTemplate.DataName;
	ClassRowItem.SetRankData(class'UIUtilities_Image'.static.GetRankIcon(0, ''), Caps(ClassTemplate.DisplayName));

	AbilityTree = ClassTemplate.GetAbilityTree(ClassRowItem.Rank);
	AbilityTemplate2 = AbilityTemplateManager.FindAbilityTemplate(AbilityTree[1].AbilityName);
	if (AbilityTemplate2 != none)
	{
		ClassRowItem.AbilityName2 = AbilityTemplate2.DataName;
		AbilityName2 = Caps(AbilityTemplate2.LocFriendlyName);
		AbilityIcon2 = AbilityTemplate2.IconImage;
	}
	else
	{
		AbilityTemplate1 = AbilityTemplateManager.FindAbilityTemplate(AbilityTree[0].AbilityName);
		ClassRowItem.AbilityName2 = AbilityTemplate1.DataName;
		AbilityName2 = Caps(AbilityTemplate1.LocFriendlyName);
		AbilityIcon2 = AbilityTemplate1.IconImage;
	}

	ClassRowItem.SetEquippedAbilities(true, true);
	ClassRowItem.SetAbilityData("", "", AbilityIcon2, AbilityName2);
	ClassRowItem.SetClassData(ClassTemplate.IconImage, Caps(ClassTemplate.DisplayName));

	for (i = 0; i < maxModules; ++i)
	{
		Item = UIArmory_Lucu_Garage_ModuleItem(List.GetItem(i));
		if (Item == none)
			Item = UIArmory_Lucu_Garage_ModuleItem(List.CreateItem(class'UIArmory_Lucu_Garage_ModuleItem')).InitModuleItem(i);

		Item.Slot = i;
		if (Xtopod.GetNumInstalledModules() < i)
			Item.SetDisabled(true);
		else
			Item.SetModuleData(Xtopod.GetInstalledModule(i));

		Item.RealizeVisuals();
	}

	class'UIUtilities_Strategy'.static.PopulateAbilitySummary(self, Unit);
	PreviewRow(List, previewIndex);
}

simulated function OnClassRowMouseEvent(UIPanel Panel, int Cmd)
{
	if(Cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || Cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		PreviewRow(List, -1);
}

simulated function PreviewRow(UIList ContainerList, int ItemIndex)
{
	local X2SoldierClassTemplate ClassTemplate;
	local XComGameState_Unit Unit;

	Unit = GetUnit();
	ClassTemplate = Unit.GetSoldierClassTemplate();

	MC.BeginFunctionOp("setAbilityPreview");

	MC.QueueString(ClassTemplate.IconImage); // icon
	MC.QueueString(Caps(ClassTemplate.DisplayName)); // name
	MC.QueueString(ClassTemplate.ClassSummary); // description
	MC.QueueBoolean(true); // isClassIcon

	MC.EndOp();
}

simulated function HideRowPreview()
{
	MC.FunctionVoid("hideAbilityPreview");
}

simulated function ShowModuleSelectionScreen(int Rank, int Branch)
{
}

simulated function AwardRankAbilities(X2SoldierClassTemplate ClassTemplate, int Rank)
{
	local XComGameStateHistory History;
	local int i;
	local XComGameState UpdateState;
	local XComGameState_Unit UpdatedUnit;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local array<SoldierClassAbilityType> AbilityTree;

	History = `XCOMHISTORY;
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Unit Promotion");
	UpdateState = History.CreateNewGameState(true, ChangeContainer);

	UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', UnitReference.ObjectID));

	// Add new abilities to the Unit
	AbilityTree = ClassTemplate.GetAbilityTree(Rank);
	for(i = 0; i < AbilityTree.Length; ++i)
		UpdatedUnit.BuySoldierProgressionAbility(UpdateState, Rank, i);

	UpdateState.AddStateObject(UpdatedUnit);

	`GAMERULES.SubmitGameState(UpdateState);
}

simulated function string GetModulesBlueprintTag(StateObjectReference UnitRef)
{
	local int HealTimeHours;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	UnitState.GetWoundState(HealTimeHours);
	if(UnitState.IsGravelyInjured(HealTimeHours))
		return default.DisplayTag $ "Injured";
	return string(default.DisplayTag);
}

//==============================================================================

simulated function AS_SetTitle(string Image, string TitleText, string LeftTitle, string RightRitle, string ClassTitle)
{
	MC.BeginFunctionOp("setPromotionTitle");
	MC.QueueString(Image);
	MC.QueueString(TitleText);
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(LeftTitle));
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(RightRitle));
	MC.QueueString(ClassTitle);
	MC.EndOp();
}

//==============================================================================

defaultproperties
{
	LibID = "PromotionScreenMC";
	bHideOnLoseFocus = false;
	bAutoSelectFirstNavigable = false;
	DisplayTag = "UIBlueprint_Promotion";
	CameraTag = "UIBlueprint_Promotion";
}