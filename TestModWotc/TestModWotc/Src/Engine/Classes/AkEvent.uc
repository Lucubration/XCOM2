class AkEvent extends AkBaseSoundObject
	PerObjectConfig
	hidecategories(Object)
	native;

var() AkBank RequiredBank;
var() AkBank RequiredBankAlt<ToolTip = Some AkEvents may require more than one bank to facilitate localized voice as well as sound>;

/** A localized version of the text that is actually spoken in the audio. */
var(XCom)	name 									SpeakerTemplate<ToolTip = Character template name of the speaker for this dialog | DynamicList = "SpeakerTemplate">;
var(XCom)	string									AnimName<Tooltip = Animation to play on the speaker for this dialog>;
var(XCom)	localized string						SpokenText<ToolTip = The phonetic version of the dialog.>;
var(XCom)	bool									HideSpeaker<ToolTip = Do not dislpay the UI Comm Link unless Subtitles are enabled>;

/**
* Subtitle cues.  If empty, use SpokenText as the subtitle.  Will often be empty,
* as the contents of the subtitle is commonly identical to what is spoken.
*/
var(Subtitles)	localized array<SubtitleCue>		Subtitles;

/** TRUE if this sound is considered to contain mature content. */
var(Subtitles)	localized bool						bMature<ToolTip = For marking any adult language.>;

/** Provides contextual information for the sound to the translator. */
var(Subtitles)	editoronly localized string			Comment<ToolTip = Contextual information for the sound to the translator.>;

/** TRUE if the subtitles have been split manually. */
var(Subtitles)	localized bool						bManualWordWrap<ToolTip = Disable automatic generation of line breaks.>;

/** TRUE if the subtitles display as a sequence of single lines as opposed to multiline */
var(Subtitles)	localized bool						bSingleLine<ToolTip = Display the subtitle as a sequence of single lines.>;

/**
* The array of the subtitles for each language. Generated at cook time.
* The index for a specific language extension can be retrieved via the Localization_GetLanguageExtensionIndex function in UnMisc.cpp.
*/
var array<LocalizedSubtitle> 						LocalizedSubtitles;

cpptext
{
	virtual void PostLoad();
	void FixRequiredBank();

	UBOOL IsAudible( const FVector& SourceLocation, const FVector& ListenerLocation, AActor* SourceActor, INT& bIsOccluded, UBOOL bCheckOcclusion );

	UBOOL LoadBank();

	virtual void GetDynamicListValues(const FString& ListName, TArray<FString>& Values);
};