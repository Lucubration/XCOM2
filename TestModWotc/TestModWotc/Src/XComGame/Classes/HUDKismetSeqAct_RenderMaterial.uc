class HUDKismetSeqAct_RenderMaterial extends HUDKismetSeqAct_RenderTexture;

// Material to render. Overrided if the user sets the material variable link
var(RenderMaterial) Object Material;

function Render(Canvas Canvas)
{
	local IntPoint RenderPosition;
	local IntPoint RenderSize;
	local MaterialInterface RenderMaterialInterface;
	local Material RenderMaterial;
	local int UL;
	local int VL;
	local Rotator R;
	local SeqVar_Object SeqVar_Object;
	local WorldInfo worldInfo;

	// Check if we're allowed to run on this platform
	WorldInfo = class'WorldInfo'.static.GetWorldInfo();
	if (WorldInfo != None && (WorldInfo.IsConsoleBuild(CONSOLE_Mobile) || WorldInfo.IsConsoleBuild(CONSOLE_IPhone)))
	{
		// Check if the user has set the material kismet node link
		if (VariableLinks[0].LinkedVariables.Length > 0)
		{
			SeqVar_Object = SeqVar_Object(VariableLinks[0].LinkedVariables[0]);

			if (SeqVar_Object != None)
			{
				if (MaterialInterface(SeqVar_Object.GetObjectValue()) != None)
				{
					RenderMaterialInterface = MaterialInterface(SeqVar_Object.GetObjectValue());
				}
				else if (MaterialInstanceActor(SeqVar_Object.GetObjectValue()) != None)
				{
					RenderMaterialInterface = MaterialInstanceActor(SeqVar_Object.GetObjectValue()).MatInst;
				}
			}
		}
		else
		{
			if (MaterialInterface(Material) != None)
			{
				RenderMaterialInterface = MaterialInterface(Material);
			}
			else if (MaterialInstanceActor(Material) != None)
			{
				RenderMaterialInterface = MaterialInstanceActor(Material).MatInst;
			}
		}

		if (RenderMaterialInterface != None)
		{
			RenderMaterial = Material(RenderMaterialInterface);
			if (RenderMaterial != None)
			{
				OverrideBlendMode = true;
				BlendMode = RenderMaterial.BlendMode;
			}

			Texture = RenderMaterialInterface.MobileBaseTexture;

			if (Texture != None)
			{
				Super.Render(Canvas);
			}
		}		
	}
	else 
	{
		if (Canvas != None && (UsingActualSize || UsingRelativeSize) && (UsingActualPosition || UsingRelativePosition))
		{
			// Check if the user has set the material kismet node link
			if (VariableLinks[0].LinkedVariables.Length > 0)
			{
				SeqVar_Object = SeqVar_Object(VariableLinks[0].LinkedVariables[0]);

				if (SeqVar_Object != None)
				{
					if (MaterialInterface(SeqVar_Object.GetObjectValue()) != None)
					{
						RenderMaterialInterface = MaterialInterface(SeqVar_Object.GetObjectValue());
					}
					else if (MaterialInstanceActor(SeqVar_Object.GetObjectValue()) != None)
					{
						RenderMaterialInterface = MaterialInstanceActor(SeqVar_Object.GetObjectValue()).MatInst;
					}
				}
			}
			else
			{
				if (MaterialInterface(Material) != None)
				{
					RenderMaterialInterface = MaterialInterface(Material);
				}
				else if (MaterialInstanceActor(Material) != None)
				{
					RenderMaterialInterface = MaterialInstanceActor(Material).MatInst;
				}
			}

			if (RenderMaterialInterface != None)
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
				UL = (Coords.UL == -1) ? 1.f : Coords.UL;
				// Calculate the texture height
				VL = (Coords.VL == -1) ? 1.f : Coords.VL;

				// Set the position to render
				Canvas.SetPos(RenderPosition.X, RenderPosition.Y);

				if (Rotation.Rotation == 0)
				{
					// Render the material normally
					Canvas.DrawMaterialTile(RenderMaterialInterface, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL);
				}
				else
				{
					// Render the material rotated
					R.Pitch = 0;
					R.Yaw = Rotation.Rotation;
					R.Roll = 0;
					Canvas.DrawRotatedMaterialTile(RenderMaterialInterface, R, RenderSize.X, RenderSize.Y, Coords.U, Coords.V, UL, VL, Rotation.Anchor.X, Rotation.Anchor.Y);
				}
			}
		}

		Super(HUDKismetSeqAct_RenderObject).Render(Canvas);
	}
}

defaultproperties
{
	ObjName="Render Material"
	ObjCategory="ExtHUD"

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Material",PropertyName=Material)
}