class UICovertOpsFactionListItem extends UIListItemString;

simulated function UICovertOpsFactionListItem InitCovertOpsListItem(optional StackedUIIconData InitIcon, optional string InitText, optional string InitColor)
{
	InitPanel();
	PopulateData(InitIcon, InitText, InitColor);
	ButtonBG.Remove(); 
	return self;
}

function PopulateData(StackedUIIconData factionIcon, string factionName, string textColor)
{
	local int i;
	MC.BeginFunctionOp("populateData");
	
	MC.QueueString(factionName);
	MC.QueueString(textColor);
	MC.QueueBoolean(factionIcon.bInvert);
	for (i = 0; i < factionIcon.Images.Length; i++)
	{
		MC.QueueString("img:///" $ Repl(factionIcon.Images[i], ".tga", "_sm.tga"));
	}
	MC.EndOp();
}

defaultproperties
{
	LibID = "CovertOpsHeaderRowItem";
	height = 46; // size according to flash movie clip
}