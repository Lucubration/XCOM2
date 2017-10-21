class XComNarrativeMoment extends Object
	native;

enum ENarrativeMomentType
{
	eNarrMoment_CommLink,               // A non-modal ui "comm-link" element
	eNarrMoment_CommLinkModal,          // A modal ui "comm-link" element
	eNarrMoment_CommLinkModalLookAt,    // A modal comm link element that also pans the camera to an object of interest in the world
	eNarrMoment_Matinee,                // A non-modal matinee sequence
	eNarrMoment_MatineeModal,           // A modal matinee sequence that takes control of the game
	eNarrMoment_Tentpole,               // Modal tentpole matinee
	eNarrMoment_VoiceOnly,              // Plays sound only, no text, these are allowed to play simultaneously with other moments
	eNarrMoment_VoiceOnlyMissionStream, // Abduction(or other) mission voice stream.  Only one allowed at a time, all others are quickly faded out.
	eNarrMoment_VoiceOnlySoldierVO,     // Plays VO from a soldier as a result of seeing an X2WorldNarrativeActor
	eNarrMoment_Bink,                   // Plays a bink
	eNarrMoment_UIOnly,					// Plays a modal UIScreen
};

var()   ENarrativeMomentType        eType;              // The type of narrative moment to play (comm link, matinee sequence, etc.)
	
var() bool                          bFirstTimeAtIndexZero;          // If true, index 0 of arrConversations is for first time only
var() bool                          bDontPlayIfNarrativePlaying;    // Will only play if no narratives are in the narrative Manager
var() bool                          bUseCinematicSoundClass;        // Mutes all sounds except CinematicSound Class and Voice class;
var() notforconsole array<SoundCue> Conversations;
var() editconst array<name>         arrConversations;       // one or more conversations, name of sound cue    
var() bool							PlayAllConversationsInOrder;  // if true, instead of selecting a single conversation to play will instead play all conversations in the order of entry
var() name                          SoldierVO<ToolTip=For use with SolderVO Narrative Moment type>;

var() string                        strMapToStream<DisplayName=MapToStream>;         // Assuming we are a matinee moment, stream in this map
var() name                          nmRemoteEvent<DisplayName=RemoteEvent>;          // Remote event to be triggered
var() string                        strBink;                                         // Bink to play, assuming we are eNarrMoment_Bink
var() AkEvent						BinkAudioEvent<ToolTip = Plays a wise audio event along with the bink movie>;
var() bool							DontStopAudioEventOnCompletion;
var() bool							FadeToBlackForBink;
var() float                     	PreFadeDelayDuration;
var() float                     	FadeDuration;

var() name                          AmbientCriteriaTypeName<DynamicList = "AmbientCriteriaTypeName">;
var() array<name>                   AdditionalAmbientCriteriaTypeNames<DynamicList = "AmbientCriteriaTypeName">;
var() array<name>					AmbientConditionTypeNames<DynamicList = "AmbientConditionTypeName">;
var() name							AmbientBlockingTypeName<DynamicList = "AmbientCriteriaTypeName">;
var() name							AmbientSpeaker<DynamicList = "SpeakerTemplate">;
var() float                         AmbientPriority;
var() int                           AmbientMaxPlayCount;        // maximum plays (current count is persistent)
var() int                           AmbientMaxPlayFrequency;    // minimum number of seconds between plays of this
var() int							AmbientMinDelaySinceLastNarrativeVO; // min spacing between previous VO and this VO (in seconds)

var() bool                          PlayBinkOverGameplay; // allows gameplay to continue/finish what it was doing underneath the bink while it plays

// this enum should be kept in sync with XComAnimTreeController.BlendMaskIndex
enum EngineBlendMaskIndex
{
	EBLEND_MASK_FULLBODY,
	EBLEND_MASK_UPPERBODY,
	EBLEND_MASK_LEFTARM,
	EBLEND_MASK_RIGHTARM,
	EBLEND_MASK_HEAD,
	EBLEND_MASK_ADDITIVE,
};

var() name							SpeakerTemplateGroupName<DynamicList = "SpeakerTemplateGroupName">;
var() Name							SpeakerAnimationName;	// animation to play on the speaker (the pawn whose Unit template matches SpeakerTemplateGroupName).
var() EngineBlendMaskIndex			SpeakerAnimationBlendType;

var transient float                 LastAmbientPlayTime;

var transient int                   iID;
var transient bool                  bFirstRunOnly;

cpptext
{
	virtual void Serialize(FArchive &Ar);
	virtual void PostEditChangeProperty(FPropertyChangedEvent &PropertyThatChanged);
	virtual void PostLoad();
	virtual void GetDynamicListValues(const FString& ListName, TArray<FString>& Values);
}

simulated function bool ShouldClearQueueOfNonTentpoles()
{
	return eType == eNarrMoment_Tentpole || eType == eNarrMoment_Bink || eType == eNarrMoment_UIOnly;
}

simulated function bool CanBeCanceled()
{
	return !(eType == eNarrMoment_Tentpole || eType == eNarrMoment_Bink);	
}

simulated function bool UseFadeToBlack()
{
	return (eType == eNarrMoment_Bink && FadeToBlackForBink);
}

simulated function bool IsModal()
{
	return eType == eNarrMoment_CommLinkModal || eType == eNarrMoment_CommLinkModalLookAt || eType == eNarrMoment_MatineeModal || eType == eNarrMoment_Tentpole;
}

simulated function bool IsVoiceOnly()
{
	return eType == eNarrMoment_VoiceOnly || eType == eNarrMoment_VoiceOnlyMissionStream;
}

defaultproperties
{
	iID = -1
	bFirstRunOnly = false
	AmbientMaxPlayCount = 1
	DontStopAudioEventOnCompletion = false
}