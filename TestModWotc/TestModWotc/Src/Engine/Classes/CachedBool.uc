
class CachedBool extends Object;



var private bool m_value;
var private bool m_lastQueryValue;
var private bool m_bHasEverBeenQueried;


function SetValue( bool newValue )
{
	if( m_value != newValue )
	{
		m_value = newValue;
	}
}

function bool GetValue()
{
	return m_value;
}

function bool HasChanged()
{
	local bool bHasChanged;

	if( !m_bHasEverBeenQueried)
	{
		m_bHasEverBeenQueried = true;
		bHasChanged = true;
	}
	else
	{
		bHasChanged = m_lastQueryValue != m_value;
	}

		if(bHasChanged)
		{
			m_lastQueryValue = m_value;
		}

		return bHasChanged;
}




