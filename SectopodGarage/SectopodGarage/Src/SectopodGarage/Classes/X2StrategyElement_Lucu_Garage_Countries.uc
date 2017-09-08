class X2StrategyElement_Lucu_Garage_Countries extends X2StrategyElement
	dependson(X2CountryTemplate, XGCharacterGenerator);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Countries;
	
	Countries.AddItem(XtopodCountry());

	return Countries;
}

static function X2DataTemplate XtopodCountry()
{
	local X2CountryTemplate Template;
	local CountryNames NameStruct;

	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Lucu_Garage_Country_Xtopod');

	NameStruct.MaleNames = class'XGCharacterGenerator'.default.m_arrAmMFirstNames;
	NameStruct.FemaleNames = class'XGCharacterGenerator'.default.m_arrAmFFirstNames;
	NameStruct.MaleLastNames = class'XGCharacterGenerator'.default.m_arrAmLastNames;
	NameStruct.FemaleLastNames = class'XGCharacterGenerator'.default.m_arrAmLastNames;
	NameStruct.PercentChance = 100;
	Template.Names.AddItem(NameStruct);

	return Template;
}
