class HUDKismetSeqAct_RenderObject extends SequenceAction
	abstract;

function Render(Canvas Canvas)
{
	local int i, j;
	local HUDKismetSeqAct_RenderObject RenderObject;

	// Propagate the rendering call to all other child links
	if (OutputLinks.Length > 0)
	{
		for (i = 0; i < OutputLinks.Length; ++i)
		{
			if (OutputLinks[i].Links.Length > 0)
			{
				for (j = 0; j < OutputLinks[i].Links.Length; ++j)
				{
					RenderObject = HUDKismetSeqAct_RenderObject(OutputLinks[i].Links[j].LinkedOp);

					if (RenderObject != None)
					{
						RenderObject.Render(Canvas);
					}
				}
			}
		}
	}
}

defaultproperties
{
	VariableLinks.Empty
}