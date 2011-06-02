class ISOUnitTest2 extends ISOUnit placeable;

DefaultProperties
{
	speed=150

	Begin Object Class=SkeletalMeshComponent Name=InitialSkeletalMesh
		Translation=(X=0,Y=0,Z=50)
		CastShadow=true
		bCastDynamicShadow=true
		bOwnerNoSee=false
		//LightEnvironment=MyOtherLightEnvironment;
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
	abilities=(0,1,2,3)
}
