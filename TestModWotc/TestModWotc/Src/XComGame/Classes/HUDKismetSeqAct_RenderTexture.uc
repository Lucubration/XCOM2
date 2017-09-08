class HUDKismetSeqAct_RenderTexture extends HUDKismetSeqAct_RenderObject;

struct TextureRotation
{
	// Amount to rotate the texture in Unreal units (65536 == 360 degrees)
	var() int Rotation;
	// Relative point to perform the rotation (0.5f is at the center)
	var() Vector2D Anchor;

	structdefaultproperties
	{
		Anchor=(X=0.5f,Y=0.5f)
	}
};

struct TextureCoords
{
	var() float U;
	var() float V;
	var() float UL;
	var() float VL;

	structdefaultproperties
	{
		U=0.f
		V=0.f
		UL=-1.f
		VL=-1.f
	}
};

struct TextureStretched
{
	var() bool StretchHorizontally;
	var() bool StretchVertically;
	var() float ScalingFactor;

	structdefaultproperties
	{
		ScalingFactor=1.f
	}
};

// Condition to using actual size coordinates
var bool UsingActualSize;
// Condition to using relative size coordinates
var bool UsingRelativeSize;
// Condition to using actual position coordinates
var bool UsingActualPosition;
// Condition to using relative position coordinates
var bool UsingRelativePosition;
// Condition to using the stretched method
var bool UsingStretched;
// Condition to overriding the blend mode
var bool OverrideBlendMode;

// Texture to render. Overrided if the user sets the texture variable link
var(RenderTexture) Object Texture;
// Actual size to render the texture
var(RenderTexture) IntPoint ActualSize<EditCondition=UsingActualSize>;
// Relative size, to the viewport resolution, to render the texture
var(RenderTexture) Vector2D RelativeSize<EditCondition=UsingRelativeSize>;
// Actual position to render the texture
var(RenderTexture) IntPoint ActualPosition<EditCondition=UsingActualPosition>;
// Relative position, to the viewport resolution, to render the texture
var(RenderTexture) Vector2D RelativePosition<EditCondition=UsingRelativePosition>;
// Rotation of the texture to render
var(RenderTexture) TextureRotation Rotation;
// Coordinates of the texture to render
var(RenderTexture) TextureCoords Coords;
// Color to render the texture
var(RenderTexture) Color RenderColor<DisplayName=Color>;
// Stretched properties when rendering the texture
var(RenderTexture) TextureStretched Stretched<EditCondition=UsingStretched>;
// If the texture is partially outside the rendering bounds, should we clip it? (Only for non rotated, non stretched textures)
var(RenderTexture) bool ClipTile;
// Blend mode for rendering the texture (Only for non rotated, non stretched tiles) (Always overrided for materials on iOS)
var(RenderTexture) EBlendMode BlendMode<EditCondition=OverrideBlendMode>;

function Render(Canvas Canvas)
{
	local IntPoint RenderPosition;
	local IntPoint RenderSize;
	local Texture2D RenderTexture;
	local int UL;
	local int VL;
	local Rotator R;
	local SeqVar_Object SeqVar_Object;

	if (Canvas != None && (UsingActualSize || UsingRelativeSize) && (UsingActualPosition || UsingRelativePosition))
	{
		// Check if the user has set the texture kismet node link
		if (VariableLinks[0].LinkedVariables.Length > 0)
		{
			SeqVar_Object = SeqVar_Object(VariableLinks[0].LinkedVariables[0]);

			if (SeqVar_Object != None)
			{
				RenderTexture = Texture2D(SeqVar_Object.GetObjectValue());
			}
		}
		else
		{
			RenderTexture = Texture2D(Texture);
		}

		if (RenderTexture != None)
		{
			// Calculate the position
			if (UsingRelativePosition)
			{
				RenderPosition.X = Canvas.ClipX * RelativePosition.X;
				RenderPosition.Y = Canvas.ClipY * RelativePosition.Y;
			}
			else
			{
				RenderPosition = ActualPosition;
			}

			// Calculate the size
			if (UsingRelativeSize)
			{
				RenderSize.X = Canvas.ClipX * RelativeSize.X;
				RenderSize.Y = Canvas.ClipY * RelativeSize.Y;
			}
			else
			{
				RenderSize = ActualSize;
			}

			// Calculate the texture width
			UL = (Coords.UL == -1) ? RenderTexture.SizeX : int(Coords.UL);
			// Calculate the texture height
			VL = (Coords.VL == -1) ? RenderTexture.SizeY : int(Coords.VL);

			// Set the position to render
			Canvas.SetPos(RenderPosition.X, RenderPosition.Y);
			// Set the draw color
			Canvas.SetDrawColor(RenderColor.R, RenderColor.G, RenderColor.B, RenderColor.A);

			if (UsingStretched)
			{
				// Render the texture stretched
				Canvas.DrawTileStretched(RenderTexture, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL,, Stretched.StretchHorizontally, Stretched.StretchVertically, Stretched.ScalingFactor);
			}
			else
			{
				if (Rotation.Rotation == 0)
				{
					// Render the texture normally
					if (OverrideBlendMode)
					{					
						Canvas.DrawTile(RenderTexture, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL,, ClipTile, BlendMode);
					}
					else
					{
						Canvas.DrawTile(RenderTexture, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL,, ClipTile);
					}
				}
				else
				{
					// Render the texture rotated
					R.Pitch = 0;
					R.Yaw = Rotation.Rotation;
					R.Roll = 0;
					Canvas.DrawRotatedTile(RenderTexture, R, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL, Rotation.Anchor.X, Rotation.Anchor.Y);
				}
			}
		}
	}

	Super.Render(Canvas);
}

defaultproperties
{
	RenderColor=(R=255,G=255,B=255,A=255)
	
	ObjName="Render Texture"
	ObjCategory="ExtHUD"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Texture",PropertyName=Texture)
}