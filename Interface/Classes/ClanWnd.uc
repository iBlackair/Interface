class ClanWnd extends UIScriptEx;

var int m_clanID;
var string m_clanName;
var int m_clanRank;
var int m_clanLevel;
var int m_clanNameValue;
var int m_bMoreInfo;
var int m_currentShowIndex;
var int G_CurrentRecord;
var string G_CurrentSzData;
var bool G_CurrentAlias;
var bool G_IamNobless;
var bool G_IamHero;
var int G_ClanMember;
var String m_WindowName;

// �ڽ��� ���� ����
var int 	m_myClanType;
var string 	m_myName;
var string 	m_myClanName;
var int 	m_indexNum;
//var int 	m_indexNumKH;

//Global bool variables to manage the status of the drawer wnd opened and closed;
var bool m_currentactivestatus1; //��������â
var bool m_currentactivestatus2; //��������â
var bool m_currentactivestatus3; //��������
var bool m_currentactivestatus4; //�г�Ƽ
var bool m_currentactivestatus5; //��������
var bool m_currentactivestatus6; //��������
var bool m_currentactivestatus7; //�������
var bool m_currentactivestatus8; //�����޴�

// ���� ����(�ڽ�)
var int		m_bClanMaster;
var int		m_bJoin;
var int		m_bNickName;
var int		m_bCrest;
var int		m_bWar;
var int		m_bGrade;
var int		m_bManageMaster;
var int		m_bOustMember;

var 	TextBoxHandle	txtDominionWarTitle;
var 	TextBoxHandle	txtDominionWarStatus;
var 	TextBoxHandle	TxtDominionWar_Title;
var 	TextBoxHandle	TxtDominion;
var 	TextBoxHandle	TxtDominionWarStatusTitle;
var 	TextBoxHandle	TxtClanWar_Title;

var ListCtrlHandle	m_hClanMemberList;

//���� ���õ� �׷��� ������ �̸�
var string m_CurrentclanMasterName;
// ���� ���õ� �׷��� ������ �̸�
var string m_CurrentclanMasterReal;
//���� ���õ� ������ ����?
var int m_CurrentNHType;

//var array<int>		m_knighthoodList;				// ���� â���� ������ �ε�����( �������� �ʴ� ������ �����ָ� �ȵ� )
var array<ClanInfo> m_memberList;

//�� ���� ���� ���� oxyzen coded
function getmyClanInfo() 
{
	local UserInfo userinfo;
	//userinfo = GetUser();
	if( GetPlayerInfo( userinfo ) )
	{
		m_myName = userinfo.Name;
		m_myClanType = findmyClanData(m_myName);
		G_IamNobless = userinfo.bNobless;
		G_IamHero = userinfo.bHero;
		G_ClanMember = userinfo.nClanID;
	}
	//Debug("------------------------------------------------------------------");
	//Debug("MyNameGet =" @  m_myName);
	//Debug("MyClanTypeGet =" @  m_myClanType);
	//Debug("MyClanMember =" @  G_ClanMember);
	//Debug("IamHero =" @  G_IamHero);
	//Debug("G_IamNobless =" @  G_IamNobless);
	//Debug("MyClanNameGet = " @ m_myClanName);
	//Debug("------------------------------------------------------------------");

}

//�� ���� ������ ã�ƿ��� �Լ�.
function int findmyClanData(string C_Name)
{
	local int i;
	local int j;
	local int clannum;
	for( i=0 ; i < m_memberList.Length ; ++i )
	{
		for ( j = 0 ; j < m_memberList[i].m_array.Length ; ++j )
		{
			if(m_memberList[i].m_array[j].sName == C_Name)
			{
				clannum = m_memberList[i].m_array[j].clanType;
				//m_myClanName = m_memberList[i].sName;
			}
		}
	}
	return clannum;
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	m_WindowName="ClanWnd";

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();		
	
	Load();	// GMClanWnd���� ���

	m_memberList.Length = CLAN_KNIGHTHOOD_COUNT;

	m_currentShowIndex = 0;
	m_bMoreInfo = 0;
	G_CurrentAlias = false;

	Clear();
	
	//set entire windows has closed.
	m_currentactivestatus1 = false;
	m_currentactivestatus2 = false;
	m_currentactivestatus3 = false;
	m_currentactivestatus4 = false;
	m_currentactivestatus5 = false;
	m_currentactivestatus6 = false;
	m_currentactivestatus7 = false;

	class'UIDATA_CLAN'.static.RequestClanInfo();

	m_hClanMemberList=GetListCtrlHandle(m_WindowName $ ".ClanMemberList");
}

function InitHandle()
{
	TxtDominionWar_Title = TextBoxHandle ( GetHandle( "ClanDrawerWnd.ClanWarManagementWnd.TxtDominionWar_Title" ) );
	TxtDominion = TextBoxHandle ( GetHandle( "ClanDrawerWnd.ClanWarManagementWnd.TxtDominion" ) );
	TxtDominionWarStatusTitle = TextBoxHandle ( GetHandle( "ClanDrawerWnd.ClanWarManagementWnd.TxtDominionWarStatusTitle" ) );
	TxtClanWar_Title = TextBoxHandle ( GetHandle( "ClanDrawerWnd.ClanWarManagementWnd.TxtClanWar_Title" ) );
	
	txtDominionWarTitle = TextBoxHandle ( GetHandle( "ClanDrawerWnd.ClanWarManagementWnd.txtDominionWarTitle" ) );
	txtDominionWarStatus = TextBoxHandle ( GetHandle( "ClanDrawerWnd.ClanWarManagementWnd.txtDominionWarStatus" ) );
}

function InitHandleCOD()
{
	TxtDominionWar_Title = GetTextBoxHandle (  "ClanDrawerWnd.ClanWarManagementWnd.TxtDominionWar_Title"  );
	TxtDominion = GetTextBoxHandle (  "ClanDrawerWnd.ClanWarManagementWnd.TxtDominion"  );
	TxtDominionWarStatusTitle = GetTextBoxHandle (  "ClanDrawerWnd.ClanWarManagementWnd.TxtDominionWarStatusTitle"  );
	TxtClanWar_Title = GetTextBoxHandle (  "ClanDrawerWnd.ClanWarManagementWnd.TxtClanWar_Title"  );
	
	
	
	txtDominionWarTitle = GetTextBoxHandle (  "ClanDrawerWnd.ClanWarManagementWnd.txtDominionWarTitle"  );
	txtDominionWarStatus = GetTextBoxHandle (  "ClanDrawerWnd.ClanWarManagementWnd.txtDominionWarStatus"  );
}


function Load()
{
	
}

function OnRegisterEvent()
{
	registerEvent( EV_ClanInfo );
	registerEvent( EV_ClanInfoUpdate );
	registerEvent( EV_ClanDeleteAllMember );
	registerEvent( EV_ClanAddMember );
	registerEvent( EV_ClanMemberInfoUpdate );
	registerEvent( EV_ClanAddMemberMultiple );
	registerEvent( EV_ClanDeleteMember );
	registerEvent( EV_GamingStateEnter );
	registerEvent( EV_GamingStateExit );
	registerEvent( EV_ClanMyAuth );
	registerEvent( EV_ClanSubClanUpdated );
	registerEvent( EV_ResultJoinDominionWar );
}

// �����
function int GetClanTypeFromIndex( int index )
{
	local int type;
	if( index == 0 )
	{
		type = CLAN_MAIN;
	}
	if( index == 1 )
	{
		type = CLAN_KNIGHT1;
	}
	if( index == 2 )
	{
		type = CLAN_KNIGHT2;
	}
	if( index == 3 )
	{
		type = CLAN_KNIGHT3;
	}
	if( index == 4 )
	{
		type = CLAN_KNIGHT4;
	}
	if( index == 5 )
	{
		type = CLAN_KNIGHT5;
	}
	if( index == 6 )
	{
		type = CLAN_KNIGHT6;
	}
	if( index == 7 )
	{
		type = CLAN_ACADEMY;
	}
	return type;
}

function string GetClanTypeNameFromIndex(int index)
{
	local string type;
	if( index == CLAN_MAIN )
	{
		type = GetSystemString(1399);
	}
	if( index == CLAN_KNIGHT1 )
	{
		type = GetSystemString(1400);
	}
	if( index == CLAN_KNIGHT2 )
	{
		type = GetSystemString(1401);
	}
	if( index == CLAN_KNIGHT3 )
	{
		type = GetSystemString(1402);
	}
	if( index == CLAN_KNIGHT4 )
	{
		type = GetSystemString(1403);
	}
	if( index == CLAN_KNIGHT5 )
	{
		type = GetSystemString(1404);
	}
	if( index == CLAN_KNIGHT6 )
	{
		type = GetSystemString(1405);
	}
	if( index == CLAN_ACADEMY )
	{
		type = GetSystemString(1452);
	}
	return type;
}

function OnShow()
{
	local int i;
	getmyClanInfo();
	RefreshCombobox();
	resetBtnShowHide();
	NoblessMenuValidate();
	
	
	//class'UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".MemberInfoBtnWnd");

	
	//class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ClanMemberList", m_indexNumKH);
	//debug("ShowmyIndexNum:" @ m_indexNumKH);
	//debug("Showm_myClanType:" @ m_myClanType);
	//class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd")
	
	for (i=10; i>=0; --i)
	{
		//ComboboxData = class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i)
		if (class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i) == m_myClanType)
		{
			//debug("What:"@ class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i));
			//Debug("ComboboxLoc:"@i);
			//Debug("m_myClanType:"@m_myClanType);
			class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd", i);
		} 
	}
	//if (class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i) == -1)
	//{
			//Debug("ComboboxLoc:"@i);
			//class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd", i);
	//} 
	ShowList(m_myClanType);
	class'UIAPI_LISTCTRL'.static.SetSelectedIndex( m_WindowName $ ".ClanMemberList", m_indexNum ,true);
	//TTP 15881 ��ī���� ������ ����
	if (m_myClanType == -1)
	{
	class'UIAPI_LISTCTRL'.static.SetSelectedIndex( m_WindowName $ ".ClanMemberList", m_indexNum -1,true);
	}

}

function NoblessMenuValidate()
{
	//debug("NoblessMenuValidate");
	if (G_ClanMember == 0)
	{
		if (G_IamHero == true || G_IamNobless == true)
		{
			class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".HeroBtn");
			class'UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanMemInfoBtn");
		}
		else
		{
			class'UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".HeroBtn");
			class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemInfoBtn");
		}
	}
	else
	{
		class'UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".HeroBtn");
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemInfoBtn");
	}
}

function OnHide()
{
	// 2006/04/03 - Removed by NeverDie
	//	Drawer child window now automatically hides upon hiding Drawer parent window
	//class'UIAPI_WINDOW'.static.HideWindow("ClanDrawerWnd");
}

//function OnKeyDown(EInputKey nKey)
//{
	//if (nKey == IK_N )
	//{
	//debug("keyinput");
	//getmyClanInfo();
	//NoblessMenuValidate();
	//}
	//if (nKey == IK_alt + IK_N )
	//{
	//debug("keyinput");
	//getmyClanInfo();
	//NoblessMenuValidate();
	//}
//}

function OnEnterState( name a_PreStateName )
{
	getmyClanInfo();
	NoblessMenuValidate();
	//if( a_PreStateName == 'GamingState' )
	//{
	//	getmyClanInfo();
	//	NoblessMenuValidate();
	//}
	Clear();
	class'UIDATA_CLAN'.static.RequestClanInfo();
}

function OnClickButton( string strID )
{
	local ClanDrawerWnd script;
	local LVDataRecord record;
	local string strParam;

	record.LVDataList.Length = 10;

	script = ClanDrawerWnd( GetScript("ClanDrawerWnd") );
	// ���� ����
	if( strID == "ClanMemInfoBtn" )
	{
		if( m_currentactivestatus1 == false)
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = true;
			// �ƹ��͵� ���� ���ڵ尡 ���ϵ� ���� �ִ�. üũ�� ��.
			if( GetSelectedListCtrlItem( record ) )
			{
				//debug("Asking ClanMemberInfo " $ record.LVDataList[0].szData $ " " $ record.LVDataList[0].nReserved1 );
				RequestClanMemberInfo( Int64ToInt(record.nReserved1), record.LVDataList[0].szData );
				G_CurrentRecord = Int64ToInt(record.nReserved1);
				G_CurrentSzData = record.LVDataList[0].szData;
				if (record.LVDataList[3].szData == "0")
				{
					G_CurrentAlias = true;
				} 
				else
				{
					G_CurrentAlias = false;
				}
				script.SetStateAndShow("ClanMemberInfoState");
			}
		} else {
		// ����â�� �۷ι� ������ ����
		m_currentactivestatus1 = false;
		script.HideClanWindow();
		}
	}

	//��������
	else if( strID == "ClanMemAuthBtn" )
	{
		if(m_currentactivestatus2 == false)
		{
			ResetOpeningVariables();
			m_currentactivestatus2 = true;
			if( GetSelectedListCtrlItem( record ) )
			{
				RequestClanMemberAuth( Int64ToInt(record.nReserved1), record.LVDataList[0].szData );
				script.SetStateAndShow("ClanMemberAuthState");
			}
		} else {
		// ����â�� �۷ι� ������ ����
		m_currentactivestatus2 = false;
		script.HideClanWindow();
		}
	}
	//�Խ���
	else if( strID == "ClanBoardBtn" )
	{
		// request open BBS
		ParamAdd(strParam, "Index", "4");
		ExecuteEvent(EV_ShowBBS, strParam);
	}
	//��������
	else if( strID == "ClanInfoBtn" )
	{
		if(m_currentactivestatus3 == false)
		{
			ResetOpeningVariables();
			m_currentactivestatus3 = true;
			script.SetStateAndShow("ClanInfoState");
		} else {
		m_currentactivestatus3 = false;
		script.HideClanWindow();
		}
		
	}
	//�г�Ƽ
	else if( strID == "ClanPenaltyBtn" )
	{
		//script.SetStateAndShow("ClanPenaltyWndState");
		ExecuteCommandFromAction("pledgepenalty");
	}
	//����Ż��
	else if( strID == "ClanQuitBtn" )
	{
		// Ask to quit Clan
		RequestClanLeave(m_clanName, m_myClanType);
	}
	//��������
	else if( strID == "ClanWarInfoBtn" )
	{
		if(m_currentactivestatus5 == false)
		{
			ResetOpeningVariables();
			m_currentactivestatus5 = true;
			script.m_clanWarListPage = -1;
			RequestClanWarList(0, 0);			// 0 page
			script.SetStateAndShow("ClanWarManagementWndState");
		} else {
		m_currentactivestatus5 = false;
		script.HideClanWindow();
		}
	}
	//���Ｑ��
	else if( strID == "ClanWarDeclareBtn" )
	{
		RequestClanDeclareWar();
	}
	//����öȸ
	else if( strID == "ClanWarCancleBtn" )
	{
		RequestClanWithdrawWar();
	}
	//���Ա���
	else if( strID == "ClanAskJoinBtn" )
	{
		AskJoin();
	}
	//��������
	else if( strID == "ClanAuthEditBtn" )
	{
		if(m_currentactivestatus6 == false)
		{
			ResetOpeningVariables();
			m_currentactivestatus6 = true;
			RequestClanGradeList();
			script.SetStateAndShow("ClanAuthManageWndState");
		} else {
		m_currentactivestatus6 = false;
		script.HideClanWindow();
		}
	}
	//�������
	else if( strID == "ClanTitleManageBtn" )
	{
		if(m_currentactivestatus7 == false)
		{
			ResetOpeningVariables();
			m_currentactivestatus7 = true;
			script.SetStateAndShow("ClanEmblemManageWndState");
		} else {
		m_currentactivestatus7 = false;
		script.HideClanWindow();
		}
	} 
	else if( strID == "HeroBtn" )
	{
		if(m_currentactivestatus8 == false)
		{
			m_currentactivestatus8 = true;
			script.SetStateAndShow("ClanHeroWndState");
		} else {
			m_currentactivestatus8 = false;
			script.HideClanWindow();
		}
	}
	
	
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_ClanDeleteAllMember:	// Enter world �Ҷ� ���� ��������
		Clear();
		break;
	case EV_GamingStateExit:		// Clear
		Clear();
		break;
	case EV_ClanInfo:
		HandleClanInfo( a_Param );
		break;
	case EV_ClanAddMemberMultiple:
		HandleAddClanMemberMultiple( a_Param );
		break;
	case EV_ClanMemberInfoUpdate:
		HandleMemberInfoUpdate( a_Param );
		break;
	case EV_ClanAddMember:
		HandleAddClanMember( a_Param );
		break;
	case EV_ClanDeleteMember:
		HandleDeleteMember( a_Param );
		break;
	case EV_ClanInfoUpdate:
		HandleClanInfoUpdate( a_Param );
		break;
	case EV_ClanSubClanUpdated:
		HandleSubClanUpdated( a_Param );
		break;
	case EV_ClanMyAuth:
		HandleClanMyAuth( a_Param );
		break;
	case EV_ResultJoinDominionWar:
		HandleEV_ResultJoinDominionWar();
	default:
		break;
	}
}

function OnComboBoxItemSelected( string sName, int index )
{
	ClearList();
	//debug("information:" @ class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd")) @ class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd"));
	ShowList(class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd")));
	//if( index == m_indexNumKH)
	//{
	//	class'UIAPI_LISTCTRL'.static.SetSelectedIndex( m_WindowName $ ".ClanMemberList", m_indexNum ,true);
	//}	
}


//{
//	debug("OnComboBoxItemSelected" $ index);
//	
//	ClearList();
//
//	if( index == 0 )
//		ShowList(CLAN_MAIN);
//	else if(index == 1)
//		//ShowList(CLAN_ACADEMY);
//		ShowList(CLAN_KNIGHT1);
//	else if(index == 2)
//		ShowList(CLAN_KNIGHT2);
//	else if(index == 3)
//		ShowList(CLAN_KNIGHT3);
//	else if(index == 4)
//		ShowList(CLAN_KNIGHT4);
//	else if(index == 5)
//		ShowList(CLAN_KNIGHT5);
//	else if(index == 6)
//		ShowList(CLAN_KNIGHT6);
//	else if(index == 7)
//		ShowList(CLAN_ACADEMY);
//}


function OnClickListCtrlRecord( string ListCtrlID)
{
	local ClanDrawerWnd script;
	local LVDataRecord record;

	record.LVDataList.Length = 10;

	script = ClanDrawerWnd( GetScript("ClanDrawerWnd") );
	//Ŭ���� ���� ����â�� ���� ������ Ŭ���� �������� ������ ���� 
	if (ListCtrlID == "ClanMemberList")
	{
		if ( m_currentactivestatus1 == true)
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = true;
			if( GetSelectedListCtrlItem( record ) )
			{
				RequestClanMemberInfo( Int64ToInt(record.nReserved1), record.LVDataList[0].szData );
				G_CurrentRecord = Int64ToInt(record.nReserved1);
				G_CurrentSzData = record.LVDataList[0].szData;
				if (record.LVDataList[3].szData == "0")
				{
					G_CurrentAlias = true;
				} 
				else
				{
					G_CurrentAlias = false;
				}
				script.SetStateAndShow("ClanMemberInfoState");
			}
		} 
		//Ŭ���� ���� ����â�� ���� ������ Ŭ���� �������� ������ ���� 
		if ( m_currentactivestatus2 == true)
		{
			ResetOpeningVariables();
			m_currentactivestatus2 = true;
			if( GetSelectedListCtrlItem( record ) )
			{
				RequestClanMemberAuth( Int64ToInt(record.nReserved1), record.LVDataList[0].szData );
				script.SetStateAndShow("ClanMemberAuthState");
			}
		} 
	}
}

function OnDBClickListCtrlRecord( string ListCtrlID)
{
	local ClanDrawerWnd script;
	local LVDataRecord record;

	record.LVDataList.Length = 10;

	script = ClanDrawerWnd( GetScript("ClanDrawerWnd") );
	// ����Ʈ�� ���� Ŭ�� �ϸ� ���� ����â���� ������ ��Ŀ���� ��ȯ�Ѵ�. 
	if (ListCtrlID == "ClanMemberList")
	{
		if( m_currentactivestatus1 == false)
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = true;
			if( GetSelectedListCtrlItem( record ) )
			{
				RequestClanMemberInfo( Int64ToInt(record.nReserved1), record.LVDataList[0].szData );
				G_CurrentRecord = Int64ToInt(record.nReserved1);
				G_CurrentSzData = record.LVDataList[0].szData;
				
				if (record.LVDataList[3].szData == "0")
				{
					G_CurrentAlias = true;
				} 
				else
				{
					G_CurrentAlias = false;
				}
				
				script.SetStateAndShow("ClanMemberInfoState");
			}
		} 
		else 
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = true;
			if( GetSelectedListCtrlItem( record ) )
			{
				RequestClanMemberInfo( Int64ToInt(record.nReserved1), record.LVDataList[0].szData );
				G_CurrentRecord = Int64ToInt(record.nReserved1);
				G_CurrentSzData = record.LVDataList[0].szData;

				
				script.SetStateAndShow("ClanMemberInfoState");
			}
		}
	}
}


//coded by oxyzen reset btn on authority.
function resetBtnShowHide()
{
	local ClanDrawerWnd script;
	script = ClanDrawerWnd( GetScript("ClanDrawerWnd") );
	//debug("resetbtn running");
	NoblessMenuValidate();
	
	//���� �̰�����
	if(m_clanID == 0)
	{
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanMemInfoBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanMemAuthBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanInfoBtn");
		//class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanPenaltyBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanQuitBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAskJoinBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
		class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
	}                                                                    
	else 
	{
		// ���ͷ��� 5 �̻�
		if (m_clanLevel>5)
		{
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarDeclareBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarCancleBtn");
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
			class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
			class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
			class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
			class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
		}
		else
		{
			switch(m_clanLevel) 
			{
				//���ͷ��� 0 
				case 0:
					//��������
					//��������
					//��������
					//���Ƽ
					//���Ա���
					//��������
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
					//class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AskJoinPartyBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
				        class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
				break;
				
				case 1:
					//��������
					//��������
					//��������
					//���Ƽ
					//���Ա���
					//��������
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
					//class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AskJoinPartyBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
				        class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
				break;
				
				case 2:
					//��������
					//��������
					//��������
					//���Ƽ
					//���Ա���
					//��������
					//���ͰԽ���
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");					
					//class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AskJoinPartyBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
				break;
				
				case 3:
					//��������(ȣĪ����)
					//��������
					//��������
					//���Ƽ
					//���Ա���
					//��������
					//���ͰԽ���
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarDeclareBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarCancleBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");					
					//class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AskJoinPartyBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
				break;
				
				case 4:
					//��������
					//��������
					//��������
					//���Ƽ
					//���Ա���
					//��������
					//���ͰԽ���
					//��������
					//���Ｑ��
					//����öȸ
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarDeclareBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarCancleBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
					//class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AskJoinPartyBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
				break;
				
				case 5:
					//��������(������ ����, ������ ����);
					//��������
					//��������
					//���Ƽ
					//���Ա���
					//��������
					//���ͰԽ���
					//��������
					//���Ｑ��
					//����öȸ
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarDeclareBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarCancleBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					class'UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
				break;
				
			}
	
		}
		
		if(m_bClanMaster>0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanQuitBtn");		// �����ִ� Ż�� �ȵ�
			if (m_clanLevel > 2)
			{
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanTitleManageBtn");
			}
			class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAuthEditBtn"); //�����ָ� ���� ������.
			
		}
		else
		{
			class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
			class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
			class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
			class'UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
			
			if( m_bJoin == 0)
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAskJoinBtn");
			if(m_bCrest == 0 )
			{
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
			} 
			else
			{
				if (m_clanLevel > 2)
				{
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanTitleManageBtn");
				}
			}
			if(m_bWar == 0 )
			{
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
			}
			//if(m_bGrade == 0)
				//class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
		}
		//script.OnShow();
		script.CheckandCompareMyNameandDisableThings();
		//script.m_myName
	}

	NoblessMenuValidate();
}

function Clear()		// clear this Script
{
	local ClanDrawerWnd script;
	local int i;

	ClearList();
	script = ClanDrawerWnd( GetScript("ClanDrawerWnd") );
	script.Clear();
	
	class'UIAPI_WINDOW'.static.HideWindow("ClanDrawerWnd");
	class'UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");

	class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanNameText", "" );
	class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanMasterNameText", "");
	class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetSystemString( 27 ) );	// ����
	class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanStatusText", "");
	class'UIAPI_TEXTBOX'.static.SetInt( m_WindowName $ ".ClanLevelText", 0);

	class'UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".ComboboxMainClanWnd");
	m_clanID = 0;
	m_clanName = "";
	m_clanRank = 0;
	m_clanLevel = 0;
	m_clanNameValue = 0;
	m_bMoreInfo = 0;
	m_currentShowIndex = 0;

	m_bClanMaster = 0;
	m_bJoin = 0;
	m_bNickName = 0;
	m_bCrest = 0;
	m_bWar = 0;
	m_bGrade = 0;
	m_bManageMaster = 0;
	m_bOustMember = 0;

	for( i=0; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
	{
		m_memberList[ i ].m_array.Remove(0, m_memberList[ i ].m_array.Length);
		m_memberList[ i ].m_sName = "";
		m_memberList[ i ].m_sMasterName = "";
	}
}


function HandleEV_ResultJoinDominionWar()
{
	class'UIDATA_CLAN'.static.RequestClanInfo();
}

function HandleClanInfo( String a_Param )
{
	local string clanMasterName;
	local string clanName;
	local int crestID;
	local int skillLevel;
	local int castleID;
	local int agitID;
	local int fotressID;
	local int status;
	local int bGuilty;
	local int allianceID;
	local string allianceName;
	local int allianceCrestID;
	local int bInWar;
	local int clanType;
	local int clanRank;
	local int clanNameValue;
	local int clanID;
	local int JoinDominionWarID;

	parseInt( a_Param, "JoinDominionWarID", JoinDominionWarID );
	
	debug ("a_Param" @ a_Param);
	
	if (JoinDominionWarID == 0)
	{
		// ������ ������ ����
		//~ Debug ("ClanInfoInsertion");
		//~ TxtDominion.SetText(GetSystemString(1989));	//������ 
		//~ txtDominionWarStatus.SetText(GetSystemMessage(2917));	//������ ������ ����

		//TxtDominion.SetText("����");	//������ 
		//txtDominionWarStatus.SetText("������ ������ ����");	//������ ������ ����
		txtDominion.SetText(GetSystemString(1989));	//������ 
		txtDominionWarStatus.SetText(GetSystemMessage(2917));	//������ ������ ����

	}
	else 
	{
		// ������ ���� ����
		//~ Debug ("ClanInfoInsertion2");
		//~ TxtDominion.SetText(GetSystemString(1989));	//������ 
		//~ txtDominionWarStatus.SetText(MakeFullSystemMsg(GetSystemMessage(2917), GetCastleName(JoinDominionWarID),"")); // ����� ������ ���� ����
		// TxtDominion.SetText(GetCastleName(JoinDominionWarID));	//������ 
		//txtDominionWarStatus.SetText("������ ���� ����");	//������ ������ ����
		//TxtDominion.SetText(GetSystemString(1989));	//������ 
		//~ txtDominionWarStatus.SetText(MakeFullSystemMsg(GetSystemMessage(2917), GetCastleName(JoinDominionWarID),"")); // ����� ������ ���� ����

		TxtDominion.SetText(GetCastleName(JoinDominionWarID));	//������ 
		//txtDominionWarStatus.SetText(GetSystemMessage(2916));
		txtDominionWarStatus.SetText(MakeFullSystemMsg(GetSystemMessage(2916), GetCastleName(JoinDominionWarID),"")); // ����� ������ ���� ����
	}
	
	
	
	
	
	
	
	ParseInt( a_Param, "ClanID", clanID );
	ParseInt( a_Param, "ClanType", clanType );
	m_CurrentNHType = clanType;
	ParseString( a_Param, "ClanName", clanName );
	ParseString( a_Param, "ClanMasterName", clanMasterName );
	m_CurrentclanMasterName = clanMasterName;
	if( clanType == CLAN_MAIN )
		m_CurrentclanMasterReal = clanMasterName;
	ParseInt( a_Param, "CrestID", crestID );
	ParseInt( a_Param, "SkillLevel", skillLevel );
	ParseInt( a_Param, "CastleID", castleID );
	ParseInt( a_Param, "AgitID", agitID );
	ParseInt( a_Param, "FortressID", fotressID );
	ParseInt( a_Param, "ClanRank", clanRank );
	ParseInt( a_Param, "ClanNameValue", clanNameValue );
	ParseInt( a_Param, "Status", status );
	ParseInt( a_Param, "Guilty", bGuilty );
	ParseInt( a_Param, "AllianceID", allianceID );
	ParseString( a_Param, "AllianceName", allianceName );
	ParseInt( a_Param, "AllianceCrestID", allianceCrestID );
	ParseInt( a_Param, "InWar", bInWar );

	//debug("fotressID : " $ Right(a_Param, 175));

	if( clanType == CLAN_MAIN )
	{
		m_clanName = clanName;
		m_clanRank = clanRank;
		m_clanNameValue = clanNameValue;
		m_clanLevel = skillLevel;
		m_clanID = clanID;
	}

	m_memberList[ GetIndexFromType( clanType ) ].m_sName = clanName;
	m_memberList[ GetIndexFromType( clanType ) ].m_sMasterName = clanMasterName;

	//debug( "ClanWnd::HandleClanInfo name " $ clanName $ ", master " $ clanMasterName $ " type " $ clanType );
	//debug("fotressID : " $ fotressID);
	if( clanType == CLAN_MAIN )
	{
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanNameText", clanName );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanMasterNameText", m_CurrentclanMasterReal );
		if( agitID > 0 )
			class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetCastleName( agitID ) );	// ����Ʈ
		else if( castleID > 0 )
			class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetCastleName( castleID ) );	// ��
		else if( fotressID > 0)
		{
			//debug("fotressName : " $ GetCastleName( fotressID ));
			class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetCastleName( fotressID ) );	// ���
		}
		else
			class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetSystemString( 27 ) );	// ����

		if( status == 3 )
			class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanStatusText", GetSystemString(341));
		else if( bInWar == 0 )
			class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanStatusText", GetSystemString(894));
		else
			class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanStatusText", GetSystemString(340));

		class'UIAPI_TEXTBOX'.static.SetInt( m_WindowName $ ".ClanLevelText", skillLevel );
	}
	
	//~ if (JoinDominionWarID != 0)
	//~ {
		//~ txtDominionWarTitle.SetText("������");
		//~ txtDominionWarStatus.SetText("������ ������ ����");
	//~ }
	//~ else 
	//~ {
		//~ txtDominionWarTitle.SetText("������");
		//~ txtDominionWarStatus.SetText( GetCastleName(JoinDominionWarID)$"���� ���� ����");
	//~ }
	
	RefreshComboBox();
	getmyClanInfo();
	
}

function HandleClanInfoUpdate( String a_Param )
{
	local int PledgeCrestID;
	local int CastleID;
	local int AgitID;
	local int fotressID;
	local int Status;
	local int bGuilty;
	local int AllianceId;
	local string sAllianceName;
	local int AllianceCrestId;
	local int InWar;
	local int LargePledgeCrestID;
	local ClanDrawerWnd script;
	local int JoinDominionWarID;
	parseInt( a_Param, "JoinDominionWarID", JoinDominionWarID );
	
	if (JoinDominionWarID == 0)
	{
		//~ Debug ("ClanInfoInsertion");
		//~ TxtDominion.SetText(GetSystemString(1989));	//������ 
		//~ txtDominionWarStatus.SetText(GetSystemMessage(2917));	//������ ������ ����
		// TxtDominion.SetText("����");	//������ 
		// txtDominionWarStatus.SetText("������ ������ ����");	//������ ������ ����

		TxtDominion.SetText(GetSystemString(1989));	//������ 
		txtDominionWarStatus.SetText(GetSystemMessage(2917));	//������ ������ ����

	}
	else 
	{
		//~ Debug ("ClanInfoInsertion2");
		TxtDominion.SetText(GetCastleName(JoinDominionWarID));	//������ 
		//txtDominionWarStatus.SetText(GetSystemMessage(2916));
		txtDominionWarStatus.SetText(MakeFullSystemMsg(GetSystemMessage(2916), GetCastleName(JoinDominionWarID),"")); // ����� ������ ���� ����
		// TxtDominion.SetText(GetCastleName(JoinDominionWarID));	//������ 
		// txtDominionWarStatus.SetText("������ ���� ����");	//������ ������ ����
	}
	
	ParseInt( a_Param, "ClanID", m_clanID );
	ParseInt( a_Param, "CrestID", PledgeCrestID );
	ParseInt( a_Param, "SkillLevel", m_clanLevel );
	ParseInt( a_Param, "CastleID", CastleID );
	ParseInt( a_Param, "AgitID", AgitID );
	ParseInt( a_Param, "FortressID", fotressID );
	ParseInt( a_Param, "ClanRank", m_clanRank );
	ParseInt( a_Param, "ClanNameValue", m_clanNameValue );
	ParseInt( a_Param, "Status", Status );
	ParseInt( a_Param, "Guilty", bGuilty );
	ParseInt( a_Param, "AllianceID", AllianceId );
	ParseString( a_Param, "AllianceName", sAllianceName );
	ParseInt( a_Param, "AllianceCrestID", AllianceCrestId );
	ParseInt( a_Param, "InWar", InWar );
	ParseInt( a_Param, "LargeCrestID", LargePledgeCrestID );

	if( class'UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd.ClanInfoWnd") )			// ���� ���� â�� �������� �ִٸ� ������Ʈ ���ش�.
	{
		script = ClanDrawerWnd( GetScript("ClanDrawerWnd") );
		script.InitializeClanInfoWnd();
	}

	//debug( "ClanWnd::HandleClanInfoUpdate" );
	if( AgitID > 0 )
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetCastleName( AgitID ) );	// ����Ʈ
	else if( CastleID > 0 )
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetCastleName( CastleID ) );	// ��
	else if( fotressID > 0)
		{
			//debug("fotressName : " $ GetCastleName( fotressID ));
			class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetCastleName( fotressID ) );	// ���
		}
	else
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanAgitText", GetSystemString( 27 ) );	// ����

	if( Status == 3 )
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanStatusText", GetSystemString(341));
	else if( InWar == 0 )
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanStatusText", GetSystemString(894));
	else
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".ClanStatusText", GetSystemString(340));

	class'UIAPI_TEXTBOX'.static.SetInt( m_WindowName $ ".ClanLevelText", m_clanLevel );
	
	resetBtnShowHide();
	getmyClanInfo();
}

function HandleAddClanMemberMultiple( String a_Param )
{
	local ClanMemberInfo info;
	local int count;
	local int index;

	ParseInt( a_Param, "ClanType", info.clanType );
	index = GetIndexFromType( info.clanType );
	ParseString( a_Param, "Name", info.sName );
	ParseInt( a_Param, "Level", info.level );
	ParseInt( a_Param, "Class", info.classID );
	ParseInt( a_Param, "Gender", info.gender );
	ParseInt( a_Param, "Race", info.race );
	ParseInt( a_Param, "ID", info.id );
	ParseInt( a_Param, "HaveMaster", info.bHaveMaster );

	//debug("HandleAddClanMemberMultiple type " $ info.clanType $ " name " $ info.sName $ ", class " $ info.classID $ ", gender " $ info.gender $ ", race " $ info.race $ ", ID " $ info.id $ ", haveMaster " $ info.bHaveMaster $ " index " $ index);

	count = m_memberList[ index ].m_array.Length;
	
	m_memberList[ index ].m_array.Length = count + 1;

	m_memberList[ index ].m_array[ count ] = info;

	if( index == m_currentShowIndex )
		ShowList( info.clanType );									// renew list
}


// ListCtrl related operations
function ClearList()
{
	class'UIAPI_LISTCTRL'.static.DeleteAllItem( m_WindowName $ ".ClanMemberList" );
}

function ShowList( int clanType )
{
	local int index;

	index = GetIndexFromType( clanType );

	m_currentShowIndex = index;
	ClearList();
	AddToList( index );
}

function int getClanKnighthoodMasterInfo(string NameVal)
{
	local int i;
	local int ReturnVal;
	
	for (i = 0; i <m_memberList[0].m_array.Length; ++i )
	{
		if (m_memberList[0].m_array[i].sName == NameVal)
		{
			ReturnVal = i;
		}
	}
	return ReturnVal;
}

function AddToList( int idx )
{
	local Color White;
	local Color Yellow;
	local Color Blue;
	local Color BrightWhite;
	local Color Gold;
	local int i;
	local int OnLineNum;
	local LVDataRecord record;
	
	BrightWhite.R = 255;
	BrightWhite.G = 255;
	BrightWhite.B = 255;
	White.R = 170;
	White.G = 170;
	White.B = 170;
	Yellow.R = 235;
	Yellow.G = 205;
	Yellow.B = 0;
	Blue.R = 102;
	Blue.G = 150;
	Blue.B = 253;
	Gold.R = 176;
	Gold.G = 153;
	Gold.B  = 121;
	
	OnLineNum = 0;
	
	record.LVDataList.Length = 4;
	
	if (GetClanTypeFromIndex(m_currentShowIndex) <= CLAN_MAIN)
	{
	}
	else
	{
		if (m_memberList[m_currentShowIndex].m_sMasterName == "")
		{
			i = getClanKnighthoodMasterInfo(m_memberList[m_currentShowIndex].m_sMasterName);
			//debug ("ClanKnighthood MasterInfo" @ i);
			record.LVDataList[0].buseTextColor = True;
			record.LVDataList[0].szData = GetSystemString(1445);
			//record.LVDataList[0].szData = m_memberList[GetClanTypeFromIndex(m_currentShowIndex)].m_sMasterName;
			//debug ("Current Index" @ GetClanTypeFromIndex(m_currentShowIndex));
			//debug ("ClanKnighthood MasterInfoName" @ m_memberList[0].m_sMasterName);
			record.LVDataList[0].TextColor = Gold;
			record.LVDataList[1].szData = "";
			record.LVDataList[2].szData = "";
			
			class'UIAPI_LISTCTRL'.static.InsertRecord( m_WindowName $ ".ClanMemberList", record );
		}
		else
		{
			i = getClanKnighthoodMasterInfo(m_memberList[m_currentShowIndex].m_sMasterName);
			//debug ("ClanKnighthood MasterInfo" @ i);
			record.LVDataList[0].buseTextColor = True;
			record.LVDataList[0].szData = m_memberList[m_currentShowIndex].m_sMasterName;
			//record.LVDataList[0].szData = m_memberList[GetClanTypeFromIndex(m_currentShowIndex)].m_sMasterName;
			//debug ("Current Index" @ GetClanTypeFromIndex(m_currentShowIndex));
			//debug ("ClanKnighthood MasterInfoName" @ m_memberList[0].m_sMasterName);
			record.LVDataList[0].TextColor = Gold;
			record.LVDataList[1].buseTextColor = True;
			record.LVDataList[1].TextColor = White;
			record.LVDataList[1].szData = string(m_memberList[0].m_array[i].level);
			record.LVDataList[2].szData = string(m_memberList[0].m_array[i].classID);		// ���� ���� ���������� ������ ���ؼ� �ִ´�
			record.LVDataList[2].szTexture = GetClassIconName(m_memberList[0].m_array[i].classID);
			
			record.LVDataList[2].nTextureWidth = 11;
			record.LVDataList[2].nTextureHeight = 11;
			
			record.LVDataList[3].nTextureWidth = 31;
			record.LVDataList[3].nTextureHeight = 11;
			record.nReserved1 = IntToInt64(0);	// for additional information
			
			if( m_memberList[0].m_array[i].id > 0 )
			{
				record.LVDataList[3].szData = "0";				// ���� ���� ���������� ������ ���ؼ� �ִ´�
				record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
				OnLineNum = OnLineNum++;
			}
			else 
			{
				record.LVDataList[3].szData = "0";
				record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
			}
			class'UIAPI_LISTCTRL'.static.InsertRecord( m_WindowName $ ".ClanMemberList", record );
		}
		i = 0;
	}
	
	for( i=0 ; i < m_memberList[idx].m_array.Length ; ++i )
	{
		record.LVDataList[0].buseTextColor = True;
		
		record.LVDataList[0].szData = m_memberList[idx].m_array[i].sName;
		if( m_memberList[idx].m_array[i].bHaveMaster == 0)
		{
			record.LVDataList[0].TextColor = White;
		}
		else
		{
			record.LVDataList[0].TextColor = Yellow;
		}
		if( m_memberList[idx].m_array[i].sName == m_myName)
		{
			record.LVDataList[0].TextColor = BrightWhite;
			record.LVDataList[1].TextColor = BrightWhite;
			if (GetClanTypeFromIndex(m_currentShowIndex) == CLAN_MAIN)
			{
				m_indexNum = i;
			}
			else
			{
				m_indexNum = i+1;
			}
		}
		record.LVDataList[1].buseTextColor = True;
		if( m_memberList[idx].m_array[i].sName == m_myName)
		{
			record.LVDataList[1].TextColor = BrightWhite;
		}
		else
		{
			record.LVDataList[1].TextColor = White;
		}
		record.LVDataList[1].szData = string(m_memberList[idx].m_array[i].level);
		record.LVDataList[2].szData = string( m_memberList[idx].m_array[i].classID );		// ���� ���� ���������� ������ ���ؼ� �ִ´�
		record.LVDataList[2].szTexture = GetClassIconName(m_memberList[idx].m_array[i].classID);
		record.LVDataList[2].nTextureWidth = 11;
		record.LVDataList[2].nTextureHeight = 11;
		record.LVDataList[3].nTextureWidth = 31;
		record.LVDataList[3].nTextureHeight = 11;
		record.nReserved1 = IntToInt64(m_memberList[idx].m_array[i].clanType);		// for additional information
	
		
		if( m_memberList[idx].m_array[i].id > 0 )
		{
			record.LVDataList[3].szData = "1";				// ���� ���� ���������� ������ ���ؼ� �ִ´�
			record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
			OnLineNum = OnLineNum++;
		}
		else 
		{
			record.LVDataList[3].szData = "2";
			record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
		}

		class'UIAPI_LISTCTRL'.static.InsertRecord( m_WindowName $ ".ClanMemberList", record );
	}
	

	if (GetClanTypeFromIndex(m_currentShowIndex) <= CLAN_MAIN)
	{
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanCurrentNum", "("$OnLineNum$"/"$m_memberList[idx].m_array.Length$")"); 
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanCurrentNum", "("$OnLineNum$"/"$m_memberList[idx].m_array.Length+1$")"); 
	}
}

function bool GetSelectedListCtrlItem(out LVDataRecord record)
{
	local int index;
	index = m_hClanMemberList.GetSelectedIndex();
	if( index >= 0 )
	{
		m_hClanMemberList.GetRec(index, record);
		return true;
	}
	return false;
}

function HandleMemberInfoUpdate( String a_Param )
{
	local ClanMemberInfo info;

	local int i;
	local int j;
	local int count;
	local ClanDrawerWnd script;
	local bool bHaveMasterChanged;
	local bool bMemberChanged;
	local int process_length;
	local int process_clanindex;
	
	bHaveMasterChanged= false;
	bMemberChanged = false;


	ParseString( a_Param, "Name", info.sName );
	ParseInt( a_Param, "Level", info.level );
	ParseInt( a_Param, "Class", info.classID );
	ParseInt( a_Param, "Gender", info.gender );
	ParseInt( a_Param, "Race", info.race );
	ParseInt( a_Param, "ID", info.ID );
	ParseInt( a_Param, "ClanType", info.clanType );
	ParseInt( a_Param, "HaveMaster", info.bHaveMaster );
	
	//debug("ClanWnd::HandleMemberInfoUpdate name " $ info.sName $ " level " $ info.level $ " classID " $ info.classID $ " gender " $ info.gender $ " race " $ info.race $ " ID " $ info.id $ " type " $ info.clanType $ " bHaveMaster " $ info.bHaveMaster );

	for( i=0 ; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
	{
		count = m_memberList[ i ].m_array.Length;
		for(j=0; j < count ; ++j)
		{
			if( m_memberList[ i ].m_array[ j ].sName == info.sName )		// match found
			{
				//debug("HandleMemberInfoUpdate match found(i,j) :" $ i $ ", " $ j );
				if( m_memberList[ i ].m_array[ j ].bHaveMaster != info.bHaveMaster )
				{
					bHaveMasterChanged = true;
					m_memberList[ i ].m_array[ j ] = info;
					//debug("������� ���� �̺�Ʈ ���ƿ���222");
				}
				
				if(m_memberList[ i ].m_array[ j ].clanType != info.clanType)	
				{
					//m_memberList[ i ].m_array[ j ].sName = "";
					//m_memberList[ i ].m_array[ j ].clanType = 0;
					//m_memberList[ i ].m_array[ j ].level = 0;
					//m_memberList[ i ].m_array[ j ].classID = 0;
					//m_memberList[ i ].m_array[ j ].gender = 0;
					//m_memberList[ i ].m_array[ j ].race = 0;
					//m_memberList[ i ].m_array[ j ].ID = 0;
					//m_memberList[ i ].m_array[ j ].bHaveMaster = 0;
					bMemberChanged = true;
					//debug("����̵� ó��");
					
					m_memberList[ i ].m_array.Remove(j, 1);
	
					
					
					process_clanindex = GetIndexFromType( info.clanType );
					process_length = m_memberList[ process_clanindex ].m_array.Length;
					m_memberList[ process_clanindex ].m_array.Insert(process_length, 1);
					//m_memberList[ process_clanindex ].m_array.Length = process_length+ 1;
					//process_length = m_memberList[ process_clanindex ].m_array.Length;
					
					m_memberList[ process_clanindex ].m_array[ process_length ].sName = info.sName;
					m_memberList[ process_clanindex ].m_array[ process_length ].clanType = info.clanType;
					m_memberList[ process_clanindex ].m_array[ process_length ].level = info.level;
					m_memberList[ process_clanindex ].m_array[ process_length ].classID = info.classID;
					m_memberList[ process_clanindex ].m_array[ process_length ].gender = info.gender;
					m_memberList[ process_clanindex ].m_array[ process_length ].race = info.race;
					m_memberList[ process_clanindex ].m_array[ process_length ].ID = info.ID;
					m_memberList[ process_clanindex ].m_array[ process_length ].bHaveMaster = info.bHaveMaster;
					
					class'UIAPI_TEXTBOX'.static.SetText("ClanDrawerWnd.Clan1_CurrentSelectedMemberGrade", "");
										
					ShowList(info.clanType);
					
					//script.SetStateAndShow("ClanMemberInfoState");
				}
				else 
				{
					m_memberList[ i ].m_array[ j ] = info;
					ShowList(info.clanType);
				}
				break;
			}
		}
		if( j < count )
			break;			// match found. early break;
	}

	
	// ��ħ �� ����� ������ ���� �־��ٸ� UI�� ������Ʈ �� ����Ѵ�
	script = ClanDrawerWnd( GetScript("ClanDrawerWnd") );

	if( bHaveMasterChanged && class'UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd.ClanMemberInfoWnd") )
	{		
		if( script.m_currentName == info.sName )
		{
			//debug("HandleMemberInfoUpdate : RequestClanMemberInfo( " $ info.sName $ " )");
			RequestClanMemberInfo( info.clanType, info.sName );
		}
		if( GetIndexFromType( info.clanType ) == m_currentShowIndex )
		{
			ShowList( info.clanType );									// renew list
		}
		ShowList(m_currentShowIndex);
	}
	
	if( bMemberChanged && class'UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd.ClanMemberInfoWnd") )
	{
		ClearList();
		ShowList( info.clanType );
		RefreshCombobox1(info.clanType );

		if( script.m_currentName == info.sName )
		{
			RequestClanMemberInfo( info.clanType, info.sName );
		}			
	}
	
	//ShowList(m_currentShowIndex);
	
}

function RefreshCombobox1( int ClanT )
{
	local int i;

	for (i=0; i<10; ++i)
	{
		if (class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i) == ClanT)
		{
			class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd", i);
			//debug("CurrentSelected:" @ i);
		}
	}
	
}

function HandleAddClanMember( String a_Param )
{
	local int count;
	local ClanMemberInfo info;
	
	ParseString( a_Param, "Name", info.sName );
	ParseInt( a_Param, "Level", info.level );
	ParseInt( a_Param, "Class", info.classID );
	ParseInt( a_Param, "Gender", info.gender );
	ParseInt( a_Param, "Race", info.race );
	ParseInt( a_Param, "ID", info.id );
	ParseInt( a_Param, "ClanType", info.clanType );

	info.bHaveMaster = 0;

	count = m_memberList[ GetIndexFromType( info.clanType ) ].m_array.Length;
	m_memberList[ GetIndexFromType( info.clanType ) ].m_array.Length = count + 1;
	m_memberList[ GetIndexFromType( info.clanType ) ].m_array[ count ] = info;
	//debug("ClanWnd::HandleAddClanMember Name: " $ info.sName $ " lv: "$ info.level $ "classID: " $ info.classID $ " id: " $ info.id $ "clanType: " $ info.clanType );

	if( GetIndexFromType( info.clanType ) == m_currentShowIndex )
		ShowList( info.clanType );									// renew list
}

function int GetIndexFromType( int type )
{
	local int i;
	i = -1;
	if(type == CLAN_MAIN)
	{
		i = 0;
	}
	else if(type == CLAN_KNIGHT1 )
	{
		i = 1;
	}
	else if(type == CLAN_KNIGHT2 )
	{
		i = 2;
	}
	else if(type == CLAN_KNIGHT3 )
	{
		i = 3;
	}
	else if(type == CLAN_KNIGHT4 )
	{
		i = 4;
	}
	else if(type == CLAN_KNIGHT5 )
	{
		i = 5;
	}
	else if(type == CLAN_KNIGHT6 )
	{
		i = 6;
	}
	else if(type == CLAN_ACADEMY )
	{
		i = 7;
	}
	return i;
}

function HandleDeleteMember( String a_Param )
{
	local int i;
	local int j;
	local int k;
	local int count;
	local string sName;

	ParseString( a_Param, "Name", sName );

	//debug("HandleDeleteMember name " $ sName );
	for( i=0 ; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
	{
		count = m_memberList[ i ].m_array.Length;
		for(j=0; j < count ; ++j)
		{
			if( m_memberList[ i ].m_array[ j ].sName == sName )		// match found
			{
				//debug("HandleDeleteMember match found(i,j) :" $ i $ ", " $ j $ " count: " $ count );
				for( k=j ; k<count-1 ; ++k )
				{
					m_memberList[ i ].m_array[ k ] = m_memberList[ i ].m_array[ k + 1 ];
					//debug("HandleDeleteMember delete array");
				}
				m_memberList[ i ].m_array.Length = count - 1;		//shrink 
				//debug("HandleDeleteMember shrink Arrary to " $ m_memberList[ i ].m_array.Length );
				break;
			}
		}
		if( j < count )
			break;			// match found. early break;
	}

	if( i == m_currentShowIndex )
		ShowList( i );									// renew list
}

function RefreshCombobox()
{
	local int i;
	local int index;
	local int newIndex;
	local int addedCount;
	//local int addedCount2;
	index = class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd");
	class'UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".ComboboxMainClanWnd");
	addedCount = -1;
	//addedCount2 = 0;
	//debug("myClanType:" @ m_myClanType);
	for( i=0 ; i < CLAN_KNIGHTHOOD_COUNT ; ++i )
	{
		if( m_memberList[i].m_sName != "" )
		{
			// ����� ���� ��������. -_-;
			//class'UIAPI_COMBOBOX'.static.AddString(m_WindowName $ ".ComboboxMainClanWnd", m_memberList[i].m_sName);
			//debug("CurrentI : " @ i );
			class'UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".ComboboxMainClanWnd", GetClanTypeNameFromIndex(GetClanTypeFromIndex(i))@"-"@m_memberList[i].m_sName, GetClanTypeFromIndex(i));
			++addedCount;
			//++addedCount2;
			
			if( i == m_currentShowIndex )
			{
				newIndex = addedCount;
			}
			//if( i == m_myClanType)
			//{
			//	m_indexNumKH = addedCount2;
			//	debug("ShowmyIndexNumChange:" @ m_indexNumKH);
			//}
			
			
			
		}
	}

	//debug("RefreshCombobox m_currentShowIndex " $ m_currentShowIndex $ " newIndex " $ newIndex $ " addedCount " $ addedCount );

	//class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd", m_indexNumKH );
	
	for (i=0; i<10; ++i)
	{
		if (class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i) == m_myClanType)
		{
			class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd", i);
			//debug("CurrentSelected:" @ i);
		}
	}
}

function HandleSubClanUpdated( String a_Param )
{
	local int id;
	local int type;
	local string sName;
	local string sMasterName;
	local ClanDrawerWnd script;

	ParseInt( a_Param, "ClanID", id );
	ParseInt( a_Param, "ClanType", type );
	ParseString( a_Param, "ClanName", sName );
	ParseString( a_Param, "MasterName", sMasterName );

	//debug("HandleSubClanCreated type " $ type $ " name " $ sName $ " masterName " $ sMasterName );
	m_memberList[ GetIndexFromType( type ) ].m_sName = sName;
	m_memberList[ GetIndexFromType( type ) ].m_sMasterName = sMasterName;
	RefreshComboBox();
	
	if( class'UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd.ClanInfoWnd") )			// ���� ���� â�� �������� �ִٸ� ������Ʈ ���ش�.
	{
		script = ClanDrawerWnd( GetScript("ClanDrawerWnd") );
		script.InitializeClanInfoWnd();
	}
}

function AskJoin()
{
	local UserInfo user;
	//local Rect rect;
	//local InviteClanPopWnd script;

	if( GetTargetInfo( user ) )
	{
		//debug("AskJoin id " $ user.nID $ " name " $ user.Name );
		if( user.nID > 0 )
		{
			//script = InviteClanPopWnd( GetScript("InviteClanPopWnd" ) );
			//rect = class'UIAPI_WINDOW'.static.GetRect("MainWnd");
			//class'UIAPI_WINDOW'.static.MoveTo("InviteClanPopWnd", rect.nX + rect.nWidth, rect.nY + rect.nHeight);
			class'UIAPI_WINDOW'.static.Showwindow("InviteClanPopWnd");
			
		}
	}
}

function HandleClanMyAuth( String a_Param )
{
	ParseInt( a_Param, "ClanMaster", m_bClanMaster );
	ParseInt( a_Param, "Join", m_bJoin );
	ParseInt( a_Param, "NickName", m_bNickName );
	ParseInt( a_Param, "ClanCrest", m_bCrest );
	ParseInt( a_Param, "War", m_bWar );
	ParseInt( a_Param, "Grade", m_bGrade );
	ParseInt( a_Param, "ManageMaster", m_bManageMaster );
	ParseInt( a_Param, "OustMember", m_bOustMember );

	resetBtnShowHide();
	//debug("HandleClanMyAuth bMaster:"$m_bClanMaster$" bJoin: "$m_bJoin$" bNickName: "$m_bNickName$" bCrest: "$m_bCrest$" bWar: "$m_bWar$" bGrade: "$m_bGrade$" bManageMaster: "$m_bManageMaster$" bOustMember: " $m_bOustMember);
}
// ����� �߰� 
function ResetOpeningVariables()
{
	m_currentactivestatus1 = false;
	m_currentactivestatus2 = false;
	m_currentactivestatus3 = false;
	m_currentactivestatus4 = false;
	m_currentactivestatus5 = false;
	m_currentactivestatus6 = false;
	m_currentactivestatus7 = false;
	m_currentactivestatus8 = false;
}

defaultproperties
{
    
}
