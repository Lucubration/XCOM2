class XGCharacterGenerator_SPARK extends XGCharacterGenerator
	dependson(X2StrategyGameRulesetDataStructures);

var localized string SparkFirstName;
var localized string SparkLastNamePrefix;

function GenerateName( int iGender, name CountryName, out string strFirst, out string strLast, optional int iRace = -1 )
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local int SparkIndex, idx;
	local bool bUseRandomNum;

	strFirst = SparkFirstName;
	strLast = SparkLastNamePrefix;
	SparkIndex = 1;
	bUseRandomNum = true;

	History = `XCOMHISTORY;

	if(History != none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

		if(XComHQ != none)
		{
			bUseRandomNum = false;

			for(idx = 0; idx < XComHQ.Crew.Length; idx++)
			{
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));

				if(UnitState != none && UnitState.GetMyTemplateName() == 'SparkSoldier')
				{
					SparkIndex++;
				}
			}

			for(idx = 0; idx < XComHQ.DeadCrew.Length; idx++)
			{
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.DeadCrew[idx].ObjectID));

				if(UnitState != none && UnitState.GetMyTemplateName() == 'SparkSoldier')
				{
					SparkIndex++;
				}
			}
		}
	}

	if(bUseRandomNum)
	{
		SparkIndex = `SYNC_RAND(999) + 1;
	}

	strLast = strLast $ SparkIndex;
	strLast = Right(strLast, 3);

	// Sparks only have last name so combine both names into last name
	strLast = strFirst $ strLast;
	strFirst = "";
}

function bool IsSoldier(name CharacterTemplateName)
{
	return true;
}

function Name GetLanguageName(name CountryName)
{
	return GetLanguageByString();
}

function X2CharacterTemplate SetCharacterTemplate(name CharacterTemplateName, name ArmorName)
{
	MatchArmorTemplateForTorso = (ArmorName == '') ? 'SparkArmor' : ArmorName;
	MatchCharacterTemplateForTorso = 'NoCharacterTemplateName'; //Force the selector to use the armor type to filter torsos

	return class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('SparkSoldier');
}

function SetCountry(name nmCountry)
{
	kSoldier.nmCountry = 'Country_Spark';
	kSoldier.kAppearance.nmFlag = kSoldier.nmCountry; // needs to be copied here for pawns -- jboswell
}

function SetRace(int iRace)
{
	kSoldier.kAppearance.iRace = 0;
}

function SetGender(EGender eForceGender)
{
	kSoldier.kAppearance.iGender = eGender_None;
}

function SetHead(X2SimpleBodyPartFilter BodyPartFilter, X2CharacterTemplate CharacterTemplate)
{
	local X2BodyPartTemplateManager PartTemplateManager;

	PartTemplateManager = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();

	kSoldier.kAppearance.nmHaircut = '';
	
	BodyPartFilter.AddCharacterFilter(CharacterTemplate.DataName);
	RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmHead, "Head", BodyPartFilter.FilterByGenderAndRaceAndCharacterAndTech);
	kSoldier.kAppearance.nmEye = '';
	kSoldier.kAppearance.nmTeeth = '';
}

function SetAccessories(X2SimpleBodyPartFilter BodyPartFilter, name CharacterTemplateName)
{
	local X2BodyPartTemplateManager PartTemplateManager;

	PartTemplateManager = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();

	//Turn off most customization options for the Spark
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmPatterns, "Patterns", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmWeaponPattern, "Patterns", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmTattoo_LeftArm, "Tattoos", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmTattoo_RightArm, "Tattoos", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmBeard, "Beards", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmHelmet, "Helmets", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmFacePropLower, "FacePropsLower", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmFacePropUpper, "FacePropsUpper", BodyPartFilter.FilterAny);
}

function SetUnderlay(out X2SimpleBodyPartFilter BodyPartFilter)
{
	//Set the underlays to match the other torso, arms, and legs, so they have something in those slots
	kSoldier.kAppearance.nmTorso_Underlay = kSoldier.kAppearance.nmTorso;
	kSoldier.kAppearance.nmLegs_Underlay = kSoldier.kAppearance.nmLegs;
	kSoldier.kAppearance.nmArms_Underlay = kSoldier.kAppearance.nmArms;
}

function SetVoice(name CharacterTemplateName, name CountryName)
{
	// Determine voice	
	kSoldier.kAppearance.nmVoice = GetVoiceFromCountryAndGender(CountryName, kSoldier.kAppearance.iGender);
	if (kSoldier.kAppearance.nmVoice == '')
	{
		kSoldier.kAppearance.nmVoice = 'SparkCalmVoice1_English';
	}
}

function SetAttitude()
{
	kSoldier.kAppearance.iAttitude = 2; // Should correspond with Personality_Normal
}