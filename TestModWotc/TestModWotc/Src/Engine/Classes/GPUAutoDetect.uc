class GPUAutoDetect extends Object
	native
	config(Game)
	inherits(FTickableObject);

var config float m_fMaxTestingTime;
var config int m_iNumTests;

struct native GraphicSettingCoeffs
{
	var float M;
	var float B;
};

var config array<GraphicSettingCoeffs> m_aNvidiaSettingsCoeffs;
var config array<GraphicSettingCoeffs> m_aAMDSettingsCoeffs;


var bool m_bIsRunning;
var bool m_bForceBail;
var float m_fStartTime;

var int m_iCurrentTest;

var array<vector> m_aTestTimes;

var delegate<CallOnFinish> FinishDelegate;

delegate CallOnFinish();

cpptext
{
	virtual void Tick(FLOAT DeltaTime);
	virtual UBOOL IsTickable() const { return TRUE; }
	virtual UBOOL IsTickableWhenPaused() const { return TRUE; }
}

event OnFinish()
{
	if (FinishDelegate != none)
		FinishDelegate();

	//We do not clear the fade here, as the main menu is still loading in. Wait until it is ready in XComShell
}

event OnStart()
{
	class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0, 1), 0.0);
}

native function StartCheck(bool bForce, delegate<CallOnFinish> InFinishDelegate);
native function ForceEndCheck();

DefaultProperties
{
	m_bIsRunning=false
	m_bForceBail=false
}