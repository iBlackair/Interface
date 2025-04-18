class OlympiadPlayerWnd extends UICommonAPI;

const MAX_OLYMPIAD_USER_NUM = 3;
const MAX_OLYMPIAD_TEAM_NUM = 2;
//const MAX_OLYMPIAD_ALL_USER_NUM = MAX_OLYMPIAD_USER_NUM * MAX_OLYMPIAD_TEAM_NUM;  6
const MAX_OLYMPIAD_SKILL_MSG = 5;
const MAX_OLYMPIAD_ALLSKILL_MSG = 15; //MAX_OLYMPIAD_USER_NUM * MAX_OLYMPIAD_SKILL_MSG

const CONTRACT_HEIGHT = 44;
const EXPAND_HEIGHT = 124;

const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

var WindowHandle Me;
var ButtonHandle btnExpand;
var ButtonHandle btnContract;

var WindowHandle m_StatusWnd[MAX_OLYMPIAD_USER_NUM];
var WindowHandle	m_MsgWnd[MAX_OLYMPIAD_USER_NUM];	//�޽���������
var NameCtrlHandle		m_PlayerName[MAX_OLYMPIAD_USER_NUM];
var TextureHandle		m_ClassIcon[MAX_OLYMPIAD_USER_NUM];
var BarHandle	m_BarCP[MAX_OLYMPIAD_USER_NUM];
var BarHandle	m_BarHP[MAX_OLYMPIAD_USER_NUM];

var TextBoxHandle m_TextBoxHandle[MAX_OLYMPIAD_ALLSKILL_MSG]; //TextBoxHandle
var string		m_Msg[MAX_OLYMPIAD_ALLSKILL_MSG];

var StatusIconHandle	StatusIcon[MAX_OLYMPIAD_USER_NUM]; 

var int			m_PlayerNum;
var string		m_WindowName;
var string		m_BuffWindowName;
var bool		m_Expand;
var int 		m_TotalCount;
var int			m_MyTeamCount;

var int		m_MsgStartLine[MAX_OLYMPIAD_USER_NUM];
var int		m_MsgNextStartLine[MAX_OLYMPIAD_USER_NUM];

var int		m_MyTeamNum;
var int 		m_IsPlayer;

var bool mFound ;

//���� ����(10.04.01) �Ϸ�
var Color Red;
var Color Blue;

struct native OlympiadUserInfo
{
	var int		m_TeamID;
	var int		m_ID;
	var string		m_Name;
	var int		m_ClassID;
	var int		m_MaxHP;
	var int		m_CurHP;
	var int		m_MaxCP;
	var int		m_CurCP;
	var int		m_MsgWnd;	//�޽���������
	
};

var OlympiadUserInfo UserInfo[MAX_OLYMPIAD_USER_NUM];


function SetPlayerNum(int PlayerNum)
{
	m_PlayerNum = PlayerNum;
	m_WindowName = "OlympiadPlayer" $ m_PlayerNum $ "Wnd";
	m_BuffWindowName = "OlympiadBuff" $ m_PlayerNum $ "Wnd";
}

function OnRegisterEvent()
{
	RegisterEvent( EV_OlympiadUserInfo );
	RegisterEvent( EV_OlympiadMatchEnd );
	RegisterEvent( EV_ReceiveMagicSkillUse );
	RegisterEvent( EV_ReceiveAttack );

	RegisterEvent( EV_OlympiadBuffShow );
	RegisterEvent( EV_OlympiadBuffInfo );
}

function OnLoad()
{
	local int i,j;
	
	mFound = true;
	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( m_WindowName );
		
		for (i=0;i<MAX_OLYMPIAD_USER_NUM;i++) //3
		{
			m_StatusWnd[i] = GetHandle(m_WindowName$".TargetWnd"$i);
			m_MsgWnd[i] = GetHandle(m_WindowName$".TargetWnd" $i $".SysMsgWnd");		//�޽���������
			for(j =0; j < MAX_OLYMPIAD_SKILL_MSG; j++) //5
			{
				m_TextBoxHandle[i*MAX_OLYMPIAD_SKILL_MSG + j] = TextBoxHandle ( GetHandle( m_WindowName $".TargetWnd"$i $".SysMsgWnd"$".txtMsg"$j));
			}
			m_PlayerName[i] = NameCtrlHandle( GetHandle(m_WindowName $".TargetWnd"$ i $ ".PlayerName" ) ); 
			m_ClassIcon[i] = TextureHandle( GetHandle(m_WindowName $".TargetWnd"$ i $ ".ClassIcon" ) );		
			m_BarCP[i]= BarHandle( GetHandle(m_WindowName $".TargetWnd"$ i $".barCP" ) );
			m_BarHP[i] = BarHandle( GetHandle(m_WindowName $".TargetWnd"$ i $".barHP" ) );
			StatusIcon[i] = StatusIconHandle( GetHandle( m_WindowName $".TargetWnd"$ i $".BuffWnd" ));
		}
		
		btnExpand = ButtonHandle ( GetHandle(m_WindowName $ ".btnExpand" ) );
		btnContract= ButtonHandle ( GetHandle(m_WindowName $ ".btnContract" ) );
		
	}
	else
	{
		Me = GetWindowHandle( m_WindowName );
		for (i=0;i<MAX_OLYMPIAD_USER_NUM;i++) //3
		{
			m_StatusWnd[i] = GetWindowHandle(m_WindowName $".TargetWnd"$ i);
			m_MsgWnd[i] = GetWindowHandle(m_WindowName $".TargetWnd"$i $".SysMsgWnd");		//�޽���������
			for(j =0; j < MAX_OLYMPIAD_SKILL_MSG; j++) //5
			{
				m_TextBoxHandle[i*MAX_OLYMPIAD_SKILL_MSG + j] = GetTextBoxHandle( m_WindowName $".TargetWnd"$i $".SysMsgWnd"$".txtMsg"$j);
			}
			m_PlayerName[i] = GetNameCtrlHandle(m_WindowName $".TargetWnd"$ i $ ".PlayerName" ); 
			m_ClassIcon[i] = GetTextureHandle(m_WindowName $".TargetWnd"$ i $ ".ClassIcon" );			
			m_BarCP[i] = GetBarHandle(m_WindowName $".TargetWnd"$ i $".barCP");
			m_BarHP[i] = GetBarHandle(m_WindowName $".TargetWnd"$ i $".barHP");
			StatusIcon[i] = GetStatusIconHandle( m_WindowName $".TargetWnd"$ i $".BuffWnd" );			
			//debug("m_StatusWnd[i]"$m_StatusWnd[i]);
			//debug("m_MsgWnd[i]"$m_MsgWnd[i]);			//�޽���������
			//debug("m_PlayerName[i]"$m_PlayerName[i]);
			//debug("m_ClassIcon[i]"$m_ClassIcon[i]);
			//debug("m_BarCP[i]"$m_BarCP[i]);
			//debug("m_BarHP[i]"$m_BarHP[i]);
						
		}
		
		btnExpand = GetButtonHandle (m_WindowName $ ".btnExpand" );
		btnContract= GetButtonHandle (m_WindowName $ ".btnContract" );
	}
	for (i=0;i<MAX_OLYMPIAD_USER_NUM;i++) //3
	{
		StatusIcon[i].SetAnchor(m_WindowName$".TargetWnd"$i, "TopRight", "TopLeft", 1, 1);
	}
	SetExpandMode(false);
	SetColor();
}

//���� ����(10.04.01) �Ϸ�
function SetColor()
{
	Red.R = 238;
	Red.G = 119;
	Red.B = 119;
	Red.A = 255;
	
	Blue.R = 102;
	Blue.G = 170;
	Blue.B = 238;
	Blue.A = 255;
}

function OnEnterState( name a_PreStateName )
{
	//Clear();
	//SetExpandMode(false);
	//SetExpandMode(m_Expand);
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_OlympiadUserInfo)
	{
		HandleUserInfo(param);
		//UpdateStatus();
	}
	else if (Event_ID == EV_ReceiveMagicSkillUse)
	{
//		debug("��ų����̾ȵ�!!!");
		HandleMagicSkillUse(param);
	}
	else if (Event_ID == EV_ReceiveAttack)
	{
		HandleAttack(param);
	}
	else if (Event_ID == EV_OlympiadBuffShow)
	{
	//	HandleBuffShow(param);
	}
	else if (Event_ID == EV_OlympiadBuffInfo)
	{
		HandleBuffInfo(param);
	}
	else if (Event_ID == EV_OlympiadMatchEnd)
	{
		Clear();
	}
	
	
	
}

//�ʱ�ȭ
function Clear()
{
	local int i;
	
	//~ var int		m_ID[5];
	//~ var string		m_Name[5];
	//~ var int		m_ClassID[5];
	//~ var int		m_MaxHP[5];
	//~ var int		m_CurHP[5];
	//~ var int		m_MaxCP[5];
	//~ var int		m_CurCP[5];
	
	
	for (i=0; i<MAX_OLYMPIAD_USER_NUM; i++)
	{

		UserInfo[i].m_TeamID = 0;		
		UserInfo[i].m_ID = 0;
		UserInfo[i].m_Name = "";
		UserInfo[i].m_ClassID = 0;
		UserInfo[i].m_MaxHP = 0;
		UserInfo[i].m_CurHP = 0;
		UserInfo[i].m_MaxCP = 0;
		UserInfo[i].m_CurCP = 0;		
		UserInfo[i].m_MsgWnd = 0;		//�޽���������

		StatusIcon[i].Clear();
//		StatusIcon[i].HideWindow();
	}
	
	
	for (i=0; i<MAX_OLYMPIAD_ALLSKILL_MSG; i++)
	{
		m_Msg[i] = "";
	}
	
//	UpdateStatus();
	for (i = 0; i < MAX_OLYMPIAD_USER_NUM; i++ )
		UpdateMsg(i, "");
	me.hidewindow();
}
function initialize()
{
	local int i;
		

	
	
	for (i=0; i<MAX_OLYMPIAD_USER_NUM; i++)
	{

		UserInfo[i].m_TeamID = 0;		
		UserInfo[i].m_ID = 0;
		UserInfo[i].m_Name = "";
		UserInfo[i].m_ClassID = 0;
		UserInfo[i].m_MaxHP = 0;
		UserInfo[i].m_CurHP = 0;
		UserInfo[i].m_MaxCP = 0;
		UserInfo[i].m_CurCP = 0;		
		UserInfo[i].m_MsgWnd = 0;		//�޽���������

		StatusIcon[i].Clear();
		m_MsgStartLine[i] = MAX_OLYMPIAD_ALLSKILL_MSG *i;

	}
	
	
	for (i=0; i<MAX_OLYMPIAD_ALLSKILL_MSG; i++)
	{
		m_Msg[i] = "";
	}
	
//	UpdateStatus();
	for (i = 0; i < MAX_OLYMPIAD_USER_NUM; i++ )
		UpdateMsg(i, "");

	

}
function OnShow()
{
	initialize();
}

//BuffInfo����
function HandleBuffInfo(string param)
{
	local int ID;
	
	local int i,j;
	local int Max;
	local int CurRow;
	local StatusIconInfo info;
		
	//���� �÷��̾�ID�� �ƴϸ� �н�
	ParseInt(param, "PlayerID", ID); //�� ������ ID

	for (i=0; i<m_MyTeamCount ; i++)
	{
		if (ID<1 || ID==UserInfo[i].m_ID)
		{
			break;
		}
	}


	if (i != m_MyTeamCount)
	{
		//�ʱ�ȭ
	//	Clear();
		StatusIcon[i].Clear();
		CurRow = -1;
		
		ParseInt(param, "Max", Max);
		for (j=0; j<Max; j++)
		{
			//���ٿ� NSTATUSICON_MAXCOL��ŭ ǥ���Ѵ�.
			if (j%NSTATUSICON_MAXCOL == 0)
			{
				StatusIcon[i].AddRow();
//				class'UIAPI_STATUSICONCTRL'.static.AddRow(m_WindowName $ ".StatusIcon");
				CurRow++;
			}
			
			ParseItemIDWithIndex(param, info.ID, j);
			ParseInt(param, "SkillLevel_" $ j, info.Level);
			ParseInt(param, "RemainTime_" $ j, info.RemainTime);
			ParseString(param, "Name_" $ j, info.Name);
			ParseString(param, "IconName_" $ j, info.IconName);
			ParseString(param, "Description_" $ j, info.Description);
			info.Size = 24;
			info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
			info.bShow = true;
			
//			class'UIAPI_STATUSICONCTRL'.static.AddCol(m_WindowName $ ".StatusIcon", CurRow, info);
//			debug("����Add" $ j$" "$i);
			StatusIcon[i].AddCol(CurRow, info);
		}
		
		if (Max>0)
		{
//			class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
			
			//������ ������ ����
//			rectWnd = class'UIAPI_WINDOW'.static.GetRect(m_WindowName $ ".StatusIcon");
//			StatusIcon[i].GetRect();
//			class'UIAPI_WINDOW'.static.SetWindowSize(m_WindowName, rectWnd.nWidth + NSTATUSICON_FRAMESIZE, rectWnd.nHeight);
//			StatusIcon[i].SetWindowSize(rectWnd.nWidth + NSTATUSICON_FRAMESIZE, rectWnd.nHeight);			
			//���� ������ ������ ����
//			class'UIAPI_WINDOW'.static.SetFrameSize(m_WindowName, NSTATUSICON_FRAMESIZE, rectWnd.nHeight);	
//			StatusIcon[i].SetFrameSize(NSTATUSICON_FRAMESIZE, rectWnd.nHeight);
		}
	}
}

function HandleUserInfo(string Param)
{
	local int i;
	//~ local int playNum;

	local int teamID;
	local int PlayerID;
	local int m_ClassID;
	local string m_Name;
	local int m_MaxHP;
	local int m_CurHP;
	local int m_MaxCP;
	local int m_CurCP;
	local int m_MsgWnd;			//�޽���������
	local int m_UserInfoIdx;
	//~ local int myTeamID;
	
	//~ local string FakeEventParam;
		
	//~ local int PlayerNum;

	
	//Observer��忡���� �÷��̾� ������ �ƴϸ� �н�
	ParseInt(param, "IsPlayer", m_IsPlayer);
	//debug("M_ISPlayer" $m_IsPlayer);
	if (m_IsPlayer != 1)
		return;

	ParseInt(param, "TotalCount", m_TotalCount); //�÷��̾� ����

	m_MyTeamCount = m_TotalCount / 2;			// �츮�� �����
//	ParseInt(param, "MyTeamNum", m_MyTeamNum);
	
	
//	debug("!!!m_MyTeamNum"$m_MyTeamNum);

	//�÷��̾ �����ϰ� ������ IsPlayer �� 1�̴� 

	//���⼭ ��Ż ī���Ͱ� 2���� �ƴϸ� 2 �̻����� üũ �ؾ� �Ѵ� 

	if ((m_TotalCount == 2) || (m_TotalCount == 6))
	{
		m_UserInfoIdx = 0;
	//	debug("!!!m_TotalCount"$m_TotalCount);
		for(i = 0; i <m_TotalCount ; i++)
		{
			
			ParseInt(param, "PlayerNum_" $ string (i) , teamID);  //���� �÷��̾��� ������ 1�� 2��

	//		debug("PlayerNum_" $i$"����"$ teamID);
			if (teamID != m_PlayerNum)  //������ �ƴϸ�Ѿ��
				continue;
			
			ParseInt(param, "ID_" $ string (i), PlayerID);
			ParseString(param, "Name_" $ string (i), m_Name);
			ParseInt(param, "ClassID_" $ string (i), m_ClassID);
			ParseInt(param, "MaxHP_" $ string (i), m_MaxHP);
			ParseInt(param, "CurHP_" $ string (i), m_CurHP);
			ParseInt(param, "MaxCP_" $ string (i), m_MaxCP);
			ParseInt(param, "CurCP_" $ string (i), m_CurCP);
			ParseInt(param, "SysMsg_" $ string (i), m_MsgWnd);		//�޽���������
			
			UserInfo[m_UserInfoIdx].m_TeamID = teamID;
			UserInfo[m_UserInfoIdx].m_ID =PlayerID;
			UserInfo[m_UserInfoIdx].m_Name = m_Name;
			UserInfo[m_UserInfoIdx].m_ClassID = m_ClassID;
			UserInfo[m_UserInfoIdx].m_MaxHP = m_MaxHP;
			UserInfo[m_UserInfoIdx].m_CurHP =m_CurHP;
			UserInfo[m_UserInfoIdx].m_MaxCP =m_MaxCP;
			UserInfo[m_UserInfoIdx].m_CurCP =m_CurCP;	
			UserInfo[m_UserInfoIdx].m_MsgWnd =m_MsgWnd;			//�޽���������

			m_UserInfoIdx++;
	//		debug("�Ĵ���" $ m_UserInfoIdx);
			
		}
		
//		Debug("Resize" $m_TotalCount/2);
		Resize(m_TotalCount/2);
			
		
			
		UpdateUsersInfo();

	}	
}

//MagicSkill���� ó��
function HandleMagicSkillUse(string param)
{
	local int ID;
	local int SkillID;
	local int i;
	local string paramsend;
	local string strMsg;
	
	ParseInt(param, "AttackerID", ID);


	for (i=0; i<m_MyTeamCount ; i++)
	{
		if (ID<1 || ID==UserInfo[i].m_ID)
		{
			break;
		}
	}
	if (i != m_MyTeamCount)
	{
		ParseInt(param, "SkillID", SkillID);
		if (0 > SkillID || 1999 < SkillID)
		{
			return;
		}
	
		//�޼����� ����, ������
		ParamAdd(paramsend, "Type", string(int(ESystemMsgParamType.SMPT_SKILLID)));
		ParamAdd(paramsend, "param1", string(SkillID));
		ParamAdd(paramsend, "param2", "1");
		AddSystemMessageParam(paramsend);
		strMsg = EndSystemMessageParam(46, true);
//		debug("��ų�޼���" $ strMsg);
		UpdateMsg(i, strMsg);
	}

}

//Attackl���� ó��
function HandleAttack(string param)
{
	local int		AttackerID;
	local string		AttackerName;
	local int		DefenderID;
	local int		Critical;
	local int		Miss;
	local int		ShieldDefense;
	local int 		i;
	local string		paramsend;
	local string		strMsg;
	
	ParseInt(param, "AttackerID", AttackerID);
	ParseString(param, "AttackerName", AttackerName);
	ParseInt(param, "DefenderID", DefenderID);
	ParseInt(param, "Critical", Critical);
	ParseInt(param, "Miss", Miss);
	ParseInt(param, "ShieldDefense", ShieldDefense);
	
	
	for (i=0; i< m_MyTeamCount ; i++)
	{
	//	debug("AttackerID"$AttackerID $"UserInfoID"$ UserInfo[i].m_ID); 
		if (AttackerID > 0 && AttackerID == UserInfo[i].m_ID)
		//~ if (AttackerID > 0 )
		{
			if (Critical>0)
			{
	//			debug("ǥ�ð��Ǿߵ���"$i $"  " $Critical);
				UpdateMsg(i, GetSystemMessage(44));
		//��ġ��		UpdateMsg(GetSystemMessage(44));
			}
		}
		else if (DefenderID>0 && DefenderID==UserInfo[i].m_ID)
		//~ else if (DefenderID>0 )
		{
			if (Miss>0)
			{

		//		debug("ǥ�ð��Ǿߵ���~~"$i $"  "$ Miss);
				//�޼����� ����, ������
				ParamAdd(paramsend, "Type", string(int(ESystemMsgParamType.SMPT_STRING)));
				ParamAdd(paramsend, "param1", AttackerName);
				AddSystemMessageParam(paramsend);
				strMsg = EndSystemMessageParam(42, true);

				UpdateMsg(i, strMsg);
				
//��ġ��				UpdateMsg(strMsg);
			}
			else if (ShieldDefense>0)
			{
				UpdateMsg(i, GetSystemMessage(111));
//��ġ��				UpdateMsg(GetSystemMessage(111));
			}
		}
	}
}

//Update Message

function UpdateMsg(int Userindex, string strMsg)
{
	local int i;
	local int CurPos;
	local int BoxPos;
	
	m_MsgStartLine[Userindex] = (Userindex * MAX_OLYMPIAD_SKILL_MSG) + (m_MsgNextStartLine[Userindex] % MAX_OLYMPIAD_SKILL_MSG);
	m_Msg[m_MsgStartLine[Userindex]] = strMsg;
	m_MsgNextStartLine[Userindex] = m_MsgStartLine[Userindex] + 1;
	
//	debug("StartLine"$m_MsgStartLine[Userindex]);
	for (i=0; i<MAX_OLYMPIAD_SKILL_MSG; i++)
	{
		CurPos = Userindex * MAX_OLYMPIAD_SKILL_MSG + ((m_MsgStartLine[Userindex] + i) % MAX_OLYMPIAD_SKILL_MSG);
//		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".txtMsg" $ MAX_OLYMPIAD_SKILL_MSG-1-i, m_Msg[CurPos]);

		BoxPos = Userindex * MAX_OLYMPIAD_SKILL_MSG + MAX_OLYMPIAD_SKILL_MSG-1-i;
		m_TextBoxHandle[BoxPos].SetText(m_Msg[CurPos]);
//		debug("BoxPos"$BoxPos $"CurPos"$CurPos$" "$m_Msg[CurPos]);
	}
}

//Update Message

function UpdateUsersInfo()
{
	local int i;
	//local int j;
	
	//j = 0;
	
//	debug("m_MyTeamCount"$m_MyTeamCount);
	for(i = 0; i <m_MyTeamCount; i++)
	{

//		if (m_IsPlayer == 1) // ������ 
//		{
//		if (UserInfo[i].m_TeamID == m_PlayerNum)	//���� �� 
//		{
		Updateuserinfo(i);
//			j++;
			
//		}			
//		}
	}
	me.showwindow();

}

function Updateuserinfo(int index)
{
	//���� ����(10.04.01) �Ϸ�
	//�̸�
	if( m_PlayerNum == 1 )
	{
		//m_PlayerName[index].SetName(UserInfo[index].m_Name, NCT_Normal,TA_Center);
		m_PlayerName[index].SetNameWithColor( UserInfo[index].m_Name, NCT_Normal,TA_Center, Blue );
	}
	else
	{
		//m_PlayerName[index].SetName(UserInfo[index].m_Name, NCT_Normal,TA_Center);
		m_PlayerName[index].SetNameWithColor( UserInfo[index].m_Name, NCT_Normal,TA_Center, Red );
	}
	//CP
	if (UserInfo[index].m_MaxCP>0)
	{
		m_BarCP[index].SetValue (UserInfo[index].m_MaxCP , UserInfo[index].m_CurCP);
	}
	else
	{
		m_BarCP[index].SetValue ( 0 , 0);
	}
	
	// HP
	if (UserInfo[index].m_MaxHP>0)
	{
		m_BarHP[index].SetValue (UserInfo[index].m_MaxHP , UserInfo[index].m_CurHP);
	}
	else
	{
		m_BarHP[index].SetValue ( 0 , 0);
	}
	

}

function OnClickButton( string strID )
{
	switch( strID )
	{
		case "btnExpand":
			SetExpandMode(false);
			break;
		case "btnContract":
			SetExpandMode(true);
			break;
	}
}


//Expand���¿� ���� �������� ó��
function SetExpandMode(bool bExpand)
{
	local Rect 	rectWnd;
	local Rect 	rectBuffWnd;
	
	local int nWndWidth, nWndHeight;	// ������ ������ �ޱ� ����
	
	Me.GetWindowSize(nWndWidth, nWndHeight);
	
	if (bExpand)
	{
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".BackTex");
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".SysMsgWnd");
		btnExpand.ShowWindow();
		btnContract.HideWindow();
		Me.SetWindowSize(nWndWidth, EXPAND_HEIGHT);
	}
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".SysMsgWnd");
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".BackTex");
		btnExpand.HideWindow();
		btnContract.ShowWindow();
		Me.SetWindowSize(nWndWidth, CONTRACT_HEIGHT);
	}
	
	//Buff�����츦 �̵����� �ش�
	rectWnd = class'UIAPI_WINDOW'.static.GetRect(m_WindowName);
	rectBuffWnd = class'UIAPI_WINDOW'.static.GetRect(m_BuffWindowName);
	
	if (!bExpand)
	{	
		//Stuckable�Ӽ������� �̻��ϰ� ������ �� �����Ƿ� MoveEx�� ���
		if ( rectWnd.nY + 46 == rectBuffWnd.nY || rectWnd.nY + 47 == rectBuffWnd.nY )
		{
			class'UIAPI_WINDOW'.static.MoveEx(m_BuffWindowName, 0, 80);
		}
	}
	else
	{
		//Stuckable�Ӽ������� �̻��ϰ� ������ �� �����Ƿ� MoveEx�� ���
		if ( rectWnd.nY + 126 == rectBuffWnd.nY || rectWnd.nY + 127 == rectBuffWnd.nY )
		{
			class'UIAPI_WINDOW'.static.MoveEx(m_BuffWindowName, 0, -80);
		}
	}
}


function Resize( int count )
{
	//�޽��������� ��Ե� �������-_-a
	local Rect entireRect, statusWndRect, msgWndRect;
	entireRect = me.GetRect();
	statusWndRect = m_StatusWnd[0].GetRect();
	msgWndRect = m_msgWnd[0].GetRect();

	//debug("count"$count);
	//debug("entireRect.nWidth"$entireRect.nWidth$"statusWndRect.nHeight"$ statusWndRect.nHeight);
	me.SetWindowSize( entireRect.nWidth, (statusWndRect.nHeight + msgWndRect.nHeight - 8) *count );
	me.SetResizeFrameSize( 10, (statusWndRect.nHeight + msgWndRect.nHeight - 8) *count );



	if (m_TotalCount == 2)
	{
		m_StatusWnd[0].Showwindow();
		m_StatusWnd[1].Hidewindow();
		m_StatusWnd[2].Hidewindow();
		m_MsgWnd[0].Showwindow();
		m_MsgWnd[1].Hidewindow();
		m_MsgWnd[2].Hidewindow();
	//	StatusIcon[0].ShowWindow();
	//	StatusIcon[1].HideWindow();
	//	StatusIcon[2].HideWindow();
		




	}
	else if (m_TotalCount == 6)
	{
		m_StatusWnd[0].Showwindow();
		m_StatusWnd[1].Showwindow();
		m_StatusWnd[2].Showwindow();
		m_MsgWnd[0].Showwindow();
		m_MsgWnd[1].Showwindow();
		m_MsgWnd[2].Showwindow();
	//	StatusIcon[0].ShowWindow();
	//	StatusIcon[1].Showwindow();
	//	StatusIcon[2].Showwindow();

	
	}

}
defaultproperties
{
}
