class HUDKismetSeqAct_RenderText extends HUDKismetSeqAct_RenderObject;

// Horizontal alignment options
enum EHorizontalAlignment
{
	EHA_Left<DisplayName=Left>,
	EHA_Center<DisplayName=Center>,
	EHA_Right<DisplayName=Right>
};

// Vertical alignment options
enum EVerticalAlignment
{
	EVA_Top<DisplayName=Top>,
	EVA_Middle<DisplayName=Middle>,
	EVA_Bottom<DisplayName=Bottom>
};

// Condition to using actual position coordinates
var bool UsingActualPosition;
// Condition to using relative position coordinates
var bool UsingRelativePosition;
// Condition to using non localized text (raw input)
var bool UsingNonLocalizedText;
// Condition to using localized text 
var bool UsingLocalizedText;

// Actual position to render the texture
var(RenderText) IntPoint ActualPosition<EditCondition=UsingActualPosition>;
// Relative position, to the viewport resolution, to render the texture
var(RenderText) Vector2D RelativePosition<EditCondition=UsingRelativePosition>;
// Color to render the text
var(RenderText) Color RenderColor<DisplayName=Color>;
// Raw text to render
var(RenderText) String Text<EditCondition=UsingNonLocalizedText>;
// Localization path to get the text from to render
var(RenderText) String LocalizedText<EditCondition=UsingLocalizedText>;
// Horizontal alignment
var(RenderText) EHorizontalAlignment HorizontalAlignment;
// Vertical alignment
var(RenderText) EVerticalAlignment VerticalAlignment;
// Font to render the text
var(RenderText) Font Font;

function Render(Canvas Canvas)
{
	local IntPoint RenderPosition;
	local float TextWidth, TextHeight;
	local String RenderText;
	local SeqVar_String SeqVar_String;

	if (Canvas != None && Font != None && (UsingNonLocalizedText || UsingLocalizedText) && (UsingActualPosition || UsingRelativePosition))
	{
		// Get the render text
		if (UsingNonLocalizedText)
		{
			// Check if the user has set the text variable link
			if (Text ~= "" && VariableLinks[0].LinkedVariables.Length > 0)
			{
				SeqVar_String = SeqVar_String(VariableLinks[0].LinkedVariables[0]);

				if (SeqVar_String != None)
				{
					RenderText = SeqVar_String.StrValue;
				}
			}
			else
			{
				RenderText = Text;
			}
		}
		else
		{
			// Check if the user has set the localized text variable link
			if (LocalizedText ~= "" && VariableLinks[1].LinkedVariables.Length > 0)
			{
				SeqVar_String = SeqVar_String(VariableLinks[1].LinkedVariables[0]);

				if (SeqVar_String != None)
				{
					RenderText = ParseLocalizedPropertyPath(SeqVar_String.StrValue);
				}
			}
			else
			{
				RenderText = ParseLocalizedPropertyPath(LocalizedText);
			}
		}

		if (RenderText != "")
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

			// Set the font
			Canvas.Font = Font;
			// Calculate the size of the text
			Canvas.TextSize(RenderText, TextWidth, TextHeight);

			// Handle the horizontal alignment
			if (HorizontalAlignment == EHA_Center)
			{
				RenderPosition.X -= (TextWidth * 0.5f);
			}
			else if (HorizontalAlignment == EHA_Right)
			{
				RenderPosition.X -= TextWidth;
			}

			// Handle the vertical alignment
			if (VerticalAlignment == EVA_Middle)
			{
				RenderPosition.Y -= (TextHeight * 0.5f);
			}
			else if (VerticalAlignment == EVA_Bottom)
			{
				RenderPosition.Y -= TextHeight;
			}

			// Set the canvas position
			Canvas.SetPos(RenderPosition.X, RenderPosition.Y);
			// Set the text color
			Canvas.SetDrawColor(RenderColor.R, RenderColor.G, RenderColor.B, RenderColor.A);
			// Render the text
			Canvas.DrawText(RenderText);
		}
	}

	Super.Render(Canvas);
}

defaultproperties
{
	RenderColor=(R=255,G=255,B=255,A=255)

	ObjName="Render Text"
	ObjCategory="ExtHUD"

	VariableLinks(0)=(ExpectedType=class'SeqVar_String',LinkDesc="Text",MaxVars=1,PropertyName=Text)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Localized Text",MaxVars=1,PropertyName=LocalizedText)
}