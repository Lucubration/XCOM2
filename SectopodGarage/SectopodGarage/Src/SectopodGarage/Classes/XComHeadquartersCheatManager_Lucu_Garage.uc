class XComHeadquartersCheatManager_Lucu_Garage
	extends  XComHeadquartersCheatManager 
	within XComHeadquartersController;

// Level up aliens only
exec function GarageGiveSecto()
{
	class'Lucu_Garage_Utilities'.static.GiveSecto();
}
