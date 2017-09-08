
class X2PhotoBooth_PhotoManager extends Object
	native
	config(UI);

enum EPropagandaWeightMethod
{
	ePWM_Campaign,
	ePWM_Recent,
	ePWM_Random,
	ePWM_Max
};

enum EPhotoDataType
{
	ePDT_User,
	ePDT_HeadShot,
	ePDT_Captured,
	ePDT_Promoted,
	ePDT_Dead,
	ePDT_Bonded
};

struct native PhotoData
{
	var init array<int> CharacterIDs;
	var init string PhotoFilename;
	var int Time;
	var int Favorite; // Non-zero == Favorited
	var Texture2D Texture;
	var int TextureSizeX;
	var int TextureSizeY;
	var Texture2D WantedTexture; // Only used by Headshots
	var Texture2D SmallTexture; // Only used by Headshots
	var EPhotoDataType PhotoType;
	var name nmHead;
	var name nmHaircut;
	var name nmBeard;
	var name nmTorso;
	var name nmHelmet;
	var name nmEye;
	var name nmTeeth;
	var name nmFacePropLower;
	var name nmFacePropUpper;
	var name nmPatterns;
	var name nmScars;
	var name nmTorso_Underlay;
	var name nmFacePaint;
	var name nmTorsoDeco;
	var int iGender;
	var int iRace;
	var int iHairColor;
	var int iFacialHair;
	var int iSkinColor;
	var int iEyeColor;
	var int iArmorDeco;
	var int iArmorTint;
	var int iArmorTintSecondary;

	structcpptext
	{
		FPhotoData()
		: Texture(nullptr)
		, Time(0)
		, Favorite(0)
		, TextureSizeX(0)
		, TextureSizeY(0)
		, WantedTexture(nullptr)
		, SmallTexture(nullptr)
		, PhotoType(ePDT_User)
		, nmHead(NAME_None)
		, nmHaircut(NAME_None)
		, nmBeard(NAME_None)
		, nmTorso(NAME_None)
		, nmHelmet(NAME_None)
		, nmEye(NAME_None)
		, nmTeeth(NAME_None)
		, nmFacePropLower(NAME_None)
		, nmFacePropUpper(NAME_None)
		, nmPatterns(NAME_None)
		, nmScars(NAME_None)
		, nmTorso_Underlay(NAME_None)
		, nmFacePaint(NAME_None)
		, nmTorsoDeco(NAME_None)
		, iHairColor(0)
		, iFacialHair(0)
		, iGender(0)
		, iRace(0)
		, iSkinColor(0)
		, iEyeColor(0)
		, iArmorDeco(0)
		, iArmorTint(0)
		, iArmorTintSecondary(0)
		{}

		inline void PhotoDataSerializeName(FArchive& Ar, FName& N)
		{
			// we cannot safely use the name index as that is not guaranteed to persist across game sessions
			FString NameText;
			if (Ar.IsSaving())
			{
				NameText = N.GetNameString();
			}

			Ar << NameText;

			if (Ar.IsLoading())
			{
				// copy over the name with a name made from the name string
				N = FName(*NameText);
			}
		}

		friend FArchive& operator<<(FArchive& Ar,FPhotoData& PhotoData)
		{
			Ar << PhotoData.CharacterIDs;
			Ar << PhotoData.PhotoFilename;
			Ar << PhotoData.Time;
			Ar << PhotoData.Favorite;

			if (Ar.IsObjectReferenceCollector())
			{
				Ar << PhotoData.Texture;
			}

			if (Ar.LicenseeVer() >= FXS_VER_POSTER_DATA_UPDATE_2)
			{
				Ar << PhotoData.TextureSizeX;
				Ar << PhotoData.TextureSizeY;
			}

			if (Ar.LicenseeVer() >= FXS_VER_POSTER_DATA_UPDATE_3)
			{
				Ar << PhotoData.PhotoType;

				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmHead);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmHaircut);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmBeard);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmTorso);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmHelmet);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmEye);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmTeeth);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmFacePropLower);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmFacePropUpper);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmPatterns);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmScars);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmTorso_Underlay);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmFacePaint);
				PhotoData.PhotoDataSerializeName(Ar, PhotoData.nmTorsoDeco);

				Ar << PhotoData.iGender;
				Ar << PhotoData.iRace;
				Ar << PhotoData.iHairColor;
				Ar << PhotoData.iFacialHair;
				Ar << PhotoData.iSkinColor;
				Ar << PhotoData.iEyeColor;
				Ar << PhotoData.iArmorDeco;
				Ar << PhotoData.iArmorTint;
				Ar << PhotoData.iArmorTintSecondary;
			}

			return Ar;
		}
	}
};

struct native CampaignPhotoData
{
	var int CampaignID;
	var init array<PhotoData> Posters;
	var init array<PhotoData> HeadShots;

	structcpptext
	{
		friend FArchive& operator<<(FArchive& Ar,FCampaignPhotoData& CampaignPhotoData)
		{
			Ar << CampaignPhotoData.CampaignID;
			Ar << CampaignPhotoData.Posters;

			if (Ar.LicenseeVer() >= FXS_VER_POSTER_DATA_UPDATE_2)
			{
				Ar << CampaignPhotoData.HeadShots;
			}

			return Ar;
		}
	}
};

var array<CampaignPhotoData> m_PhotoDatabase;
var array<CampaignPhotoData> m_PhotoDatabase_ForWriting; // This is a copy that is used solely from the async writing task.

var const string m_sDatabaseFilename;

var bool m_bNewPhotos;
var bool m_bDatabaseNeedsWriting;
var bool m_bDatabaseIsWriting;

cpptext
{
	void LoadTextureForPhotoData(FPhotoData& PhotoData);
	void RefreshHeadsTexture(INT CampaignID);
	UTexture2D* GetTexturefor2DArray(FPhotoData& PhotoData);
	void SetAppearanceVariables(const TArray<INT>& ObjectIDs, FPhotoData &NewPoster);
}

native function WriteDatabaseIfNeeded();

native function WritePhotoDatabase();
native function ReadPhotoDatabase();
native function CleanupDatabase();

native function int AddPosterFromSurfData(array<Color> SurfData, int CampaignID, array<int> ObjectIDs, EPhotoDataType PDType, int SizeX, int SizeY);
native function int AddPosterToDatabase(string Filename, int CampaignID, array<int> ObjectIDs, EPhotoDataType PDType, int SizeX, int SizeY, array<Color> SurfData);

native function DeletePoster(int CampaignIndex, int PosterIndex);
native function DeleteDuplicatePoster(int CampaignID, array<int> ObjectIDs, EPhotoDataType PDType);

native function FindAvailableFilename(out string Filename, int CampaignID);

function array<int> GetCampaignIndicesWithPosters()
{
	local array<int> CampaignIndices;
	local int i;

	for (i = 0; i < m_PhotoDatabase.Length; ++i)
	{
		if (m_PhotoDatabase[i].Posters.Length > 0)
			CampaignIndices.AddItem(m_PhotoDatabase[i].CampaignID);
	}

	return CampaignIndices;
}

function SetHasViewedPhotos()
{
	m_bNewPhotos = false;
}

function bool HasNewPhotos()
{
	return m_bNewPhotos;
}

function int GetNumOfPosterForCampaign(int CampaignIndex, bool bExcludeCaptured)
{
	local int i, j, PhotoCount;

	PhotoCount = 0;
	for (i = 0; i < m_PhotoDatabase.Length; ++i)
	{
		if (m_PhotoDatabase[i].CampaignID == CampaignIndex)
		{
			PhotoCount = m_PhotoDatabase[i].Posters.Length;
			if (bExcludeCaptured)
			{
				for (j = 0; j < m_PhotoDatabase[i].Posters.Length; ++j)
				{
					if (m_PhotoDatabase[i].Posters[j].PhotoType == ePDT_Captured)
					{
						--PhotoCount;
					}
				}
			}
			return PhotoCount;
		}
	}

	return PhotoCount;
}

function GetPosterIndices(int CampaignIndex, out array<int> PosterIndices, bool bExcludeCaptured)
{
	local int i, j;

	PosterIndices.Length = 0;
	for (i = 0; i < m_PhotoDatabase.Length; ++i)
	{
		if (m_PhotoDatabase[i].CampaignID == CampaignIndex)
		{
			for (j = 0; j < m_PhotoDatabase[i].Posters.Length; ++j)
			{
				if (!bExcludeCaptured || m_PhotoDatabase[i].Posters[j].PhotoType != ePDT_Captured)
				{
					PosterIndices.AddItem(j);
				}
			}
		}
	}
}

native function Texture2D GetPosterTexture(int CampaignIndex, int PosterIndex);
native function Texture2D GetLatestPoster(int CampaignIndex);
native function Texture2D GetCapturedPoster(int CampaignIndex, int ObjectID);

native function bool HeadshotExistsAndIsCurrent(int CampaignIndex, int ObjectID, XComGameState_Unit UnitState); // This function will delete the headshot if it is not current.
native function Texture2D GetHeadshotTexture(int CampaignIndex, int ObjectID, int SizeX, int SizeY);

native function SetPosterIsFavorite(int CampaignIndex, int PosterIndex, bool IsFavorite);
native function bool GetPosterIsFavorite(int CampaignIndex, int PosterIndex);

native function FillPropagandaTextureArray(EPropagandaWeightMethod WeightMethod, int CampaignID);

native function Init();

function CleanupUnusedTextures()
{
	local int CampaignIndex;
	local int PosterIndex;

	for (CampaignIndex = 0; CampaignIndex < m_PhotoDatabase.Length; ++CampaignIndex)
	{
		for (PosterIndex = 0; PosterIndex < m_PhotoDatabase[CampaignIndex].Posters.Length; ++PosterIndex)
		{
			m_PhotoDatabase[CampaignIndex].Posters[PosterIndex].Texture = none;
		}

		for (PosterIndex = 0; PosterIndex < m_PhotoDatabase[CampaignIndex].HeadShots.Length; ++PosterIndex)
		{
			m_PhotoDatabase[CampaignIndex].HeadShots[PosterIndex].Texture = none;
			m_PhotoDatabase[CampaignIndex].HeadShots[PosterIndex].WantedTexture = none;
			m_PhotoDatabase[CampaignIndex].HeadShots[PosterIndex].SmallTexture = none;
		}
	}
}

defaultproperties
{
	m_sDatabaseFilename="PhotoboothData.x2"
	m_bNewPhotos=false
	m_bDatabaseNeedsWriting=false
	m_bDatabaseIsWriting=false
}