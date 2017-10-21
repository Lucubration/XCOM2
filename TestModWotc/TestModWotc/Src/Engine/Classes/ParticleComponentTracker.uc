

class ParticleComponentTracker extends Actor
	native(Particle)
	transient
	config(Game);

var transient const array<ParticleSystemComponent> TrackedComponents;

struct native TrackerStats
{
	/** Total accumulative tick time in seconds. */
	var float AccumTickTime;
	/** Max tick time in seconds. */
	var float MaxTickTime;
	/** Total accumulative active particles. */
	var int AccumActiveParticles;
	/** Max active particle count. */
	var int MaxActiveParticleCount;
	/** Total tick count. */
	var int TickCount;

	var ParticleSystemComponent pComponent;

	var double StatTime;

};

var native Map_Mirror ValueMap{TMap<UParticleSystemComponent *, FTrackerStats>};
var native array<TrackerStats> MostExpensive;
var native bool bIsEnabled;

var string ComponentNameFilter;
var string TemplateNameFilter;
var string OwnerNameFilter;

var bool bShowMem;
var bool bShowPerf;

var bool bShowMemSummary;
var bool bShowPerfSummary;


native function UpdateStats( ParticleSystemComponent pComponent, float TickTime, int ActiveParticles );


cpptext
{
	virtual void TickSpecial(FLOAT DeltaTime);
	virtual void NativePostRenderFor(APlayerController *PC, UCanvas *Canvas, FVector CameraPosition, FVector CameraDir);
	virtual void BeginDestroy();

}
