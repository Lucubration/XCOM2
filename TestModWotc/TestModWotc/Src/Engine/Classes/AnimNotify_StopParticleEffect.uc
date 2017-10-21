/* FIRAXIS
 * Stops a particle effect on a particular bone or socket
 */
class AnimNotify_StopParticleEffect extends AnimNotify
	native(Anim);

/** The Particle system to stop **/
var(ParticleSystems) ParticleSystem PSTemplate;

/** The socketname in which to play the particle effect.  Looks for a socket name first then bone name **/
var() name SocketName;

/** The bone name in which to play the particle effect. Looks for a socket name first then bone name **/
var() name BoneName;

/** Stops and removes it immediately **/
var() bool bImmediate;

cpptext
{
	// AnimNotify interface.
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment();
	virtual FColor GetEditorColor() { return FColor(255, 0, 0); }
}