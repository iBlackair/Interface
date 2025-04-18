class OlympiadTargetWnd extends UIScriptEx;

const MAX_OLYMPIAD_USER_NUM = 3;

var WindowHandle Me;

var WindowHandle		m_TargetWnd[MAX_OLYMPIAD_USER_NUM];
var BarHandle			m_BarCP[MAX_OLYMPIAD_USER_NUM];
var BarHandle			m_BarHP[MAX_OLYMPIAD_USER_NUM];
var NameCtrlHandle		m_PlayerName[MAX_OLYMPIAD_USER_NUM];
var int		m_PlayerNum;

var TextBoxHandle deadz_TargetCP[MAX_OLYMPIAD_USER_NUM];
var TextBoxHandle deadz_TargetHP[MAX_OLYMPIAD_USER_NUM];

var int		m_ID[MAX_OLYMPIAD_USER_NUM];
var string		m_Name[MAX_OLYMPIAD_USER_NUM];
var int		m_ClassID[MAX_OLYMPIAD_USER_NUM];
var int		m_MaxHP[MAX_OLYMPIAD_USER_NUM];
var int		m_CurHP[MAX_OLYMPIAD_USER_NUM];
var int		m_MaxCP[MAX_OLYMPIAD_USER_NUM];
var int		m_CurCP[MAX_OLYMPIAD_USER_NUM];
var int		m_TotalCount;
var int		m_MyTeamCount;
var string  m_WindowName;
var int VisibleMaxCP[MAX_OLYMPIAD_USER_NUM], VisibleCurCP[MAX_OLYMPIAD_USER_NUM], VisibleMaxHP[MAX_OLYMPIAD_USER_NUM], VisibleCurHP[MAX_OLYMPIAD_USER_NUM];
var BarHandle enemyHP[MAX_OLYMPIAD_USER_NUM], enemyCP[MAX_OLYMPIAD_USER_NUM];

var OlympiadDmgWnd script_olydmg;

function OnRegisterEvent()
{
	RegisterEvent( EV_OlympiadTargetShow );
	RegisterEvent( EV_OlympiadUserInfo );
	RegisterEvent( EV_OlympiadMatchEnd );	
	RegisterEvent( EV_ReceiveMagicSkillUse );	
	
}

function OnLoad()
{
	local int i;
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	m_WindowName="OlympiadTargetWnd";

	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( m_WindowName );
		for (i = 0; i < MAX_OLYMPIAD_USER_NUM; i++)
		{
			m_TargetWnd[i] = GetHandle(m_WindowName$".TargetWnd"$i);
			m_BarCP[i] = BarHandle( GetHandle(m_WindowName$".TargetWnd"$i$".barcp"));
			m_BarHP[i] = BarHandle( GetHandle(m_WindowName$".TargetWnd"$i$".barhp"));
			m_PlayerName[i] = NameCtrlHandle( GetHandle(m_WindowName$".TargetWnd"$i$".PlayerName"));
			deadz_TargetCP[i] = TextBoxHandle(GetHandle("OlympiadTargetWnd.TargetWnd"$i$".TargetCP"));
			deadz_TargetHP[i] = TextBoxHandle(GetHandle("OlympiadTargetWnd.TargetWnd"$i$".TargetHP"));
			enemyHP[i] = BarHandle(GetHandle("OlympiadTargetWnd.TargetWnd"$i$".barHP"));
			enemyCP[i] = BarHandle(GetHandle("OlympiadTargetWnd.TargetWnd"$i$".barCP"));
		}
	}
	else
	{
		Me = GetWindowHandle( m_WindowName );
		for (i = 0; i < MAX_OLYMPIAD_USER_NUM; i++)
		{
			m_TargetWnd[i] = GetWindowHandle(m_WindowName $".TargetWnd"$ i);
			m_BarCP[i] = GetBarHandle(m_WindowName$".TargetWnd"$i$".barcp");
			m_BarHP[i] = GetBarHandle(m_WindowName$".TargetWnd"$i$".barhp");
			m_PlayerName[i] = GetNameCtrlHandle(m_WindowName$".TargetWnd"$i$".PlayerName");
			deadz_TargetCP[i] = GetTextBoxHandle("OlympiadTargetWnd.TargetWnd"$i$".TargetCP");
			deadz_TargetHP[i] = GetTextBoxHandle("OlympiadTargetWnd.TargetWnd"$i$".TargetHP");
			enemyHP[i] = GetBarHandle("OlympiadTargetWnd.TargetWnd"$i$".barHP");
			enemyCP[i] = GetBarHandle("OlympiadTargetWnd.TargetWnd"$i$".barCP");
		}
	}
	
	script_olydmg = OlympiadDmgWnd (GetScript("OlympiadDmgWnd"));
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_OlympiadTargetShow)
	{
		Clear();
		Parseint(param, "PlayerNum", m_PlayerNum);
		ShowWindowCtrl(1);
		
	}
	else if (Event_ID == EV_OlympiadUserInfo)
	{
	//	debug("여기넘어오니??");
		HandleUserInfo(param);
		UpdateStatus();
	}
	else if (Event_ID == EV_OlympiadMatchEnd)
	{
		Clear();
		HideAllWindow();
	}
	else if (Event_ID == EV_ReceiveMagicSkillUse && script_olydmg.AtOly)
	{
		DoSexyThing(param);
	}
}

function DoSexyThing(string a_Param)
{
	local int AttackerID;
	local int DefenderID;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	local UserInfo DefenderInfo;

	ParseInt(a_Param,"AttackerID",AttackerID);
	ParseInt(a_Param,"DefenderID",DefenderID);

	GetUserInfo(AttackerID,AttackerInfo);
	GetUserInfo(DefenderID,DefenderInfo);
	GetPlayerInfo(PlayerInfo);
	
	
	if (AttackerInfo.Name == script_olydmg.GName && script_olydmg.GName != "" && script_olydmg.GName != PlayerInfo.Name && script_olydmg.TimeRemaining > 300)	
	{
			m_PlayerName[0].SetName(AttackerInfo.Name, NCT_Normal,TA_Center);
	}
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y) {
	local Rect rectWnd;
	local int i;

	rectWnd = Me.GetRect();
	if (X > rectWnd.nX + 13 && X < rectWnd.nX + rectWnd.nWidth -10) {
		for (i = 0; i < MAX_OLYMPIAD_USER_NUM; i++)
			if (m_ID[i] != 0) {
				RequestTargetUser(m_ID[i]);
				break;
			}
	}
}

function OnEnterState( name a_PreStateName )
{
	Clear();
}

//초기화
function Clear()
{
	local int i;
	m_PlayerNum = 0;
	
	for (i =0; i < MAX_OLYMPIAD_USER_NUM; i++)
	{
		m_ID[i] = 0;
		m_Name[i] = "";
		m_ClassID[i] = 0;
		m_MaxHP[i] = 0;
		m_CurHP[i] = 0;
		m_MaxCP[i] = 0;
		m_CurCP[i] = 0;
		VisibleMaxHP[i] = 0;
		VisibleCurHP[i] = 0;
		VisibleMaxCP[i] = 0;
		VisibleCurCP[i] = 0;
		deadz_TargetCP[i].SetText("0 / 0");
		deadz_TargetCP[i].SetAlign(TA_Center);
		deadz_TargetHP[i].SetText("0 / 0");
		deadz_TargetHP[i].SetAlign(TA_Center);
	}
	
	UpdateStatus();
	HideAllWindow();


}

//UserInfo설정
function HandleUserInfo(string param)
{
	local int IsPlayer;
	local int PlayerNum;
	local int i;
	local int m_UserInfoIdx;
	local int MyTeamNum;
	
	//debug("param : " $ param);
	
	//Observer모드에서의 플레이어 정보 패킷이면 패스


	ParseInt(param, "IsPlayer", IsPlayer);

	
	if (IsPlayer != 0)
	{
//		debug("짠짠짠1"$IsPlayer);
		return;
	}
	ParseInt(param, "TotalCount", m_TotalCount); //플레이어 숫자
	m_MyTeamCount = m_TotalCount / 2;			// 상대팀 사람수
	ParseInt(param, "MyTeamNum", MyTeamNum);   // 현재 나의 팀 번호

	m_UserInfoIdx = 0;
	for (i = 0; i < m_TotalCount; i++)
	{		
		//표시하고자 하는 타겟의 PlayerNum이 아니면 패스
		ParseInt(param, "PlayerNum_" $ string(i), PlayerNum);
		if (PlayerNum == MyTeamNum)
			continue;

		ParseInt(param, "ID_" $ string (i), m_ID[m_UserInfoIdx]);
		ParseString(param, "Name_" $ string (i), m_Name[m_UserInfoIdx]);
		ParseInt(param, "ClassID_" $ string (i), m_ClassID[m_UserInfoIdx]);
		ParseInt(param, "MaxHP_" $ string (i), m_MaxHP[m_UserInfoIdx]);
		ParseInt(param, "CurHP_" $ string (i), m_CurHP[m_UserInfoIdx]);
		ParseInt(param, "MaxCP_" $ string (i), m_MaxCP[m_UserInfoIdx]);
		ParseInt(param, "CurCP_" $ string (i), m_CurCP[m_UserInfoIdx]);
//		debug("ID"$m_ID[m_UserInfoIdx]$  "Name"$m_Name[m_UserInfoIdx]$ "ClassID"$m_ClassID[m_UserInfoIdx]$ "MaxHP"$m_MaxHP[m_UserInfoIdx]$ "CurHP"$m_CurHP[m_UserInfoIdx]$ "MaxCP"$m_MaxCP[m_UserInfoIdx]$ "CurCP"$m_CurCP[m_UserInfoIdx]);

		m_UserInfoIdx++;
	}
	ShowWindowCtrl(m_MyTeamCount);

}

//Update Info
function UpdateStatus()
{
	//이름
	local int i;
	for (i =0; i < m_MyTeamCount; i++)
	{
	//	m_Name[i].SetText(m_Name[i]);
		m_PlayerName[i].SetName(m_Name[i], NCT_Normal,TA_Center);
//		class'UIAPI_TEXTBOX'.static.SetText( "OlympiadTargetWnd.txtName", m_Name[i]);
		
		//CP
		if (m_MaxCP[i]>0)
		{
			m_BarCP[i].SetValue (m_MaxCP[i] , m_CurCP[i]);
			enemyCP[i].GetValue(VisibleMaxCP[i], VisibleCurCP[i]);
			deadz_TargetCP[i].SetAlign(TA_Center);
			deadz_TargetCP[i].SetText(VisibleCurCP[i] $ " / " $ VisibleMaxCP[i]);
		}
		else
		{
			m_BarCP[i].SetValue ( 0 , 0);
		}
		
		// HP
		if (m_MaxHP[i]>0)
		{
			m_BarHP[i].SetValue (m_MaxHP[i] , m_CurHP[i]);
			enemyHP[i].GetValue(VisibleMaxHP[i], VisibleCurHP[i]);
			deadz_TargetHP[i].SetAlign(TA_Center);
			deadz_TargetHP[i].SetText(VisibleCurHP[i] $ " / " $ VisibleMaxHP[i]);
		}
		else
		{
			m_BarHP[i].SetValue ( 0 , 0);
		}
	}
		
	/*
	//CP
	if (m_MaxCP>0)
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "OlympiadTargetWnd.texCP", 150 * m_CurCP / m_MaxCP, 6);
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "OlympiadTargetWnd.texCP", 0, 6);
	}
	
	//HP
	if (m_MaxHP>0)
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "OlympiadTargetWnd.texHP", 150 * m_CurHP / m_MaxHP, 6);
	}
	else
	{
		class'UIAPI_WINDOW'.static.SetWindowSize( "OlympiadTargetWnd.texHP", 0, 6);
	}
	*/
}

function ShowWindowCtrl(int count)
{
	local int i;
	local Rect entireRect;
	entireRect = me.GetRect();

	me.showwindow();
	if (count == 1)
	{
		m_TargetWnd[0].showwindow();
		m_BarCP[0].showwindow();
		m_BarHP[0].showwindow();
		m_PlayerName[0].showwindow();
		deadz_TargetCP[0].showwindow();
		deadz_TargetHP[0].showwindow();
		for (i =1; i < MAX_OLYMPIAD_USER_NUM; i++)
		{	
			m_TargetWnd[i].hidewindow();
			m_BarCP[i].hidewindow();
			m_BarHP[i].hidewindow();
			m_PlayerName[i].hidewindow();
			deadz_TargetCP[i].hidewindow();
			deadz_TargetHP[i].hidewindow();
		}
		//창사이즈 수정2010.06.08
		me.SetWindowSize( entireRect.nWidth, 44 );
	}
	else
	{					
		for (i =0; i < count; i++)
		{	
			m_TargetWnd[i].showwindow();
			m_BarCP[i].showwindow();
			m_BarHP[i].showwindow();
			m_PlayerName[i].showwindow();
			deadz_TargetCP[i].showwindow();
			deadz_TargetHP[i].showwindow();
		}
	}
	if(count == 3)
	{
		//창사이즈 수정2010.06.08
		me.SetWindowSize( entireRect.nWidth, 160 );
	}
}
function HideAllWindow()
{
	local int i;
	me.hidewindow();
	for (i =0; i < MAX_OLYMPIAD_USER_NUM; i++)
	{	
		m_TargetWnd[i].hidewindow();
		m_BarCP[i].hidewindow();
		m_BarHP[i].hidewindow();
		m_PlayerName[i].hidewindow();
		deadz_TargetCP[i].hidewindow();
		deadz_TargetHP[i].hidewindow();
	}
}
defaultproperties
{
    
}
