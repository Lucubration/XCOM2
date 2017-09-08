//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    XGAIPlayer_Resistance.uc    
//  AUTHOR:  Russell Aasland  --  1/10/2017
//  PURPOSE: For spawning and controlling Resistance soldier behaviors
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XGAIPlayer_Resistance extends XGAIPlayer
	native(AI)
	dependson(XGGameData)
	config(AI);

defaultproperties
{
	m_eTeam = eTeam_Resistance;
}