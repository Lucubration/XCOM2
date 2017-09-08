
class UIPersonnel_DeceasedListItem extends UIPersonnel_ListItem
	dependson(X2StrategyGameRulesetDataStructures)
	dependson(XComPhotographer_Strategy);

var UIImage SoldierPictureControl;
var Texture2D SoldierPicture;

simulated function UpdateData()
{
	local XComGameState_Unit Unit;	
	local string DateStr;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	DateStr = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(Unit.GetKIADate(), true);

	`HQPRES.GetPhotoboothAutoGen().AddHeadShotRequest(UnitRef, 128, 128, OnDeadSoldierHeadCaptureFinished, class'X2StrategyElement_DefaultSoldierPersonalities'.static.Personality_ByTheBook());
	`HQPRES.GetPhotoboothAutoGen().RequestPhotos();

	AS_UpdateDataSoldier(Unit.GetName(eNameType_FullNick),
						 Unit.GetNumKills(),
						 Unit.GetNumMissions(),
						 Unit.GetKIAOp(),
						 DateStr);
}

function OnDeadSoldierHeadCaptureFinished(StateObjectReference InUnitRef)
{
	local XComGameState_CampaignSettings SettingsState;

	SettingsState = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	SoldierPicture = `XENGINE.m_kPhotoManager.GetHeadshotTexture(SettingsState.GameIndex, InUnitRef.ObjectID, 128, 128);

	SoldierPictureControl = Spawn(class'UIImage', self).InitImage(, PathName(SoldierPicture));
	SoldierPictureControl.SetScale(0.28);
	SoldierPictureControl.SetY(1);
}

simulated function AS_UpdateDataSoldier(string UnitName,
								 int UnitKills, 
								 int UnitMissions, 
								 string UnitLastOp, 
								 string UnitDateOfDeath)
{
	MC.BeginFunctionOp("UpdateData");
	MC.QueueString(UnitName);
	MC.QueueNumber(UnitKills);
	MC.QueueNumber(UnitMissions);
	MC.QueueString(UnitLastOp);
	MC.QueueString(UnitDateOfDeath);
	MC.EndOp();
}

defaultproperties
{
	LibID = "DeceasedListItem";
	height = 40;
}