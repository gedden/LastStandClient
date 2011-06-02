class ISOUnitTest extends ISOUnit placeable;

var int health;
var int healthMax;
var AnimNodeSlot FullAnimNodeSlot;
var SkeletalMeshComponent skel;
var int called;

simulated function PostBeginPlay()
{
	/*
	local RTSBehavior_Attack attackBehavior;
	super.PostBeginPlay();
	health = healthMax;
	attackBehavior = new class'RTSBehavior_Attack';
	attackBehavior.controlledUnit = self;
	attackBehavior.setAttackFunction(fireAt);
	attackBehavior.attackRange = 200;
	attackBehavior.fireInterval = 1;
	attackBehavior.moveBehavior = class'RTSBehavior_MoveBase';

	addGroundAction(class'RTSBehavior_MoveBase'.static.action);
	addActorAction(attackBehavior.action);
	//rController.addActorAction(class'RTSBehavior_MoveNavMesh'.static.action_follow);
	*/
}

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
	
	//mesh.PlayAnim(

	//super.onSelect();
}

function takeHit(int damage, int type)
{
	/*health -= damage;
	if (health <= 0) { 
		Destroy();
	}*/
}

DefaultProperties
{
	//ProjectileTemplate=class'TestBullet'
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyOtherLightEnvironment
		ModShadowFadeoutTime=0.25
		MinTimeBetweenFullUpdates=0.2
		AmbientGlow=(R=1,G=1,B=1,A=0.5)
		AmbientShadowColor=(R=1,G=1,B=1)
		LightShadowMode=LightShadow_ModulateBetter
		ShadowFilterQuality=SFQ_High
		bSynthesizeSHLight=TRUE
	End Object

	Components.Add(MyOtherLightEnvironment)

	/*
	Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
		Translation=(X=0,Y=0,Z=50)
		CastShadow=true
		bCastDynamicShadow=true
		bOwnerNoSee=false
		LightEnvironment=MyOtherLightEnvironment;
        BlockRigidBody=true;
        CollideActors=true;
        BlockZeroExtent=true;
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
		AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
	End Object
	*/
	Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
		Translation=(X=0,Y=0,Z=50)
		CastShadow=true
		bCastDynamicShadow=true
		bOwnerNoSee=false
		LightEnvironment=MyOtherLightEnvironment;
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

	called = 1
	abilities=(0,1,2,3)
}
