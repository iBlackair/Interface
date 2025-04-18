class GMDetailStatusWnd extends DetailStatusWnd;

var String temp1;
var bool bShow;	// GMâ���� ��ư�� �ѹ� �� ������ ������� �ϱ� ���� ����
var UserInfo m_ObservingUserInfo;

function OnRegisterEvent()
{
	RegisterEvent( EV_GMObservingUserInfoUpdate );
	RegisterEvent( EV_GMUpdateHennaInfo );
}

function OnLoad()
{
	temp1= "Water/Air/Ground";
	m_WindowName="GMDetailStatusWnd";

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();
	
	//branch : winkey, GM�� Statusâ UI��ġ ����
	txtHeadMagicCastingSpeed.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 156, 230 );	
	txtMagicCastingSpeed.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 254, 230 );
	txtHeadMovingSpeed.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 156, 247 );
	txtGmMoving.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 156, 274 );
	txtGmMoving.SetText( temp1 );
	txtMovingSpeed.SetAnchor( m_WindowName, "TopLeft", "TopLeft", 156, 262 );
	//end of branch
	
	bShow = false;	//�ʱ�ȭ
}

function OnShow()
{
}

function OnHide()
{
}

function OnEnterState( name a_PreStateName )		// �θ��� DetailStatusWnd �� �ִ°� overriding�ؼ� ���� - lancelot 2007. 7. 30.
{
}

function ShowStatus( String a_Param )
{
	if( a_Param == "" )
		return;

	if(bShow)	//â�� �������� �����ش�.
	{
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else	
	{
		class'GMAPI'.static.RequestGMCommand( GMCOMMAND_StatusInfo, a_Param );
		bShow = true;
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_GMObservingUserInfoUpdate:
		if( HandleGMObservingUserInfoUpdate() )
		{
			m_hOwnerWnd.ShowWindow();
			m_hOwnerWnd.SetFocus();
		}
		break;
	case EV_GMUpdateHennaInfo:
		HandleGMUpdateHennaInfo( a_Param );
		break;
	}
}

function bool HandleGMObservingUserInfoUpdate()
{
	local UserInfo ObservingUserInfo;

	if( class'GMAPI'.static.GetObservingUserInfo( ObservingUserInfo ) )
	{
		HandleUpdateUserInfo();
		return true;
	}
	else
		return false;
}

function HandleGMUpdateHennaInfo( String a_Param )
{
	HandleUpdateHennaInfo( a_Param );
	HandleGMObservingUserInfoUpdate();
}

function bool GetMyUserInfo( out UserInfo a_MyUserInfo )
{
	local bool Result;

	Result = class'GMAPI'.static.GetObservingUserInfo( m_ObservingUserInfo );

	if( Result )
	{
		a_MyUserInfo = m_ObservingUserInfo;
		return true;
	}
	else
		return false;
}

function String GetMovingSpeed( UserInfo a_UserInfo )
{
	local int WaterMaxSpeed;
	local int WaterMinSpeed;
	local int AirMaxSpeed;
	local int AirMinSpeed;
	local int GroundMaxSpeed;
	local int GroundMinSpeed;
	local String MovingSpeed;

	WaterMaxSpeed = int(float(a_UserInfo.nWaterMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier);
	WaterMinSpeed = int(float(a_UserInfo.nWaterMinSpeed) * a_UserInfo.fNonAttackSpeedModifier);
	AirMaxSpeed = int(float(a_UserInfo.nAirMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier);
	AirMinSpeed = int(float(a_UserInfo.nAirMinSpeed) * a_UserInfo.fNonAttackSpeedModifier);
	GroundMaxSpeed = int(float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier);
	GroundMinSpeed = int(float(a_UserInfo.nGroundMinSpeed) * a_UserInfo.fNonAttackSpeedModifier);

	MovingSpeed = String( WaterMaxSpeed ) $ "," $ String( WaterMinSpeed );
	MovingSpeed = MovingSpeed $ "/" $ String( AirMaxSpeed ) $ "," $ String( AirMinSpeed );
	MovingSpeed = MovingSpeed $ "/" $ String( GroundMaxSpeed ) $ "," $ String( GroundMinSpeed );
	//MovingSpeed = MovingSpeed $ "||Water/Air/Ground" ;

	return MovingSpeed;
}

function float GetMyExpRate()
{
	return m_ObservingUserInfo.fExpPercentRate * 100.f;
}

defaultproperties
{
    
}
