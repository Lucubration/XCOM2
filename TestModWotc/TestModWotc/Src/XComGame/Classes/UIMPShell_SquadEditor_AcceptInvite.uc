//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIMPShell_SquadEditor_AcceptInvite.uc
//  AUTHOR:  Timothy Talley  --  12/02/2015
//  PURPOSE: Configures the Squad Editor to inform the user that they are at an invite acceptance stage.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UIMPShell_SquadEditor_AcceptInvite extends UIMPShell_SquadEditor;

defaultproperties
{
	UINextScreenClass=None
	m_bAddRightNavButton = false;

	TEMP_strSreenNameText="Accepting Invite Squad Editor"
}
