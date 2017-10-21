/**
 * Common Base class for AkEvents and SoundCues.
 * The goal is mainly to reduce the footprint in the integration.
 */

class AkBaseSoundObject extends Object
	native
	abstract;

cpptext
{
	virtual UBOOL IsAudible( const FVector& SourceLocation, const FVector& ListenerLocation, AActor* SourceActor, INT& bIsOccluded, UBOOL bCheckOcclusion ) {return FALSE;}
}