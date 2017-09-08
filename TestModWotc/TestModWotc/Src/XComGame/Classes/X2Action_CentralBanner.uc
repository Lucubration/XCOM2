class X2Action_CentralBanner extends X2Action;

var string BannerText;
var EUIState BannerState;

simulated state Executing
{
	function UpdateBanner()
	{
		local UITacticalHUDMessageBanner Banner;
		Banner = `PRES.m_kTacticalHUD.m_kMessageBanner;

		if( BannerText == "" )
		{
			Banner.AnimateOut();
		}
		else
		{
			switch( BannerState )
			{
			case eUIState_Good:	
				Banner.SetStyleGood();		
				break;
			case eUIState_Bad:		
				Banner.SetStyleBad();		
				break;
			case eUIState_Normal:	
				Banner.SetStyleNeutral();	
				break;
			default:		
				Banner.SetStyleNeutral();	
				break;
			}

			Banner.SetBanner(BannerText);
		}
	}


Begin:
	UpdateBanner();

	CompleteAction();
}

DefaultProperties
{	
}
