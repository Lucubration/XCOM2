class UITacticalHUD_Lucu_Garage_Counter extends UIPanel;

var UIBGBox BG;
var UIImage Image;
var UIText CounterText;

simulated function UITacticalHUD_Lucu_Garage_Counter InitCounter(string imagePath, string textColor, int initX, int initY, int initAnchor)
{
	InitPanel();
	
	BG = Spawn(class'UIBGBox', self).InitBG('', 0, 0, 150, 40);
	BG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	BG.SetAnchor(class'UIUtilities'.const.ANCHOR_TOP_LEFT);
	BG.SetAlpha(55.0f);
	BG.SetAnchor(initAnchor);
	BG.SetPosition(initX, initY);

	CounterText = Spawn(class'UIText', self).InitText();
	CounterText.Height = 40;
	CounterText.Width = 100;
	CounterText.SetAnchor(initAnchor);
	CounterText.SetPosition(initX + 50, initY + 4);
	CounterText.SetColor(textColor);
	
	Image = Spawn(class'UIImage', self).InitImage('', imagePath);
	Image.SetAnchor(initAnchor);
	Image.SetPosition(initX + 9, initY + 4);
	Image.SetSize(32, 32);

	Hide();

	return self;
}

simulated function OnInit()
{
	super.OnInit();
}

function simulated SetText(string newText)
{
	//CounterText.SetHTMLText(class'UIUtilities_Text'.static.AlignRight(newText));
	CounterText.SetHTMLText(class'UIUtilities_Text'.static.StyleText(newText, eUITextStyle_Tooltip_Title));
}
