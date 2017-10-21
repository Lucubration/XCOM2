
class XComBlueprint 
	extends GroupActor
	native(GameEngine);

var() string MapReference;

var transient LevelStreaming StreamingLevel;
var transient array<Actor> LevelActors;

var private editoronly Level DupedLevel;

var native Array_Mirror InitialPositions{TArray<FRotationTranslationMatrix>};

var private bool BrokenReference;
var private editoronly array<Name> BrokenActorIDs;
var private editoronly array<Name> BrokenSequenceIDs;

/** Snapshot of Blueprint used for thumbnail in the browser. */
var		editoronly const Texture2D		ThumbnailPreview;

delegate BlueprintLoadComplete( );

native final function GameLevelLoadComplete( Name LevelPackageName, LevelStreaming LevelStreamedIn );
native static function XComBlueprint ConstructGameplayBlueprint( String BlueprintMapName, Vector Position, Rotator Orientation, Object InOuter, optional Name BlueprintName = 'none' );

// provide a way for script to get the set of actors (in a way that works for the editor & game)
native final function GetLoadedLevelActors( out array<Actor> Actors );

// Can any actor in this blueprint use Cutout
native simulated function bool CanUseCutout();
native simulated function bool HasValidMap();

cpptext
{
	virtual void Spawned();
	virtual void PostDuplicate();
	virtual void PostLoad();
	virtual void PostEditMove(UBOOL bFinished);
	virtual void BeginDestroy();
	virtual UObject* CreateArchetype( const TCHAR* ArchetypeName, UObject* ArchetypeOuter, UObject* AlternateArchetype=NULL, FObjectInstancingGraph* InstanceGraph=NULL );

	virtual void PostEditChangeChainProperty( struct FPropertyChangedChainEvent& PropertyChangedEvent );
	virtual void PostEditChangeProperty( struct FPropertyChangedEvent& PropertyChangedEvent);

	virtual void PostScriptDestroyed();
	virtual void FinishDestroy();
	virtual void OnRemoveFromWorld();

	virtual void PreSave();
	virtual void PostSave();

	void EditorLoadMap( );
	void EditorUnloadmap( );
	void GameUnloadMap( );

	void ForceUpdateActorTransforms( );

	bool IsBroken( );
	void BreakMapReference( );
	void RestoreMapReference( );

	static AXComBlueprint* GetBlueprintRootForActor(AActor* InActor, UBOOL bMustBeLocked=FALSE, UBOOL bMustBeSelected=FALSE);
	static AXComBlueprint* GetBlueprintParentForActor( AActor* InActor );
}

defaultproperties
{
	bAllowEmptyGroup = true;
	bEdShouldSnap = true; // per BrianHess
	BrokenReference = false;

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.BlueprintSprite'
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
		HiddenGame=true
	End Object
	Components.Add(Sprite)

	bTickIsDisabled = true
}