class X2LocalEnvMapManager extends Actor
	native;

var transient array<X2SceneCaptureEnvMapComponent> RegisteredEnvMaps;
var transient array<X2SceneCaptureEnvMapComponent> EnvMapsNeedingCapture;
var transient array<X2SceneCaptureEnvMapComponent> EnvMapsNeedingRecapture;
var transient array<X2SceneCaptureEnvMapComponent> EnvMapsNeedingFiltering;
var transient array<X2SceneCaptureEnvMapComponent> RenderedEnvMaps;

var transient bool bEnableCaptures;
var transient bool bDoneWithInitialCaptures;

cpptext
{
	virtual void TickSpecial(float DeltaTime);

	void NotifyFinishFiltering(UX2SceneCaptureEnvMapComponent* pComponent);

	void RegisterEnvMapCapture(UX2SceneCaptureEnvMapComponent* InEnvMapActor);
	void DeregisterEnvMapCapture(UX2SceneCaptureEnvMapComponent* InEnvMapActor);

	UBOOL PlayerControlled() {return TRUE;}
}

function SetEnableCaptures(bool bInEnable)
{
	bEnableCaptures = bInEnable;

	if (bInEnable == true)
		bDoneWithInitialCaptures = false;
}

native function ResetCaptures();

native function bool AreCapturesComplete();

defaultproperties
{
	bEnableCaptures=false //Don't permit captures until the scene says so
	bDoneWithInitialCaptures=false
}
