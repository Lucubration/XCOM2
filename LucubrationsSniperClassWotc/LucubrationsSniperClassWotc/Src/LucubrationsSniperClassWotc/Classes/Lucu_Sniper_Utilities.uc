class Lucu_Sniper_Utilities extends Object;

static function int GetItemTechTier(X2ItemTemplate ItemTemplate)
{
    // I made a poor assumption initially that 'Tier' was a better indicator of power than stuff like 'WeaponTech'.
    // Modders are using 'Tier' to sort items, though, so there are some pretty outlandish tier numbers out there.
    // I'm going to convert various item tech names to the existing configured bonus value tiers
    local X2WeaponTemplate WeaponTemplate;
    
    if (ItemTemplate.ItemCat == 'weapon')
    {
        WeaponTemplate = X2WeaponTemplate(ItemTemplate);
        if (WeaponTemplate != none)
        {
            if (WeaponTemplate.WeaponTech == 'beam')
                return 4;
            if (WeaponTemplate.WeaponTech == 'magnetic')
                return 2;
        }
    }

    // Default to conventional bonus
    return 0;
}