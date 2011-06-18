/**
 * This tech has idols!
 * 
 * Namely, Characters and Structures
 **/
class Unit extends Tech;

var IdolTemplate template;
var Idol idol;


/**
 * Create the idol
 **/
public function Idol SpawnIdol(const out WorldInfo WorldInfo, const ISONode node, const int instanceId)
{
	/*
	if( type == STRUCTURE )
		idol = SpawnStructure(WorldInfo);
	else
		idol = SpawnCharacter(WorldInfo);
	*/

	idol = WorldInfo.Spawn(template.GetIdolClass(),,,,, template.GetArchetype());

	idol.SetLocation(node.GetCentroid());
	idol.SetNode(node);
	idol.instanceId = instanceId;

	// Set the template and all the idol stats
	idol.SetFromTemplate(self);


	return idol;
}

/*
/**
 * Create a structure
 **/
private function Structure SpawnStructure(const out WorldInfo WorldInfo)
{
	local Structure arch;
	local Structure idol;

	arch = Structure(DynamicLoadObject(template.archetypeName, class'Structure'));
	idol = WorldInfo.Spawn(class'Structure',,,,, arch);

	return idol;
}

/**
 * Create a structure
 **/
private function Character SpawnCharacter(const out WorldInfo WorldInfo)
{
	local Character arch;
	local Character idol;

	arch = Character(DynamicLoadObject(template.GetArchetypeName(), class'Character'));
	idol = WorldInfo.Spawn(class'Character',,,,, arch);

	return idol;
}
*/

DefaultProperties
{
	idol    = None;
	template= None;
}
