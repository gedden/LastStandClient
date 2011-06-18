class UnitClass extends UDKUIResourceDataProvider perobjectconfig;

var String className;
var config int Id;

/**
 * All the classes are defined in the config
 **/
public static function Array<UnitClass> Load()
{
	local array<UDKUIResourceDataProvider> ProviderList;
	local Array<UnitClass> classes;
	local UnitClass c;
	local int i;

	// fill the list
	class'UDKUIDataStore_MenuItems'.static.GetAllResourceDataProviders(class'UnitClass', ProviderList);
	classes.length = ProviderList.length;
	for (i = 0; i < ProviderList.length; ++i)
	{
		c            = UnitClass(ProviderList[i]);
		c.className  = string(ProviderList[i].name);

		// Hash it in the resulting array
		classes[c.id]  = c;

		`log("Class : " @c.className );
	}
	return classes;
}
