/**
 * Light Injector (Injects light into LPV volume)
 */
class LightInjector extends Actor
	native
	placeable;

var() editconst const LightInjectorComponent	LightInjectorComponent;

var bool bEnabled;

native function SetEnabled(bool bInEnabled);

defaultproperties
{
	// when you place a light in the editor it defaults to a point light
    // @see ActorFactorLight
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.LightIcons.Light_Point_LPV'
		Scale=0.1  // we are using 128x128 textures so we need to scale them down
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="Lighting"
	End Object
	Components.Add(Sprite)

	Begin Object Class=LightInjectorComponent Name=LightInjComp
	End Object
	Components.Add(LightInjComp)
	LightInjectorComponent=LightInjComp

	bStatic=TRUE
	bHidden=TRUE
	bNoDelete=TRUE
	bMovable=FALSE
	bRouteBeginPlayEvenIfStatic=FALSE
	bEdShouldSnap=TRUE

	Layer=Lighting
}
