class GFxGameHUD extends GFxHUD;

/**
 * Show the proper information
 * in the lower hud
 **/
function ShowHUD(Tech tech)
{

	/*
	SetStats(base.GetHealth(), base.GetSpeed(), base.GetAttack(), base.GetDefense());
	SetName(base.GetName());
	*/

	if( tech.IsA('Unit') )
		ShowUnitHUD( Unit(tech) );

	lowerHUD.ActionScriptVoid("ShowHUD");
}

/**
 * Show the unit in the hud
 **/
function ShowUnitHUD(Unit unit)
{
	local IdolTemplate template;

	

	// If im NOT spawned, show the base stats
	if( unit.idol == none )
	{
		template = unit.template;
		SetName( template.GetName() );
		SetStats(template.GetHealth(), template.GetSpeed(), template.GetAttack(), template.GetDefense());
	}
	else
	{
		template = unit.template;
		SetName( template.GetName() );
		SetStats(template.GetHealth(), template.GetSpeed(), template.GetAttack(), template.GetDefense());
	}

	
}

function HideHUD()
{
	lowerHUD.ActionScriptVoid("HideHUD");
}

DefaultProperties
{
}
