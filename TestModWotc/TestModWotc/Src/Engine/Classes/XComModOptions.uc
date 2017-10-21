//---------------------------------------------------------------------------------------
//  FILE:    XComModOptions.uc
//  AUTHOR:  Ryan McFall  --  9/2/2014
//  PURPOSE: This class is responsible for answering questions from the game and engine as 
//           to which mods are active.
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class XComModOptions extends Object native config(ModOptions);

/** When the engine initializes, mods will only be loaded and initialized if their folder name is in this list */
var config array<string> ActiveMods;

defaultproperties
{
}