class Character extends Idol placeable;

var(Custom) SkeletalMeshComponent skeletalMesh;

var AnimNodeSlot FullAnimNodeSlot;

/**
 * Add the set components
 * to this character
 **/
simulated function PostBeginPlay()
{
	// Honor your damm parents!
	super.PostBeginPlay();


	AttachComponent(skeletalMesh);
}

/**
 * This is called after the Anim Tree is loaded
 * 
 * @param SkeletalMeshComponent component created
 **/
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	//skel = SkelComp;
	FullAnimNodeSlot = AnimNodeSlot(SkelComp.FindAnimNode('Over9000'));
}



/**
 * Play an attack
 * 
 * @param SkeletalMeshComponent component created
 **/
function PlayAttack()
{
    FullAnimNodeSlot.PlayCustomAnim('oviraptor_attack' /*AnimSequence.SwordAttack1*/, 1.0, 0.2, 0.2, FALSE, TRUE);
}

function onSelect()
{
	PlayAttack();
	super.onSelect();
}

DefaultProperties
{
	unitName= "Unnamed Character"
	speed   = 20;
	step    = 2;
	size    = 2;
	movementSpeed = 300;
	/*
	Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
		Translation=(X=0,Y=0,Z=50)
		CastShadow=true
		bCastDynamicShadow=true
		bOwnerNoSee=false
        BlockRigidBody=true;
        CollideActors=true;
        BlockZeroExtent=true;

		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
		AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'

		//AnimSets(0)=AnimSet'Test_package.Animations.oviraptor_animations_redo'
		//AnimTreeTemplate=AnimTree'Test_package.Animations.oviraptor_animtree'
		//SkeletalMesh=SkeletalMesh'Test_package.Characters.oviraptor_redo'
	End Object
	*/

	//Components.Add(InitialSkeletalMesh)
}

