/**
 * Abstract Light
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Light extends Actor
	native(Light)
	ClassGroup( Lights );

/** Env Light classification determines when a light should be enabled/disabled based on environment lighting */
var() deprecated EEnvLightClassification EnvLightClass;

var() EnvironmentToggleInfo EnvClassification;


var() editconst const LightComponent	LightComponent;

/** Component Used to store Light Injectors generated from running Virtual Perrella. */
var LightInjectorVPComponent LIVPComponent;

/* Enables Virtual Perrella on this light. */
var(VirtualPerrella) bool VP_Enable;

/* Enable this is the light actor is actually a dummy light used solely to create bound lighting. This will cause the VP to ignore the lights brightness factor */
var(VirtualPerrella) bool VP_DummyLight;

/* A Brightness scale for light injectors created on this light using Virtual Perrella */
var(VirtualPerrella) float VP_Brightness;

/** In the editor, lights may be enabled/disabled when previewing env lighting */
var editoronly transient bool bPreviewingEnvLighting;
var editoronly transient bool bCachedEnabledSetting;

cpptext
{
public:
	// AActor interface.
	/**
	 * Function that gets called from within Map_Check to allow this actor to check itself
	 * for any potential errors and register them with map check dialog.
	 */
#if WITH_EDITOR
	virtual void CheckForErrors();
#endif

	/**
	 * This will determine which icon should be displayed for this light.
	 **/
	virtual void DetermineAndSetEditorIcon();

	/**
	 * For this type of light, set the values which would make it affect Dynamic Primitives.
	 **/
	virtual void SetValuesForLight_DynamicAffecting();

	/**
	 * For this type of light, set the values which would make it affect Static Primitives.
	 **/
	virtual void SetValuesForLight_StaticAffecting();

	/**
	 * For this type of light, set the values which would make it affect Dynamic and Static Primitives.
	 **/
	virtual void SetValuesForLight_DynamicAndStaticAffecting();

	/**
	 * Returns true if the light supports being toggled off and on on-the-fly
	 *
	 * @return For 'toggleable' lights, returns true
	 */
	virtual UBOOL IsToggleable() const
	{
		// By default, lights are not toggleable.  You can override this in derived classes.
		return TRUE; // FIRAXIS CHANGE - Allow all lights to be toggled. (For use with cinematics)
	}

    /** Invalidates lighting for a lighting rebuild. */
    void InvalidateLightingForRebuild();

	virtual void PreSave();

	virtual void PostLoad();

	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}


/** replicated copy of LightComponent's bEnabled property */
var repnotify bool bEnabled;

replication
{
	if (Role == ROLE_Authority)
		bEnabled;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'bEnabled')
	{
		LightComponent.SetEnabled(bEnabled);
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/* epic ===============================================
* ::OnToggle
*
* Scripted support for toggling a light, checks which
* operation to perform by looking at the action input.
*
* Input 1: turn on
* Input 2: turn off
* Input 3: toggle
*
* =====================================================
*/
simulated function OnToggle(SeqAct_Toggle action)
{
	if (!bStatic)
	{
		if (action.InputLinks[0].bHasImpulse)
		{
			// turn on
			LightComponent.SetEnabled(TRUE);
		}
		else if (action.InputLinks[1].bHasImpulse)
		{
			// turn off
			LightComponent.SetEnabled(FALSE);
		}
		else if (action.InputLinks[2].bHasImpulse)
		{
			// toggle
			LightComponent.SetEnabled(!LightComponent.bEnabled);
		}
		bEnabled = LightComponent.bEnabled;
		ForceNetRelevant();
		SetForcedInitialReplicatedProperty(Property'Engine.Light.bEnabled', (bEnabled == default.bEnabled));
	}
}

native function SetEnvLightingPreview(EEnvClassification PreviewMode);


defaultproperties
{
	// when you place a light in the editor it defaults to a point light
    // @see ActorFactorLight
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.LightIcons.Light_Point_Stationary_Statics'
		Scale=0.25  // we are using 128x128 textures so we need to scale them down
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="Lighting"
	End Object
	Components.Add(Sprite)

	bStatic=TRUE
	bHidden=TRUE
	bNoDelete=TRUE
	bMovable=FALSE
	bRouteBeginPlayEvenIfStatic=FALSE
	bEdShouldSnap=TRUE

	VP_Enable = FALSE
	VP_DummyLight = FALSE
	VP_Brightness = 1.0f

	Layer=Lighting
}
