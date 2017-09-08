class X2AmbientNarrativeCriteria_Lucu_Sniper_TemplateModificator extends X2AmbientNarrativeCriteria;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// This turns out to be a good hook for doing global template modification because subclasses of X2AmbientNarrativeCriteria
	// are the last ones loaded when the game is setting up. We'll just return an empty list of templates for template creation
	// (because we're not actually using this to create any templates) and put our template modifications in-between
	Templates.Length = 0;

	return Templates;
}
