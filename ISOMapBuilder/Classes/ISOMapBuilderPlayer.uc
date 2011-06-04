class ISOMapBuilderPlayer extends ISOCorePlayerController;

auto state ISOPlayerEdit extends ISOPlayerTurn
{
	ignores SeePlayer, HearNoise, NotifyBump, TakeDamage, PhysicsVolumeChange, NextWeapon, PrevWeapon, SwitchToBestWeapon;

	/*
	exec function onSelect()
	{
		/*
		local Vector loc;
		local Vector norm;

		ISOSelect = !ISOSelect;

		ISOHUD(myHUD).getStuffUnderMouse(loc, norm, selected);
		*/
		/*
		if( unit != none && unit.isSelected )
		{
			unit.MoveTo(loc);
		}

		nextUnit = ISOUnit(selected);

		// De-select the old unit
		if( nextUnit==none || nextUnit!=unit )
		{
			unit.onDeselect(true);
			unit = nextUnit;
		}


		if( unit != none )
		{
			if( !unit.isSelected )
				unit.onSelect();

		}
		*/
	}
	*/

}

DefaultProperties
{
}
