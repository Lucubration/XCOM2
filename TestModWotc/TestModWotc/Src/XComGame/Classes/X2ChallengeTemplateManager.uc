//---------------------------------------------------------------------------------------
//  FILE:    X2ChallengeTemplateManager.uc
//  AUTHOR:  Russell Aasland
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2ChallengeTemplateManager extends X2DataTemplateManager
	native(Core);

native static function X2ChallengeTemplateManager GetChallengeTemplateManager( );

function X2ChallengeTemplate FindChallengeTemplate( name DataName )
{
	local X2DataTemplate kTemplate;

	kTemplate = FindDataTemplate( DataName );
	if (kTemplate != none)
	{
		return X2ChallengeTemplate( kTemplate );
	}
	return none;
}

function array<X2ChallengeTemplate> GetAllTemplatesOfClass( class<X2ChallengeTemplate> TemplateClass )
{
	local array<X2ChallengeTemplate> arrTemplates;
	local X2DataTemplate Template;

	foreach IterateTemplates( Template, none )
	{
		if (ClassIsChildOf( Template.Class, TemplateClass ))
		{
			arrTemplates.AddItem( X2ChallengeTemplate( Template ) );
		}
	}

	return arrTemplates;
}

function X2ChallengeTemplate GetRandomChallengeTemplateOfClass( class<X2ChallengeTemplate> TemplateClass, optional array<name> PrevSelectorNames )
{
	local array<X2ChallengeTemplate> AllClass, PreferredClass, RemainingClass;
	local X2ChallengeTemplate Template;
	local int TotalWeight;
	local int RandomWeight;
	local name SelectorName;

	AllClass = GetAllTemplatesOfClass( TemplateClass );
	RemainingClass = AllClass;
	PreferredClass.Length = 0;
	
	// Remove Excluded Templates
	foreach AllClass(Template)
	{
		if(Template.ExcludeSelectorNames.Length == 0)
		{
			continue;
		}

		foreach PrevSelectorNames(SelectorName)
		{
			if(Template.ExcludeSelectorNames.Find(SelectorName) != INDEX_NONE)
			{
				RemainingClass.RemoveItem(Template);
				break;
			}
		}
	}

	// Find Preferred Templates
	foreach RemainingClass(Template)
	{
		if(Template.PreferSelectorNames.Length == 0)
		{
			continue;
		}

		foreach PrevSelectorNames(SelectorName)
		{
			if(Template.PreferSelectorNames.Find(SelectorName) != INDEX_NONE)
			{
				PreferredClass.AddItem(Template);
				break;
			}
		}
	}

	// If there are preferred templates, pick one
	if(PreferredClass.Length > 0)
	{
		TotalWeight = 0;
		foreach PreferredClass(Template)
		{
			TotalWeight += Template.Weight;
		}

		RandomWeight = `SYNC_RAND_STATIC(TotalWeight);

		foreach PreferredClass(Template)
		{
			if(RandomWeight < Template.weight)
			{
				return Template;
			}

			RandomWeight -= Template.Weight;
		}
	}

	// Pick one from non-excluded templates
	if(RemainingClass.Length > 0)
	{
		TotalWeight = 0;
		foreach RemainingClass(Template)
		{
			TotalWeight += Template.Weight;
		}

		RandomWeight = `SYNC_RAND_STATIC(TotalWeight);

		foreach RemainingClass(Template)
		{
			if(RandomWeight < Template.weight)
			{
				return Template;
			}

			RandomWeight -= Template.Weight;
		}
	}

	// Fallback to randomnly selecting from all templates
	TotalWeight = 0;
	foreach AllClass( Template )
	{
		TotalWeight += Template.Weight;
	}

	RandomWeight = `SYNC_RAND_STATIC(TotalWeight);

	foreach AllClass( Template )
	{
		if (RandomWeight < Template.weight)
		{
			return Template;
		}

		RandomWeight -= Template.Weight;
	}
}

DefaultProperties
{
	TemplateDefinitionClass = class'X2ChallengeElement';
}