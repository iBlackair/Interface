class OlympiadSummonWnd extends UICommonAPI;

var WindowHandle Me;

var WindowHandle		m_SummonWnd;
var BarHandle			m_BarHP;
var NameCtrlHandle		m_SummonName;

//var TextBoxHandle deadz_TargetMP;
//var TextBoxHandle deadz_TargetHP;

var int		m_ID;
var string		m_Name;
var int		m_ClassID;
var int		m_MaxHP;
var int		m_CurHP;


var OlympiadDmgWnd script_olydmg;

function OnRegisterEvent()
{
	RegisterEvent( EV_OlympiadTargetShow );
	RegisterEvent( EV_OlympiadUserInfo );
	RegisterEvent( EV_OlympiadMatchEnd );
	RegisterEvent( EV_ReceiveAttack );
	RegisterEvent( EV_ReceiveMagicSkillUse );		
}

function OnLoad()
{
	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "OlympiadSummonWnd" );

		m_BarHP = BarHandle( GetHandle("OlympiadSummonWnd.barhp"));
		m_SummonName = NameCtrlHandle( GetHandle("OlympiadSummonWnd.SummonName"));
		//deadz_TargetHP = TextBoxHandle(GetHandle("OlympiadSummonWnd.TargetHP"));
		//deadz_TargetMP = TextBoxHandle(GetHandle("OlympiadSummonWnd.TargetMP"));

	}
	else
	{
		Me = GetWindowHandle( "OlympiadSummonWnd" );
		
		m_BarHP = GetBarHandle("OlympiadSummonWnd.barhp");
		m_SummonName = GetNameCtrlHandle("OlympiadSummonWnd.SummonName");
		//deadz_TargetHP = GetTextBoxHandle("OlympiadSummonWnd.TargetHP");
		//deadz_TargetMP = GetTextBoxHandle("OlympiadSummonWnd.TargetMP");
		
	}
	
	script_olydmg = OlympiadDmgWnd(GetScript("OlympiadDmgWnd"));
	
	Me.HideWindow();
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_OlympiadTargetShow)
	{
		Clear();
	}
	else if (Event_ID == EV_OlympiadMatchEnd)
	{
		Clear();
		HideAllWindow();
	}
	else if (Event_ID == EV_ReceiveMagicSkillUse)
	{
		//HandleReceiveMagicSkillUse(param);
		UpdateStatus();
	}
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y) {
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10) 
		RequestTargetUser(script_olydmg.m_PetID);
}

function GetPetsHP()
{
	local UserInfo thisInfo;
	
	if ( GetUserInfo( script_olydmg.m_PetID, thisInfo ) )
		{
			m_MaxHP = thisInfo.nMaxHP;
			m_CurHP = thisInfo.nCurHP;
			
			m_Name = thisInfo.Name;
			
			if (!class'UIAPI_WINDOW'.static.IsShowWindow("OlympiadSummonWnd") && !class'UIAPI_WINDOW'.static.IsShowWindow("OlympiadSummonWnd.barhp") && !class'UIAPI_WINDOW'.static.IsShowWindow("OlympiadSummonWnd.SummonName"))
			{
				AddSystemMessageString("WINDOWS SHOWN");
				class'UIAPI_WINDOW'.static.ShowWindow("OlympiadSummonWnd");
				class'UIAPI_WINDOW'.static.ShowWindow("OlympiadSummonWnd.barhp");
				class'UIAPI_WINDOW'.static.ShowWindow("OlympiadSummonWnd.SummonName");
			}
		}
}

function OnEnterState( name a_PreStateName )
{
	Clear();
}

function Clear()
{

		m_ID = 0;
		m_Name = "";
		m_ClassID = 0;
		m_MaxHP = 0;
		m_CurHP = 0;
	
	UpdateStatus();


}

function UpdateStatus()
{

	m_SummonName.SetName(m_Name, NCT_Normal,TA_Center);
		
	// HP
	if (m_MaxHP > 0)
	{
		m_BarHP.SetValue (m_MaxHP , m_CurHP);
		//enemyHP.GetValue(VisibleMaxHP, VisibleCurHP);
		//deadz_TargetHP.SetAlign(TA_Center);
		//deadz_TargetHP.SetText(VisibleCurHP $ " / " $ VisibleMaxHP);
	}
	else
	{
		m_BarHP.SetValue ( 0 , 0);
	}
		
}

function HideAllWindow()
{
	me.hidewindow();
	m_BarHP.hidewindow();
	m_SummonName.hidewindow();
	//deadz_TargetCP.hidewindow();
	//deadz_TargetHP.hidewindow();
}

defaultproperties
{
}
