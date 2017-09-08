class UIScreenListener_Lucu_Garage_TacticalHUD extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	if (class'Lucu_Garage_Config'.default.EnablePowerModel)
	{
		if (Screen.IsA('UITacticalHUD'))
		{
			if (Screen.GetChildByName('UITacticalHUD_Lucu_Garage_PowerCounter', false) == none)
			{
				Screen.Movie.Pres.Spawn(class'UITacticalHUD_Lucu_Garage_PowerCounter', Screen).InitPowerCounter();

				`LOG("Xtopod Garage: Power counter initialized.");
			}
			if (Screen.GetChildByName('UITacticalHUD_Lucu_Garage_AmmoCounter', false) == none)
			{
				Screen.Movie.Pres.Spawn(class'UITacticalHUD_Lucu_Garage_AmmoCounter', Screen).InitAmmoCounter();

				`LOG("Xtopod Garage: Ammo counter initialized.");
			}
		}
	}
}
