class XComArmsContent extends Actor
	native(Unit)
	hidecategories(Movement,Display,Attachment,Actor,Collision,Physics,Debug,Object,Advanced);

var() SkeletalMesh SkeletalMesh;
var() MaterialInterface OverrideMaterial <ToolTip = "Allows a material override to specified for this body part. The material will be assigned to the skeletal mesh when the part is attached">;
var() int OverrideMaterialIndex <ToolTip = "Controls which material index is overridden by the OverrideMaterial">;
var() bool bHideForearms<ToolTip = "Indicates whether this body part should hide any forearm deco when it is used">;