class XComEditorEngine extends UnrealEdEngine
	config(Engine)
	native;

struct native NarrativeImportConfig
{
	var string MomentNameColum; // name of NarrativeMoment

	// associated resources
	var string SoundCueColumn;
	var string AKEventColumn;
	var string LocFileNameColumn;
	var string LipsyncAnimationNameColumn;

	// character identifiers
	var string CharacterNameColumn;
	var string CharacterTemplateColumn;
	var string CharacterGroupNameColumn;

	var string ConversationLineIdxColumn; // place in conversation (optional)
	var string EnlishDialogueColumn; // the dialogue (for use as subtitle)
};

var config array<string> FGDEClasses;
var config NarrativeImportConfig NarrativeImportSettings;

// Needed so that PIE can load dynamic assets
var XComContentManager ContentManager;

var XComOnlineProfileSettings XComProfileSettings;

//=======================================================================================
//X-Com 2 Refactoring
//
var XComGameStateHistory				GameStateHistory;
var XComGameStateNetworkManager			GameStateNetworkManager;
var X2AchievementTracker				AchievementTracker;
    
var X2EventManager						EventManager;
var XComAISpawnManager					SpawnManager;
var X2CardManager						CardManager;
var X2PhotoBooth_PhotoManager			m_kPhotoManager;
var X2AIBTBehaviorTree					BehaviorTreeManager;
var X2AIJobManager						AIJobManager;
var X2AutoPlayManager					AutoPlayManager;

var X2BodyPartTemplateManager			BodyPartTemplateManager;

var XComParcelManager           ParcelManager;
var XComTacticalMissionManager  TacticalMissionManager;
var XComEnvLightingManager      EnvLightingManager;
var XComMapManager              MapManager;

var private RedScreenManager                m_RedScreenManager;

var CharacterPoolManager            m_CharacterPoolManager;

//=======================================================================================

cpptext
{
	virtual void Init();
	virtual void PreExit();

	// UObject interface.
	virtual void FinishDestroy();

	virtual void Send( ECallbackEventType InType );
	
	void ToggleSHSpheres();
	
	virtual UBOOL Exec(const TCHAR* Cmd, FOutputDevice& Out=*GLog);
	
	UBOOL Exec_Mode(const TCHAR *Cmd, FOutputDevice &Out=*GLog);
	UBOOL Exec_Viewport(const TCHAR *Cmd, FOutputDevice &Out=*GLog);

	virtual UBOOL Game_Map_Check(const TCHAR* Str, FOutputDevice& Ar, UBOOL bCheckDeprecatedOnly);
	virtual UBOOL Game_Map_Check_Actor(const TCHAR* Str, FOutputDevice& Ar, UBOOL bCheckDeprecatedOnly, AActor* InActor);

	virtual UBOOL GetPropertyColorationColor(class UObject* Object, FColor& OutColor);

	virtual void PostScriptCompile();

	/**
	 * Creates the specified objects for dealing with DLC.
	 */
	virtual void InitGameSingletonObjects(void);
}

native function Object GetContentManager();

native function Object GetProfileSettings();

function CreateProfileSettings()
{
	XComProfileSettings = new(self) class'XComOnlineProfileSettings';
}

//=======================================================================================
//X-Com 2 Refactoring
//
function CreateGameStateHistory()
{
	GameStateHistory = new(self) class'XComGameStateHistory';
}
native function Object GetGameStateHistory();
native function OnGameStateHistoryResetComplete();

native function Object GetGameStateNetworkManager();
native function Object GetEventManager();
native function Object GetSpawnManager();
native function Object GetCardManager();
native function Object GetBehaviorTreeManager();
native function Object GetAIJobManager();
native function Object GetAutoPlayManager();
native function Object GetAchievementTracker();

native function Object GetCharacterPoolManager();

native function Object GetParcelManager();
native function Object GetTacticalMissionManager();
native function Object GetEnvLightingManager();
native function Object GetMapManager();

// Reporting
native function ReportLevelLoadTime(FLOAT LoadTime);


// MP Game check
native function bool IsMultiPlayerGame();
native function bool IsSinglePlayerGame();

native function LoadDynamicContent(const out URL url, optional bool bAsync = false );
native function CleanupDynamicContent();

//Triggers the load of streaming maps that support the 'base' maps in X-Com. 
//Routes to XComMapManager, which decides which parcels, rooms, cinematic maps, etc. need to be loaded
native function SeamlessTravelDetermineAdditionalMaps();

//In situations where additional content loading is asynchronous, the async process can use this polling function to find out if 
//loading is done
native function bool SeamlessTravelSignalStageComplete();

//=======================================================================================

defaultproperties
{
	OnlineEventMgrClassName="XComGame.XComOnlineEventMgr"
}
