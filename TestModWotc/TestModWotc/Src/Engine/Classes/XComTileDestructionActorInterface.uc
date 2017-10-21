/**
 * XComTileDestructionActor
 * Author: Scott Boeckmann
 * Description: Actor used to indicate tiles that need to be destroyed on tactical start.
 */
class XComTileDestructionActorInterface extends Actor
	native;

cpptext
{
	virtual void AddTile(const FVector& Position) {};
	virtual void RemoveTile(const FVector& Position) {};

	virtual void UpdateTileVisuals() {};

	virtual void SetCompHidden(UBOOL bNewHidden) {};

	virtual INT GetNumOfDestructionTiles() { return 0; }
}

defaultproperties
{
}