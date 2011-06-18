class Structure extends Idol placeable;

var(Custom) StaticMeshComponent template;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	`log("Structure Post Begin Play!");
	AttachComponent(template);
}

DefaultProperties
{
	unitName= "Unamed Building";

	speed = 0;
	/*
	other = StaticMesh'Berserk.Mesh.S_Pickups_Berserk'

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'Berserk.Mesh.S_Pickups_Berserk'
		//StaticMesh=other;
		Scale=2
	End Object
	Components.Add(StaticMeshComponent0)
	*/
}
