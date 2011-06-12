class Character extends ISOUnit;

var AnimNodeSlot FullAnimNodeSlot;
var SkeletalMeshComponent skel;

/**
 * This is called after the Anim Tree is loaded
 * 
 * @param SkeletalMeshComponent component created
 **/
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	skel = SkelComp;

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
	speed = 12;

	Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
		Translation=(X=0,Y=0,Z=50)
		CastShadow=true
		bCastDynamicShadow=true
		bOwnerNoSee=false
        BlockRigidBody=true;
        CollideActors=true;
        BlockZeroExtent=true;
		//PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimSets(0)=AnimSet'Test_package.Animations.oviraptor_animations_redo'
		//AnimSets(0)=AnimSet'Test_package.Animations.oviraptor_animations_root'
		//AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimTreeTemplate=AnimTree'Test_package.Animations.oviraptor_animtree'
		SkeletalMesh=SkeletalMesh'Test_package.Characters.oviraptor_redo'
	End Object

	Components.Add(InitialSkeletalMesh)
}

