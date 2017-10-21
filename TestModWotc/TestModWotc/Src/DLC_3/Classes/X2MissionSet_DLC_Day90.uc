//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2MissionSet_DLC_Day90.uc
//  AUTHOR:  James Brawley - 2/9/2016
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class X2MissionSet_DLC_Day90 extends X2MissionSet config(GameCore);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionTemplate> Templates;

    Templates.AddItem(AddMissionTemplate('LastGift'));
    Templates.AddItem(AddMissionTemplate('LastGiftB'));
    Templates.AddItem(AddMissionTemplate('LastGiftC'));

    return Templates;
}
