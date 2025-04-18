
class RecommendBonusWnd extends UICommonAPI;


var		WindowHandle				Navit_Tooltip_Icon;
var		WindowHandle				Navit_Tooltip_Gauge;
var		TextureHandle				Navit_Tex_Glow;
var		TextureHandle				Navit_Tex_Icon;
var		TextureHandle				Navit_Tex_Gauge;
var		bool						m_bNavit;
var		int							m_Navit_Level;
var		int							m_NavitEffectRemainSec;
var		int							m_NavitIConFactor;			// �׺�Ʈ �ߵ� �� ������ �����ӿ� ����
var		int							m_NavitGaugeFactor;			// �׺�Ʈ �ܰ� ��ȭ �ÿ� ������ Ƚ��, �Ҹ꿡 ����

const 	NAVIT_TIMER_ID_TOOLTIP		= 7000;						// �׺�Ʈ �ߵ� �� ������ ����ϴ� Ÿ�̸�
const 	NAVIT_TIMER_ID_ICON			= 7001;						// �׺�Ʈ �ߵ� �� ������ �ִϸ��̼ǿ� ����ϴ� Ÿ�̸�
const 	NAVIT_TIMER_ID_GAUGE		= 7002;						// �׺�Ʈ �ܰ� ��ȭ �� ȿ���� ����ϴ� Ÿ�̸�
const 	NAVIT_TIMER_DELAY_TOOLTIP	= 1000;	
const 	NAVIT_TIMER_DELAY_ICON		= 500;	
const 	NAVIT_TIMER_DELAY_GAUGE		= 500;	
const 	NAVIT_MAX_POINT				= 7200;						// �׺�Ʈ ���� ȿ�� �ߵ� ����Ʈ
const 	NAVIT_MAX_TIME				= 14400;					// �׺�Ʈ ���ʽ� �ð� �ִ�ġ
const 	ANIM_MIN_ALPHA				= 39;
const 	ANIM_MAX_ALPHA				= 197;
const 	ANIM_SPEEDFLOAT				= 0.40f;

const TIMER_ID=1050;                                            // ID (������ Ÿ�̸� ��Ģ�� ���µ�, ���� ���� �˻��ؼ� ����)
const TIMER_DELAY=1000;                                         // 1�� ���� delay


var WindowHandle Me;
var RecommendBonusHelpHtmlWnd RecommendBonusHelpHtmlWndScript;	// ��õ ����â 

var ButtonHandle helpHtmlPopupButton;
var ButtonHandle recommendBonusWndCloseButton;

var TextBoxHandle bonusExpTextBox2;                             // ���ʽ� Exp ǥ��
var TextBoxHandle bonusTimeLimitTextBox2;                       // ���ʽ� �ð� ǥ��

var int currentRemainTimeValue;                                 // ���� ���ʽ� �ð�

//branch : gorillazin 10. 04. 14. - new vote event
var bool m_bIsNewVoteEvent;
var bool m_bIsFirstNewVoteEventMessage;
//end of branch


function OnRegisterEvent()
{
	RegisterEvent( EV_ReceiveNewVoteSystemInfo );	
	RegisterEvent( EV_NavitAdventPointInfo );
	RegisterEvent( EV_NavitAdventEffect );
	RegisterEvent( EV_NavitAdventTimeChange );
}


function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		currentRemainTimeValue = currentRemainTimeValue - 1;
		UpdateTime(currentRemainTimeValue);
	}

	else if( TimerID == NAVIT_TIMER_ID_TOOLTIP )		TimerNavitToolTip();
	else if( TimerID == NAVIT_TIMER_ID_ICON )			TimerNavitIconBlink();
	else if( TimerID == NAVIT_TIMER_ID_GAUGE )			TimerNavitGaugeBlink();
	
}


function OnLoad()
{
	OnRegisterEvent();
	
	m_Navit_Level=-1;
	
	Me = GetWindowHandle("RecommendBonusWnd");

	recommendBonusWndCloseButton = GetButtonHandle("RecommendBonusWnd.recommendBonusWndCloseButton");
	helpHtmlPopupButton = GetButtonHandle("RecommendBonusWnd.helpHtmlPopupButton");

	bonusExpTextBox2 = GetTextboxHandle("RecommendBonusWnd.NavitBless_Txt_Prog_Sys");
	bonusTimeLimitTextBox2 = GetTextboxHandle("RecommendBonusWnd.NavitBless_Txt_Time_Sys");

	RecommendBonusHelpHtmlWndScript = RecommendBonusHelpHtmlWnd( GetScript("RecommendBonusHelpHtmlWnd") );

	Navit_Tooltip_Icon			= GetWindowHandle( "RecommendBonusWnd.NavitAdv_Tooltip_Icon" );
	Navit_Tooltip_Gauge			= GetWindowHandle( "RecommendBonusWnd.NavitAdv_Tooltip_Gauge" );
	Navit_Tex_Glow				= GetTextureHandle( "RecommendBonusWnd.NavitAdv_Tex_Glow" );
	Navit_Tex_Icon				= GetTextureHandle( "RecommendBonusWnd.NavitAdv_Tex_Icon" );
	Navit_Tex_Gauge				= GetTextureHandle( "RecommendBonusWnd.NavitAdv_Tex_Gauge" );

	// Init
	Navit_Tex_Glow.SetAlpha( 0 );
	
	//branch : gorillazin 10. 04. 14. - new vote event
	m_bIsNewVoteEvent = false;
	m_bIsFirstNewVoteEventMessage = false;
	//end of branch
}


function OnShow()
{
	//debug("onShow - recommend ");	
}


function OnClickButton( String a_ButtonID )
{
	// debug("a_ButtonID " @ a_ButtonID);
	switch( a_ButtonID )
	{
		case "VitalBonus_Btn_helpHtml":
			OnReCommendBonusHelpClick();
			break;

		case "VitalBonus_Btn_Close":
			// class'UIAPI_WINDOW'.static.HideWindow("RecommendBonusWnd");

			Me.HideWindow();
			break;
	}
}


function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
		case EV_ReceiveNewVoteSystemInfo: getDataByServer(a_param);break;
		case EV_NavitAdventPointInfo		: HandleNavitPointInfo(a_Param);		break;
		case EV_NavitAdventEffect			: HandleNavitEffect(a_Param);			break;
		case EV_NavitAdventTimeChange		: HandleNavitTimeChange(a_Param);		break;
	}
}


function OnReCommendBonusHelpClick()
{	

	local string strParam;
	
	if(IsShowWindow("RecommendBonusHelpHtmlWnd"))
	{
		HideWindow("RecommendBonusHelpHtmlWnd");		
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetFocus("RecommendBonusHelpHtmlWnd");	
		ParamAdd(strParam, "FilePath", "..\\L2text\\event_2010_bless001.htm");
		ExecuteEvent(EV_ShowNewVoteSystemHelp);
	}
}


function OnEnterState( name a_PreStateName )
{	
	//branch : gorillazin 10. 04. 14. - new vote event	
	if(m_bIsNewVoteEvent)
	{
		Me.HideWindow();//changed
	}
	else
	{
		Me.HideWindow();
	}
	//end of branch
}


function OnExitState( name a_NextStateName )
{
	// state �� ���� �ɶ� Ÿ�̸Ӹ� ���� ��Ű�°� �´µ� �ϴ�. ������ ���������� �����ʿ��� ���°� �ٲ�� �ٽ� �ö�
	// ���� �ִ����� ���� ���� Ȯ��ġ �ʾƼ� �ϴ� ���� ��Ű�� ���� ������� �ʾҴ�. 
	// Me.KillTimer(TIMER_ID);	
	
	//branch : gorillazin 10. 04. 14. - new vote event	
	Me.HideWindow();
	//end of branch
}


function getDataByServer (string param)
{ 
	local int voteCount;
	local int bonusCount;
	local int leftBonusTime;
	local int bonusRate;
	local int isOverTime;

	Parseint(Param, "voteCount", voteCount) ;
	Parseint(Param, "bonusCount", bonusCount) ;
	Parseint(Param, "leftBonusTime", leftBonusTime);
	Parseint(Param, "bonusRate", bonusRate);
	Parseint(Param, "isOverTime", isOverTime);

	// debug(" voteCount : " @ voteCount);
	// debug(" bonusCount : " @ bonusCount);
	// debug("=======================================");

	// debug(" leftBonusTime : " @ leftBonusTime);
	// debug(" bonusRate : " @ bonusRate);	
	// debug("isOverTiemr: " @ isOverTime);
	
	//branch : gorillazin 10. 04. 14. - new vote event	
	//if(!m_bIsFirstNewVoteEventMessage)
	//{
	//	m_bIsNewVoteEvent = true;				
	//	m_bIsFirstNewVoteEventMessage = true;
	//}
	if(!m_bIsFirstNewVoteEventMessage)
	{
		if(!m_bIsNewVoteEvent)
		{
			Me.HideWindow();//changed
			m_bIsNewVoteEvent = true;
		}
		m_bIsFirstNewVoteEventMessage = true;
	}	
	//end of branch
	
	Me.KillTimer(TIMER_ID);	
		
	UpdateTime(leftBonusTime);


	// Ÿ�̸� �۵� 
	if (isOverTime==1 || leftBonusTime>0 && isOverTime==10 || isOverTime==11) // TTP 41591
	{
		bonusTimeLimitTextBox2.SetText (GetSystemString(2275));
		bonusExpTextBox2.SetText (bonusRate $ "%");
	}
	else 
	{
		if (0 < leftBonusTime)
		{
			bonusExpTextBox2.SetText (bonusRate $ "%");
			currentRemainTimeValue = leftBonusTime;

			//  Ÿ�̸� ���� 		
			Me.SetTimer( TIMER_ID, TIMER_DELAY );
		}
		else
		{
			bonusExpTextBox2.SetText ("0%");
		}
	}
}


function visibleToggleWnd()
{
	if(class'UIAPI_WINDOW'.static.IsShowWindow("RecommendBonusWnd"))
	{
		class'UIAPI_WINDOW'.static.HideWindow("RecommendBonusWnd");
	}
	else 
	{
		class'UIAPI_WINDOW'.static.ShowWindow("RecommendBonusWnd");//changed
	}
}

function UpdateTime(int iRemainSecond)
{
	local int temp1;
	local int m_timeHour;
	local int m_timeMin;
	local int m_timeSec;

	// �ð� ����.
	temp1 = iRemainSecond / 60;
	
	m_timeHour = temp1 / 60;		// ��
	m_timeMin = temp1 % 60;			// ��
	m_timeSec = iRemainSecond % 60;	// ��
	
	// debug(" m_timeHour : " $ m_timeHour $ "m_timeMin : "  $ m_timeMin$ "m_timeSec : "  $ m_timeSec);	
	
	// �ø� �׷��ش�.
	if(m_timeHour > 0)
	{
		if (m_timeHour < 10 ) bonusTimeLimitTextBox2.setText( "0" $ string( m_timeHour ));
		else bonusTimeLimitTextBox2.setText( string( m_timeHour ));
	}
	else
	{
		bonusTimeLimitTextBox2.setText("00");
	}
	
	bonusTimeLimitTextBox2.SetText(bonusTimeLimitTextBox2.GetText() $ ":");

	// ���� �׷��ش�.
	if( m_timeMin > 0)
	{
		if (m_timeMin < 10 ) bonusTimeLimitTextBox2.setText(bonusTimeLimitTextBox2.GetText() $ "0" $ string( m_timeMin ));
		else bonusTimeLimitTextBox2.setText(bonusTimeLimitTextBox2.GetText() $ string( m_timeMin ));		
	}
	else
	{
		bonusTimeLimitTextBox2.setText(bonusTimeLimitTextBox2.GetText() $ "00");
	}
	
	// �ð��� 0�� �Ǹ� ����
	if(m_timeHour <= 0 && m_timeMin <= 0 && m_timeSec <= 0)
	{
		me.KillTimer( TIMER_ID );
	}
	
	// �ð��� 0���� �۰ų� ������ 
	if (iRemainSecond <= 0)
	{
		bonusExpTextBox2.SetText ("0%");
		bonusTimeLimitTextBox2.SetText (GetSystemString(908));
	}
}




function HandleNavitPointInfo( String a_Param )
{
	local int point;
	local int level;
	local int percent;
	ParseInt( a_Param, "NavitPoint", point );
	level = point / ( NAVIT_MAX_POINT / 12 );
	percent = ( point * 100.0 ) / NAVIT_MAX_POINT;

	if( percent > 100 ) percent = 100;

	if( !m_bNavit )
	{
		NavitGaugeChange( level, false );
		Navit_Tooltip_Gauge.SetTooltipCustomType( MakeTooltipSimpleText( 
			MakeFullSystemMsg( GetSystemMessage(3271), String( percent )$"%", "" ) ) );
	}
}
function HandleNavitEffect( String a_Param )
{
	ParseInt( a_Param, "RemainSeconds", m_NavitEffectRemainSec );
	
	if( m_NavitEffectRemainSec > 0 )
	{
		//debug("$$$$$$$$$$$$$$$�׺�Ʈ �ߵ�!!!! : " @ m_NavitEffectRemainSec );
		m_bNavit = true;
		NavitGaugeChange( 12, true );

		Me.KillTimer( NAVIT_TIMER_ID_TOOLTIP );
		Me.SetTimer( NAVIT_TIMER_ID_TOOLTIP, NAVIT_TIMER_DELAY_TOOLTIP );

		m_NavitIConFactor = 0;
		Me.KillTimer( NAVIT_TIMER_ID_ICON );
		Me.SetTimer( NAVIT_TIMER_ID_ICON, NAVIT_TIMER_DELAY_ICON );
	}
	else
	{
		//debug("$$$$$$$$$$$$$$$�׺�Ʈ �ߵ�����!!" );
		m_bNavit = false;
		NavitGaugeChange( m_Navit_Level, true );

		Me.KillTimer( NAVIT_TIMER_ID_TOOLTIP );
		Me.KillTimer( NAVIT_TIMER_ID_ICON );

		Navit_Tex_Glow.SetAlpha( 0, ANIM_SPEEDFLOAT );
	}
}
function HandleNavitTimeChange( String a_Param )
{
	local int bStart;
	local int navitTime;
	local string tooltip;

	ParseInt( a_Param, "bStart", bStart );
	ParseInt( a_Param, "navitTime", navitTime );
	
	if( navitTime > NAVIT_MAX_TIME )
	{
		// ����
		tooltip = MakeFullSystemMsg( GetSystemMessage(3277), GetSystemString(908), "" );
		Navit_Tex_Icon.SetTexture( "BranchSys2.ui.Br_NavitIcon_B" );
	}
	else
	{
		if( bStart == 1 )
		{
			// Ȱ��ȭ = �ð� ǥ��
			tooltip = MakeFullSystemMsg( GetSystemMessage(3277), NavitUpdateTime( NAVIT_MAX_TIME - navitTime ), "" );
			Navit_Tex_Icon.SetTexture( "BranchSys2.ui.Br_NavitIcon_N" );
		}
		else
		{
			// ����
			tooltip = MakeFullSystemMsg( GetSystemMessage(3277), GetSystemString(2320), "" );
			Navit_Tex_Icon.SetTexture( "BranchSys2.ui.Br_NavitIcon_B" );
		}	
	}

	Navit_Tooltip_Icon.SetTooltipCustomType( MakeTooltipSimpleText( tooltip ) );
}

function TimerNavitIconBlink()
{
	if( m_NavitIConFactor % 2 == 0 )			Navit_Tex_Glow.SetAlpha( ANIM_MIN_ALPHA, ANIM_SPEEDFLOAT );
	else										Navit_Tex_Glow.SetAlpha( ANIM_MAX_ALPHA, ANIM_SPEEDFLOAT );

	m_NavitIConFactor = m_NavitIConFactor + 1;
}
function TimerNavitGaugeBlink()
{
	if( m_NavitGaugeFactor % 2 == 0 )			Navit_Tex_Gauge.SetAlpha( ANIM_MIN_ALPHA, ANIM_SPEEDFLOAT );
	else										Navit_Tex_Gauge.SetAlpha( ANIM_MAX_ALPHA, ANIM_SPEEDFLOAT );
	
	if( m_NavitGaugeFactor > 16 )
	{
		Me.KillTimer( NAVIT_TIMER_ID_GAUGE );
		Navit_Tex_Gauge.SetAlpha( 255, ANIM_SPEEDFLOAT );
	}
	
	m_NavitGaugeFactor = m_NavitGaugeFactor + 1;
}
function TimerNavitToolTip()
{
	if( m_NavitEffectRemainSec > 0 ) m_NavitEffectRemainSec = m_NavitEffectRemainSec - 1;
	Navit_Tooltip_Gauge.SetTooltipCustomType( MakeTooltipSimpleText( MakeFullSystemMsg( GetSystemMessage(3270), String( m_NavitEffectRemainSec ), "" ) ) );
}
function string NavitUpdateTime( int RemainSec )
{
	local	int		Hour;
	local	int		Min;
	local	int		tmpSec;
	local	String	strTime;
	
	if( RemainSec > 0 )
	{
		// Convert Time
		tmpSec = RemainSec / 60;
		Min = tmpSec % 60;
		Hour = tmpSec / 60;
		

		if( Hour < 10 )	strTime = "0" $ String( Hour );
		else			strTime =		String( Hour );
		
		strTime = strTime $ ":";
		
		if( Min < 10 )	strTime = strTime $ "0" $ String( Min );
		else			strTime = strTime $ String( Min );
	}
	else
	{
		strTime = "00:00";
	}
	
	return strTime;
}
function NavitGaugeChange( int level, bool forceChange )
{
	local string texName;
	texName = "BranchSys2.ui.Br_NavitPoint_"$level;

	if( ( forceChange == true ) || ( m_Navit_Level != level ) )
	{
		Navit_Tex_Gauge.SetTexture( texName );
		
		if( level != 0 && level != 12 )					// 0�ܰ�, 12�ܰ�� ����
		{
			// play animation
			m_NavitGaugeFactor = 0;
			Me.KillTimer( NAVIT_TIMER_ID_GAUGE );
			Me.SetTimer( NAVIT_TIMER_ID_GAUGE, NAVIT_TIMER_DELAY_GAUGE );
		}
	}

	m_Navit_Level = level;
}

defaultproperties
{
    
}
