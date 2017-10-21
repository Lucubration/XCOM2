/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AnimNodeMirror extends AnimNodeBlendBase
	native(Anim)
	hidecategories(Object);

var()	bool	bEnableMirroring;

cpptext
{
	virtual void GetBoneAtoms(FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys);

#if PS3 //HK_TCS_PS3_SPU_SKELPOSE
	virtual void GetActiveAtoms( TArray<UAnimNode*> & ActiveNodes );
#endif
}

defaultproperties
{
	Children(0)=(Name="Child",Weight=1.0)
	bFixNumChildren=true

	bEnableMirroring=false

	CategoryDesc = "Mirror"
}
