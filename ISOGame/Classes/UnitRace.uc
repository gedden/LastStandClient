/**
 * Races could also be called 'Body'. It defines the static or Skeletal mesh to be used
 **/
class UnitRace extends UDKUIResourceDataProvider perobjectconfig;

var String raceName;
var config int Id;

/**
 * All the races are defined in the config
 **/
public static function Array<UnitRace> Load()
{
	local array<UDKUIResourceDataProvider> ProviderList;
	local Array<UnitRace> races;
	local UnitRace race;
	local int i;

	// fill the list
	class'UDKUIDataStore_MenuItems'.static.GetAllResourceDataProviders(class'UnitRace', ProviderList);
	races.Add(ProviderList.length);
	for (i = 0; i < ProviderList.length; ++i)
	{
		race            = UnitRace(ProviderList[i]);
		race.raceName   = string(ProviderList[i].name);

		// Hash it in the resulting array
		races[race.id]  = race;

		`log("Races: " @race.raceName @race.id );
	}
	return races;
}
