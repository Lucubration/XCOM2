class PA_Countries extends X2StrategyElement
	dependson(X2CountryTemplate, XGCharacterGenerator);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Countries;
	Countries.AddItem(CreateMecTemplate());
	Countries.AddItem(CreateViperTemplate());
	Countries.AddItem(CreateChrysTemplate());
	Countries.AddItem(CreateMutonTemplate());
	return Countries;
}

static function X2DataTemplate CreateMecTemplate()
{
	local X2CountryTemplate Template;
	local CountryNames NameStruct;
	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Country_Mec');
	NameStruct.MaleNames = class'PA_Names'.default.m_arrMecFirstNames;
	NameStruct.FemaleNames = class'PA_Names'.default.m_arrMecFirstNames;
	NameStruct.MaleLastNames = class'PA_Names'.default.m_arrMecLastNames;
	NameStruct.FemaleLastNames = class'PA_Names'.default.m_arrMecLastNames;
	NameStruct.PercentChance = 100;
	Template.Names.AddItem(NameStruct);
	return Template;
}

static function X2DataTemplate CreateViperTemplate()
{
	local X2CountryTemplate Template;
	local CountryNames NameStruct;
	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Country_Viper');
	NameStruct.MaleNames = class'PA_Names'.default.m_arrVprFirstNames;
	NameStruct.FemaleNames = class'PA_Names'.default.m_arrVprFirstNames;
	NameStruct.MaleLastNames = class'PA_Names'.default.m_arrVprLastNames;
	NameStruct.FemaleLastNames = class'PA_Names'.default.m_arrVprLastNames;
	NameStruct.PercentChance = 100;
	Template.Names.AddItem(NameStruct);
	return Template;
}

static function X2DataTemplate CreateChrysTemplate()
{
	local X2CountryTemplate Template;
	local CountryNames NameStruct;
	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Country_Chrys');
	NameStruct.MaleNames = class'PA_Names'.default.m_arrChyFirstNames;
	NameStruct.FemaleNames = class'PA_Names'.default.m_arrChyFirstNames;
	NameStruct.MaleLastNames = class'PA_Names'.default.m_arrChyLastNames;
	NameStruct.FemaleLastNames = class'PA_Names'.default.m_arrChyLastNames;
	NameStruct.PercentChance = 100;
	Template.Names.AddItem(NameStruct);
	return Template;
}

static function X2DataTemplate CreateMutonTemplate()
{
	local X2CountryTemplate Template;
	local CountryNames NameStruct;
	`CREATE_X2TEMPLATE(class'X2CountryTemplate', Template, 'Country_Muton');
	NameStruct.MaleNames = class'PA_Names'.default.m_arrMutFirstNames;
	NameStruct.FemaleNames = class'PA_Names'.default.m_arrMutFirstNames;
	NameStruct.MaleLastNames = class'PA_Names'.default.m_arrMutLastNames;
	NameStruct.FemaleLastNames = class'PA_Names'.default.m_arrMutLastNames;
	NameStruct.PercentChance = 100;
	Template.Names.AddItem(NameStruct);
	return Template;
}
