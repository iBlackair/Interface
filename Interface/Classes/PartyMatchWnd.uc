class PartyMatchWnd extends PartyMatchWndCommon;

//HandleList
var WindowHandle Me;
var ListCtrlHandle PartyMatchListCtrl;
var ComboBoxHandle LocationFilterComboBox;
var ComboBoxHandle LevelFilterComboBox;
var ButtonHandle PrevBtn;
var ButtonHandle NextBtn;
var ButtonHandle AutoJoinBtn;
var ButtonHandle RefreshBtn;

//Other Window
var WindowHandle PartyMatchMakeRoomWnd;
var WindowHandle PartyMatchWaitListWnd;
var WindowHandle PartyMatchOutWaitListWnd;
var EditBoxHandle PartyMatchOutWaitListWnd_MinLevel;
var EditBoxHandle PartyMatchOutWaitListWnd_MaxLevel;

//���� ����(2010.02.22 ~ 03.08) �Ϸ�
var ComboBoxHandle  JobFilterComboBox;
var EditBoxHandle   PartyMatchOutWaitListWnd_Name;
const               MAXMEMBER = 12;

//Global Variable
var int CompletelyQuitPartyMatching;
var bool bOpenStateLobby;
var int CUR_PAGE;
var int MAX_LEVEL;

//���ո�Ī
var ListCtrlHandle UnionMatchListCtrl;
var ButtonHandle UnionPrevBtn;
var ButtonHandle UnionNextBtn;
var ButtonHandle UnionRefreshBtn;
var WindowHandle UnionMatchMakeRoomWnd;
var int CUR_PAGE_UNION;

var bool IsInParty;
function InitHandle()
{
	Me = m_hOwnerWnd;
	PartyMatchListCtrl = GetListCtrlHandle( "PartyMatchWnd.PartyMatchListCtrl" );
	UnionMatchListCtrl = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
	LocationFilterComboBox = GetComboBoxHandle( "PartyMatchWnd.LocationFilterComboBox" );
	LevelFilterComboBox = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );
	PrevBtn = GetButtonHandle( "PartyMatchWnd.PrevBtn" );
	NextBtn = GetButtonHandle( "PartyMatchWnd.NextBtn" );
	AutoJoinBtn = GetButtonHandle( "PartyMatchWnd.AutoJoinBtn" );
	RefreshBtn = GetButtonHandle( "PartyMatchWnd.RefreshBtn" );
	
	//Other Window
	PartyMatchMakeRoomWnd = GetWindowHandle( "PartyMatchMakeRoomWnd" );
	PartyMatchWaitListWnd = GetWindowHandle( "PartyMatchWaitListWnd" );
	PartyMatchOutWaitListWnd = GetWindowHandle( "PartyMatchOutWaitListWnd" );
	PartyMatchOutWaitListWnd_MinLevel = GetEditBoxHandle( "PartyMatchOutWaitListWnd.MinLevel" );
	PartyMatchOutWaitListWnd_MaxLevel = GetEditBoxHandle( "PartyMatchOutWaitListWnd.MaxLevel" );
	//���� ����(2010.02.22 ~ 03.08) �Ϸ�
	JobFilterComboBox = GetComboBoxHandle( "PartyMatchOutWaitListWnd.Job" );
	PartyMatchOutWaitListWnd_Name = GetEditBoxHandle( "PartyMatchOutWaitListWnd.Name" ); 

	//���ո�Ī
	UnionPrevBtn = GetButtonHandle( "PartyMatchWnd.UnionPrevBtn" );
	UnionNextBtn = GetButtonHandle( "PartyMatchWnd.UnionNextBtn" );
	UnionRefreshBtn = GetButtonHandle( "PartyMatchWnd.UnionRefreshBtn" );
	UnionMatchMakeRoomWnd = GetWindowHandle( "UnionMatchMakeRoomWnd" );
}

function SetIsInParty(bool b){
	IsInParty = b;
}

function OnRegisterEvent()
{
	RegisterEvent( EV_PartyMatchStart );
	RegisterEvent( EV_PartyMatchList );
	RegisterEvent( EV_PartyMatchRoomStart );
	
	//���ո�Ī
	RegisterEvent( EV_ListMpccWaitingStart );
	RegisterEvent( EV_ListMpccWaitingRoomInfo );
	
	//��Ƽâ ��� �߻�
	RegisterEvent( EV_UsePartyMatchAction );
	//
	RegisterEvent( EV_Restart );
}

function OnLoad()
{
	InitHandle();
	Init();
}

function Init()
{
	CompletelyQuitPartyMatching = 0;
	bOpenStateLobby = false;
	
	CUR_PAGE = 0;
	CUR_PAGE_UNION = 0;
	MAX_LEVEL=GetMaxLevel();
	IsInParty = false;
	//�˻������� �ʱ�ġ ����
	LocationFilterComboBox.SetSelectedNum( 1 );
	LevelFilterComboBox.SetSelectedNum( 1 );
}

function OnShow()
{
	PartyMatchListCtrl.ShowScrollBar( false );
	
	//���ո�Ī�� ����Ʈ ��û(1���� ������ �Ŀ� ��Ŷ�� ������)
	UnionMatchListCtrl.DeleteAllItem();
	Me.SetTimer( 1, 1000 );
}

function OnTimer( int TimerID )
{
	if( TimerID == 1 )
	{
		RequestUnionRoomList( 1 );
		Me.KillTimer( 1 );
	}
}

//x��ư�� ������ �����츦 ������, ����ڸ�Ͽ��� ������.
function OnSendPacketWhenHiding()
{
	class'PartyMatchAPI'.static.RequestExitPartyMatchingWaitingRoom();
}

function OnHide()
{
	PartyMatchMakeRoomWnd.HideWindow();
}

function OnEvent(int a_EventID, String param)
{
	local PartyMatchMakeRoomWnd Script;
	
	switch( a_EventID )
	{
	case EV_PartyMatchStart:
		if (CompletelyQuitPartyMatching == 1)
		{
			class'PartyMatchAPI'.static.RequestExitPartyMatchingWaitingRoom();
			Me.HideWindow();
			
			Script = PartyMatchMakeRoomWnd( GetScript( "PartyMatchMakeRoomWnd" ) );
			Script.OnCancelButtonClick();
			
			CompletelyQuitPartyMatching = 0;
			SetWaitListWnd(false);
		}
		else 
		{
			//����ڸ���Ʈ ������Ʈ
			UpdateWaitListWnd();
			
			if (Me.IsShowWindow() == false)
			{	
				Me.ShowWindow();
				PartyMatchListCtrl.ShowScrollBar( false );
			}		
			Me.SetFocus();
		}
		break;
	case EV_PartyMatchList:
		HandlePartyMatchList(param);
		break;
	case EV_PartyMatchRoomStart:
		Me.HideWindow();
		break;
	
	//���ո�Ī
	case EV_ListMpccWaitingStart:
		HandleListMpccWaitingStart( param );
		break;
	case EV_ListMpccWaitingRoomInfo:
		HandleListMpccWaitingRoomInfo( param );
		break;
	case EV_UsePartyMatchAction:
		HandlePartyToggle();		
		break;
	case EV_Restart:
		SetIsInParty(false);
		//���� ����(2010.03.31) �Ϸ�
		bOpenStateLobby = false;
		break;
	}
}

function HandlePartyToggle(){//��Ƽâ�� ����ݴ� ��� Ŀ�ǵ�. ������. ����. �׼ǻ��. /��Ƽ��Ī �Է½� �� �Լ��� ȣ��ȴ�. jdh84
							
	local WindowHandle TaskWnd;
	local WindowHandle TaskWnd2;
	local PartyMatchRoomWnd p2_script;

	TaskWnd=GetWindowHandle( "PartyMatchWnd" );
	TaskWnd2=GetWindowHandle( "PartyMatchRoomWnd" );
	p2_script = PartyMatchRoomWnd( GetScript( "PartyMatchRoomWnd" ) );
	
	if (TaskWnd.IsShowWindow()) //��Ƽ��ġ â�� �����ִٸ�
	{
		ClosePartyMatchingWnd(); //�ݴ´�
	}
	else if(TaskWnd2.IsShowWindow()) //��Ƽ���� �����ִٸ�
	{
		TaskWnd2.HideWindow(); //�ݴ´�
		p2_script.OnSendPacketWhenHiding();
	}
	else
	{
		RequestPartyRoomListLocal( 1 ); //������ ������쿡�� ������ ��û�Ѵ�
	}
}



function ClosePartyMatchingWnd()//��Ƽâ�� 
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;
	p_script = PartyMatchWnd( GetScript( "PartyMatchWnd" ) );

	if(CREATE_ON_DEMAND==0)
		TaskWnd = GetHandle("PartyMatchWnd");
	else
		TaskWnd = GetWindowHandle("PartyMatchWnd");

	TaskWnd.HideWindow();
	p_script.OnSendPacketWhenHiding();
}

//5�ʰ� ������ ��ư���� Disable���°� Ǯ����
function OnButtonTimer( bool bExpired )
{
	if (bExpired)
	{
		PrevBtn.EnableWindow();
		NextBtn.EnableWindow();
		AutoJoinBtn.EnableWindow();
		RefreshBtn.EnableWindow();
	}
	else
	{
		PrevBtn.DisableWindow();
		NextBtn.DisableWindow();
		AutoJoinBtn.DisableWindow();
		RefreshBtn.DisableWindow();
	}
}

function HandlePartyMatchList(string param)
{
	local int Count;
	local int i;
	local LVDataRecord Record;
	local int Number;
	local String PartyRoomName;
	local String PartyLeader;
	local int ZoneID;
	local int MinLevel;
	local int MaxLevel;
	local int MinMemberCnt;
	local int MaxMemberCnt;

	//���� ����(2010.02.22 ~ 03.08) �Ϸ�
	local int j;
	local int MemberCnt;
	local int MemberClassID;
	local string MemberName;
	local LVData data1;


	PartyMatchListCtrl.DeleteAllItem();
	//���� ����(2010.02.22 ~ 03.08) �Ϸ�
	Record.LVDataList.length = 7 + ( MAXMEMBER / 2 );

	ParseInt(param, "PageNum", CUR_PAGE);
	ParseInt(param, "RoomCount", Count);
	for( i = 0; i < Count; ++i )
	{
		ParseInt(param, "RoomNum_" $ i, Number);
		ParseString(param, "Leader_" $ i, PartyLeader);
		ParseInt(param, "ZoneID_" $ i, ZoneID);	
		ParseInt(param, "MinLevel_" $ i, MinLevel);
		ParseInt(param, "MaxLevel_" $ i, MaxLevel);
		ParseInt(param, "CurMember_" $ i, MinMemberCnt);
		ParseInt(param, "MaxMember_" $ i, MaxMemberCnt);
		ParseString(param, "RoomName_" $ i, PartyRoomName);
		ParseInt(param, "MemberCnt_" $ i, MemberCnt);

		Record.LVDataList[0].szData = String( Number );
		Record.LVDataList[1].szData = PartyLeader;
		Record.LVDataList[2].szData = PartyRoomName;
		Record.LVDataList[3].szData = GetZoneNameWithZoneID( ZoneID );
		Record.LVDataList[4].szData = MinLevel $ "-" $ MaxLevel;
		Record.LVDataList[5].szData = MinMemberCnt $ "/" $ MaxMemberCnt;
		Record.LVDataList[6].szData = string( MemberCnt );

		//���� ����(2010.02.22 ~ 03.08) �Ϸ�
		for( j = 0 ; j < MemberCnt ; ++j )
		{
			ParseString(param, "MemberName_" $ i $ "_" $ j, MemberName );			
			ParseInt(param, "MemberClassID_" $ i $ "_" $ j, MemberClassID );

			//debug( "[" $ i $ "]" $ "[" $ j $ "]==" $ MemberName );
			//debug( "[" $ i $ "]" $ "[" $ j $ "]==" $ MemberClassID );			
			
			data1.nReserved1 = MemberClassID;
			data1.szData = MemberName;

			Record.LVDataList[ 7 + j ] = data1;
		}

		PartyMatchListCtrl.InsertRecord( Record );
	}
}

function OnClickButton( string a_strButtonName )
{
	switch( a_strButtonName )
	{
	case "RefreshBtn":
		OnRefreshBtnClick();
		break;
	case "PrevBtn":
		OnPrevBtnClick();
		break;
	case "NextBtn":
		OnNextBtnClick();
		break;
	case "MakeRoomBtn":
		OnMakeRoomBtnClick();
		break;
	case "AutoJoinBtn":
		OnAutoJoinBtnClick();
		break;
	case "WaitListButton":
		OnWaitListButton();
		break;
	//���ո�Ī
	case "UnionRefreshBtn":
		OnUnionRefreshBtn();
		break;
	case "UnionPrevBtn":
		OnUnionPrevBtn();
		break;
	case "UnionNextBtn":
		OnUnionNextBtn();
		break;
	}
}

function OnWaitListButton()
{
	ToggleWaitListWnd();
	UpdateWaitListWnd();
}

function OnRefreshBtnClick()
{
	RequestPartyRoomListLocal( 1 );
}
 
function OnPrevBtnClick()
{
	local int WantedPageNum;

	if( 1 >= CUR_PAGE )
		WantedPageNum = 1;
	else
		WantedPageNum = CUR_PAGE - 1;

	RequestPartyRoomListLocal( WantedPageNum );
}

function OnNextBtnClick()
{
	RequestPartyRoomListLocal( CUR_PAGE + 1 );	
}

function RequestPartyRoomListLocal( int a_Page )
{
	class'PartyMatchAPI'.static.RequestPartyRoomList( a_Page, GetLocationFilter(), GetLevelFilter() );
}

function OnMakeRoomBtnClick()
{
	local PartyMatchMakeRoomWnd Script;
	local UserInfo PlayerInfo;

	Script = PartyMatchMakeRoomWnd( GetScript( "PartyMatchMakeRoomWnd" ) );
	if( Script != None )
	{
		Script.SetRoomNumber( 0 );
		Script.SetTitle( GetSystemMessage( 1398 ) );
		Script.SetMaxPartyMemberCount( 12 );
		if( GetPlayerInfo( PlayerInfo ) )
		{
			if( PlayerInfo.nLevel - 5 > 0 )
				Script.SetMinLevel( PlayerInfo.nLevel - 5 );
			else
				Script.SetMinLevel( 1 );

			if( PlayerInfo.nLevel + 5 <= MAX_LEVEL )
				Script.SetMaxLevel( PlayerInfo.nLevel + 5 );
			else
				Script.SetMaxLevel( MAX_LEVEL );
		}		
	}
	script.InviteState = 0;
	
	PartyMatchMakeRoomWnd.ShowWindow();
	PartyMatchMakeRoomWnd.SetFocus();
}

function OnDBClickListCtrlRecord( String a_ListCtrlName )
{
	local int SelectedRecordIndex;
	local LVDataRecord Record;	

	if( a_ListCtrlName == "PartyMatchListCtrl" )
	{
		SelectedRecordIndex = PartyMatchListCtrl.GetSelectedIndex();
		PartyMatchListCtrl.GetRec(SelectedRecordIndex, Record);
		class'PartyMatchAPI'.static.RequestJoinPartyRoom( int( Record.LVDataList[0].szData ) );	
	}
	else if( a_ListCtrlName == "UnionMatchListCtrl" )
	{
		SelectedRecordIndex = UnionMatchListCtrl.GetSelectedIndex();
		UnionMatchListCtrl.GetRec(SelectedRecordIndex, Record);
		class'PartyMatchAPI'.static.RequestJoinMpccRoom( int( Record.LVDataList[0].szData ), 0 );	
	}
	return;
}

function OnAutoJoinBtnClick()
{
	class'PartyMatchAPI'.static.RequestJoinPartyRoomAuto( CUR_PAGE, GetLocationFilter(), GetLevelFilter() );
}

function int GetLocationFilter()
{
	return LocationFilterComboBox.GetReserved( LocationFilterComboBox.GetSelectedNum() );
}

function int GetLevelFilter()
{
	return LevelFilterComboBox.GetSelectedNum();
}

/////////////////////////////////////////////////////////////////////////////////
////// ����� ����Ʈ ���� ���� �Լ�
////// WaitListWnd�� 2���� �ִµ�, Show/Hide�� ������ �Ѱ����� �����ϱ� ����
/////////////////////////////////////////////////////////////////////////////////

//����ڸ���Ʈ Flag����
function SetWaitListWnd(bool bShow)
{
	bOpenStateLobby = bShow;
}

//����ڸ���Ʈ ǥ��
function ShowHideWaitListWnd()
{
	
	if (bOpenStateLobby)
	{
	
		PartyMatchOutWaitListWnd.ShowWindow();
		PartyMatchWaitListWnd.ShowWindow();
	}
	else 
	{
	
		PartyMatchOutWaitListWnd.HideWindow();
		PartyMatchWaitListWnd.HideWindow();
	}
}

//����ڸ���Ʈ ������Ʈ
function UpdateWaitListWnd()
{
	local int MinLevel;
	local int MaxLevel;
	local string strName;

	if (IsShowWaitListWnd())
	{
		MinLevel = int(PartyMatchOutWaitListWnd_MinLevel.GetString());
		MaxLevel = int(PartyMatchOutWaitListWnd_MaxLevel.GetString());
		
		//���� ����(2010.02.22 ~ 03.08) �Ϸ�
		strName = PartyMatchOutWaitListWnd_Name.GetString();
		RequestPartyMatchWaitList( 1, MinLevel, MaxLevel, JobFilterComboBox.GetSelectedNum(), strName );
	}	
}

//����ڸ���Ʈ ���
function ToggleWaitListWnd()
{
	bOpenStateLobby = !bOpenStateLobby;	
	ShowHideWaitListWnd();
}

function bool IsShowWaitListWnd()
{
	return bOpenStateLobby;
}

////////////////////////////////////////////////////
// ���ո�Ī 2009.3.17 ttmayrin /////////////////////
////////////////////////////////////////////////////
function HandleListMpccWaitingStart( string param )
{
	local int listCount;
	
	ParseInt(param, "Page", CUR_PAGE_UNION);
	ParseInt(param, "listCount", listCount);
	
	UnionMatchListCtrl.DeleteAllItem();
	
	if( CUR_PAGE_UNION > 1 )
		UnionPrevBtn.EnableWindow();
	if( listCount > 0 )
		UnionNextBtn.EnableWindow();
}
function HandleListMpccWaitingRoomInfo( string param )
{
	local LVDataRecord Record;
	local int RoomNum;
	local String Title;
	local String MasterName;
	local int MinLevelLimit;
	local int MaxLevelLimit;
	local int CurrentJoinMemberCnt;
	local int MaxMemberLimit;
		
	Record.LVDataList.length = 5;
	ParseInt(param, "RoomNum", RoomNum);
	ParseString(param, "Title", Title);
	ParseString(param, "MasterName", MasterName);
	ParseInt(param, "MinLevelLimit", MinLevelLimit);
	ParseInt(param, "MaxLevelLimit", MaxLevelLimit);
	ParseInt(param, "CurrentJoinMemberCnt", CurrentJoinMemberCnt);
	ParseInt(param, "MaxMemberLimit", MaxMemberLimit);
	
	Record.LVDataList[0].szData = String( RoomNum );
	Record.LVDataList[1].szData = Title;
	Record.LVDataList[2].szData = MasterName;
	Record.LVDataList[3].szData = MinLevelLimit $ "-" $ MaxLevelLimit;
	Record.LVDataList[4].szData = CurrentJoinMemberCnt $ "/" $ MaxMemberLimit;

	UnionMatchListCtrl.InsertRecord( Record );
}

function OnUnionRefreshBtn()
{
	RequestUnionRoomList( 1 );
}
 
function OnUnionPrevBtn()
{
	local int WantedPageNum;

	if( 1 >= CUR_PAGE_UNION )
		WantedPageNum = 1;
	else
		WantedPageNum = CUR_PAGE_UNION - 1;

	RequestUnionRoomList( WantedPageNum );
}

function OnUnionNextBtn()
{
	RequestUnionRoomList( CUR_PAGE_UNION + 1 );	
}

function RequestUnionRoomList( int a_Page )
{
	UnionPrevBtn.DisableWindow();
	UnionNextBtn.DisableWindow();
	class'PartyMatchAPI'.static.RequestListMpccWaiting( a_Page, GetLocationFilter(), GetLevelFilter() );
}
defaultproperties
{
}
