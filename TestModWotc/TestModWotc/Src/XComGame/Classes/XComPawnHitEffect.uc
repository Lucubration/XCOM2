/**
 * Hit effects that are attached to pawns, e.g blood splatters, flames, etc...
 */
class XComPawnHitEffect extends GenericHitEffect;

simulated function AttachTo(Pawn P, name BoneOrSocketName)
{
	local Vector ShotPosition;
	local Rotator ShotRotation;
	local SkeletalMeshSocket Socket;

	//Remain unattached if there's no way to get a mesh
	if( P == None || P.Mesh == None )
		return;

	Socket = P.Mesh.GetSocketByName(BoneOrSocketName);
	if( Socket != None )
	{
		P.Mesh.AttachComponentToSocket(self.ParticleSystemComponent, BoneOrSocketName);
		return;
	}

	//If we're trying to attach to an invalid bone, attach to the nearest instead
	if( BoneOrSocketName == '' || P.Mesh.MatchRefBone(BoneOrSocketName) == INDEX_NONE )
		BoneOrSocketName = P.Mesh.FindClosestBone(ParticleSystemComponent.GetPosition());

	//If we still don't have a valid bone, abort
	if( BoneOrSocketName == '' || P.Mesh.MatchRefBone(BoneOrSocketName) == INDEX_NONE )
		return;

	P.Mesh.TransformToBoneSpace(BoneOrSocketName, ParticleSystemComponent.GetPosition(), ParticleSystemComponent.GetRotation(), ShotPosition, ShotRotation);
	P.Mesh.AttachComponent(self.ParticleSystemComponent, BoneOrSocketName, ShotPosition, ShotRotation, , );
}

DefaultProperties
{

}
