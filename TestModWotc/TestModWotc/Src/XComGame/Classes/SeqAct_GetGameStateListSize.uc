//-----------------------------------------------------------
//  FILE:    SeqAct_GetGameStateListSize.uc
//  AUTHOR:  James Brawley  --  7/12/2016
//  PURPOSE: Gets the length of a game state list and returns it to kismet as an int
// 
//-----------------------------------------------------------
class SeqAct_GetGameStateListSize extends SeqAct_SetSequenceVariable;

var int iListSize;

event Activated()
{
	local SeqVar_GameStateList List;

	foreach LinkedVariables(class'SeqVar_GameStateList',List,"GameState List")
	{
		iListSize = List.GameStates.Length;
		return;
	}

	iListSize = 0;

	`Redscreen("No SeqVar_GameStateList attached to " $ string(name));
}

defaultproperties
{
	ObjName="Get GameStateList Size"
	ObjCategory="Variable Lists"
	ObjColor=(R=255,G=0,B=255,A=255)

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="GameState List",bWriteable=false, MinVars=1, MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Size", bWriteable=true, PropertyName=iListSize)
}