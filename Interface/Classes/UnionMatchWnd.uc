class UnionMatchWnd extends PartyMatchWndCommon;

var WindowHandle Me;
var ListCtrlHandle lstMember;
var TextBoxHandle lblNum;
var TextBoxHandle txtNum;
var TextBoxHandle lblTitle;
var TextBoxHandle txtTitle;
var TextBoxHandle lblLocation;
var TextBoxHandle txtLocation;
var TextBoxHandle lblMethod;
var TextBoxHandle txtMethod;
var TextBoxHandle lblMemberCount;
var TextBoxHandle txtMemberCount;
var TextBoxHandle lblLevelLimit;
var TextBoxHandle txtLevelLimit;
var TextListBoxHandle tlstChat;
var EditBoxHandle edChat;
var ButtonHandle btnRoomInfo;
var ButtonHandle btnUnionInfo;
var ButtonHandle btnBan;
var ButtonHandle btnInviteParty;
var ButtonHandle btnInviteUnion;
var ButtonHandle btnExit;
var TextureHandle txListTitleBg;
var TextureHandle txTitleBg;
var TextureHandle txListBg;
var TextureHandle txChatBg;
var TextBoxHandle lblListTitle;

//Ohter Window
var WindowHandle UnionMatchDrawerWnd;
var WindowHandle UnionMatchMakeRoomWnd;
var WindowHandle PartyMatchWnd;

//Global Constant
const ROOMMASTER = 1;	//���� ������
const UNIONLEADER = 3;	//���� ������
const UNIONPARTY = 4;	//���� ��Ƽ��
const WAITPARTY = 5;	//�Ϲ� ��Ƽ��(���� �̰�����)
const WAITNORMAL = 6;	//�Ϲ� �����(���� �̰�����)

//Global Variable
var string ROOM_NAME;
var int ROOM_TYPE;
var int ROOM_NUM;
var int ROOM_MINLEVEL;
var int ROOM_MAXLEVEL;
var int ROOM_ROUTING;

var int MYID;
var int MYTYPE;
var int CURMEMBER_COUNT;
var int MAXMEMBER_COUNT;

var bool I_REQUEST_EXIT;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_MpccRoomInfo );
	RegisterEvent( EV_DismissMpccRoom );
	RegisterEvent( EV_ManageMpccRoomMember );
	RegisterEvent( EV_MpccRoomMemberStart );
	RegisterEvent( EV_MpccRoomMemberInfo );
	RegisterEvent( EV_MpccRoomChatMessage );
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "UnionMatchWnd" );
	lstMember = GetListCtrlHandle( "UnionMatchWnd.lstMember" );
	lblNum = GetTextBoxHandle( "UnionMatchWnd.lblNum" );
	txtNum = GetTextBoxHandle( "UnionMatchWnd.txtNum" );
	lblTitle = GetTextBoxHandle( "UnionMatchWnd.lblTitle" );
	txtTitle = GetTextBoxHandle( "UnionMatchWnd.txtTitle" );
	lblLocation = GetTextBoxHandle( "UnionMatchWnd.lblLocation" );
	txtLocation = GetTextBoxHandle( "UnionMatchWnd.txtLocation" );
	lblMethod = GetTextBoxHandle( "UnionMatchWnd.lblMethod" );
	txtMethod = GetTextBoxHandle( "UnionMatchWnd.txtMethod" );
	lblMemberCount = GetTextBoxHandle( "UnionMatchWnd.lblMemberCount" );
	txtMemberCount = GetTextBoxHandle( "UnionMatchWnd.txtMemberCount" );
	lblLevelLimit = GetTextBoxHandle( "UnionMatchWnd.lblLevelLimit" );
	txtLevelLimit = GetTextBoxHandle( "UnionMatchWnd.txtLevelLimit" );
	tlstChat = GetTextListBoxHandle( "UnionMatchWnd.tlstChat" );
	edChat = GetEditBoxHandle( "UnionMatchWnd.edChat" );
	btnRoomInfo = GetButtonHandle( "UnionMatchWnd.btnRoomInfo" );
	btnUnionInfo = GetButtonHandle( "UnionMatchWnd.btnUnionInfo" );
	btnBan = GetButtonHandle( "UnionMatchWnd.btnBan" );
	btnInviteParty = GetButtonHandle( "UnionMatchWnd.btnInviteParty" );
	btnInviteUnion = GetButtonHandle( "UnionMatchWnd.btnInviteUnion" );
	btnExit = GetButtonHandle( "UnionMatchWnd.btnExit" );
	txListTitleBg = GetTextureHandle( "UnionMatchWnd.txListTitleBg" );
	txTitleBg = GetTextureHandle( "UnionMatchWnd.txTitleBg" );
	txListBg = GetTextureHandle( "UnionMatchWnd.txListBg" );
	txChatBg = GetTextureHandle( "UnionMatchWnd.txChatBg" );
	lblListTitle = GetTextBoxHandle( "UnionMatchWnd.lblListTitle" );
	
	//Other Window
	UnionMatchDrawerWnd = GetWindowHandle( "UnionMatchDrawerWnd" );
	UnionMatchMakeRoomWnd = GetWindowHandle( "UnionMatchMakeRoomWnd" );
	PartyMatchWnd = GetWindowHandle( "PartyMatchWnd" );
}

function Load()
{
	CURMEMBER_COUNT = 0;
	I_REQUEST_EXIT = false;
}

function OnEvent(int EventID, String param)
{
	switch( EventID )
	{
	case EV_MpccRoomInfo:
		HandleMpccRoomInfo(param);
		break;
	case EV_DismissMpccRoom:
		HandleDismissMpccRoom(param);
		break;
	case EV_ManageMpccRoomMember:
		HandleManageMpccRoomMember(param);
		break;
	case EV_MpccRoomMemberStart:
		HandleMpccRoomMemberStart(param);
		break;
	case EV_MpccRoomMemberInfo:
		HandleMpccRoomMemberInfo(param);
		break;
	case EV_MpccRoomChatMessage:
		HandleMpccRoomChatMessage(param);
		break;
	case EV_DialogOK:
		if( DialogIsMine() )
		{
			//���������ڰ� ���ո�Ī���� ������.
			if( DialogGetID() == 1 )
			{
				class'PartyMatchAPI'.static.RequestDismissMpccRoom();	//���ո�Ī �ػ�!
				Me.HideWindow();
			}
		}
		break;
		
	}	
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnRoomInfo":
		OnbtnRoomInfoClick();
		break;
	case "btnUnionInfo":
		OnbtnUnionInfoClick();
		break;
	case "btnBan":
		OnbtnBanClick();
		break;
	case "btnInviteParty":
		OnbtnInvitePartyClick();
		break;
	case "btnInviteUnion":
		OnbtnInviteUnionClick();
		break;
	case "btnExit":
		OnbtnExitClick();
		break;
	}
}

//UnionMatchDrawerWnd�� �������� ������, ����
function OnShow()
{
	if( UnionMatchDrawerWnd.IsShowWindow() )
		class'PartyMatchAPI'.static.RequestMpccPartymasterList();
}

//ä�ø޼��� ����
function OnCompleteEditBox( String strID )
{
	local String ChatMsg;

	if( strID == "edChat" )
	{
		ChatMsg = edChat.GetString();
		ProcessPartyMatchChatMessage(CHAT_MPCC_ROOM, ChatMsg );
		edChat.SetString( "" );
	}
}

//[�漳��] ��ư
function OnbtnRoomInfoClick()
{
	local UnionMatchMakeRoomWnd Script;

	Script = UnionMatchMakeRoomWnd( GetScript( "UnionMatchMakeRoomWnd" ) );
	if( Script != None )
	{
		Script.SetMakeType( UNION_MAKEROOM_EDIT );
		Script.SetRoomNum( ROOM_NUM );
		Script.SetTitle( ROOM_NAME );
		Script.SetMaxMemberCount( MAXMEMBER_COUNT );
		Script.SetMinLevel( ROOM_MINLEVEL );
		Script.SetMaxLevel( ROOM_MAXLEVEL );
		Script.SetRoomRouting( ROOM_ROUTING );
	}

	UnionMatchMakeRoomWnd.ShowWindow();
	UnionMatchMakeRoomWnd.SetFocus();
}

//[��������] ��ư
function OnbtnUnionInfoClick()
{
	if( !UnionMatchDrawerWnd.IsShowWindow() )
	{
		UnionMatchDrawerWnd.ShowWindow();
		class'PartyMatchAPI'.static.RequestMpccPartymasterList();
	}
	else
	{
		UnionMatchDrawerWnd.HideWindow();
	}
}

//[�����߹�] ��ư
function OnbtnBanClick()
{
	local int idx;
	local LVDataRecord Record;
	
	idx = lstMember.GetSelectedIndex();
	if( idx < 0 )
		return;
	
	lstMember.GetRec( idx, Record );
	class'PartyMatchAPI'.static.RequestOustFromMpccRoom( Record.LVDataList[0].nReserved1 );
}

//[��Ƽ�ʴ�] ��ư
function OnbtnInvitePartyClick()
{
	local int idx;
	local LVDataRecord Record;
	
	idx = lstMember.GetSelectedIndex();
	if( idx < 0 )
		return;
	
	lstMember.GetRec( idx, Record );
	if( Record.LVDataList[4].nReserved1 == WAITNORMAL )
		RequestInviteParty( Record.LVDataList[0].szData );
}

//[�����ʴ�] ��ư
function OnbtnInviteUnionClick()
{
	local int idx;
	local LVDataRecord Record;
	
	idx = lstMember.GetSelectedIndex();
	if( idx < 0 )
		return;
	
	lstMember.GetRec( idx, Record );
	if( Record.LVDataList[4].nReserved1 == WAITPARTY )
		RequestInviteMpcc( Record.LVDataList[0].szData );
}

//[�泪����] ��ư
function OnbtnExitClick()
{
	
	switch( MYTYPE )
	{
	//���������� -> â�� ������ ���ո�Ī���� �ػ���� ����Ѵ�.
	case ROOMMASTER:
	case UNIONLEADER:
		DialogShow(DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 2993 ) );
		DialogSetID( 1 );
		break;
	//������Ƽ�� -> �׳� â�� ������.
	case UNIONPARTY:
		Me.HideWindow();
		break;
	//�Ϲ���Ƽ��,����� -> ������ ��Ŷ�� ������.
	case WAITPARTY:
	case WAITNORMAL:
		class'PartyMatchAPI'.static.RequestWithdrawMpccRoom();
		I_REQUEST_EXIT = true;
		break;
	}
}

//���ո�Ī �� ����
function HandleMpccRoomInfo(string param)
{
	local int Location;
	local Rect rectWnd;
	
	ParseInt( param, "RoomNum", ROOM_NUM );
	ParseInt( param, "MaxMemberLimit", MAXMEMBER_COUNT );
	ParseInt( param, "MinLevelLimit", ROOM_MINLEVEL );
	ParseInt( param, "MaxLevelLimit", ROOM_MAXLEVEL );
	ParseInt( param, "PartyRouting", ROOM_ROUTING );
	ParseInt( param, "Location", Location );
	ParseString( param, "Title", ROOM_NAME );
	
	//��Ƽ��Īâ�� ������ Hide�ϰ�, �� ��ġ�� ���ո�Īâ�� �����ش�.
	if (PartyMatchWnd.IsShowWindow())
		PartyMatchWnd.HideWindow();
	rectWnd = PartyMatchWnd.GetRect();
	Me.MoveTo(rectWnd.nX, rectWnd.nY);
	Me.ShowWindow();
	Me.SetFocus();
	
	txtNum.SetText( String( ROOM_NUM ) );
	txtTitle.SetText( ROOM_NAME );
	txtLocation.SetText( GetZoneNameWithZoneID( Location ) );
	txtMethod.SetText( GetLootingMethodName( ROOM_ROUTING ) );
	txtLevelLimit.SetText( string( ROOM_MINLEVEL ) $ "-" $ ROOM_MAXLEVEL );
	tlstChat.Clear();
}

//��ä�� �޼��� ó��
function HandleMpccRoomChatMessage( string param )
{
	local Color ChatColor;
	local String ChatMessage;
	local int tmpType;
	
	ParseInt( param, "SayType", tmpType );
	ParseString( param, "Msg", ChatMessage );
	ChatColor=GetChatColorByType(tmpType);
	
	tlstChat.AddString( ChatMessage, ChatColor );
	
	NotifyMe();
}

//���ո�Ī�� ������
function HandleDismissMpccRoom( string param )
{
	local Rect rectWnd;
	
	if( Me.IsShowWindow() )
	{
		Me.HideWindow();
		rectWnd= Me.GetRect();
		PartyMatchWnd.MoveTo( rectWnd.nX, rectWnd.nY );
	}
	
	//�Ϲ���Ƽ��,����� -> ���� �����ٰ� ��ư�� ������ ��, ��Ƽ��Īâ�� �����ش�.
	if( I_REQUEST_EXIT == false )
		return;
		
	switch( MYTYPE )
	{
	case WAITPARTY:
	case WAITNORMAL:
		PartyMatchWnd.ShowWindow();
		PartyMatchWnd.SetFocus();
		break;
	}
	
	I_REQUEST_EXIT = false;
}

//���ո�Ī�� ����Ʈ �ޱ� ����~
function HandleMpccRoomMemberStart( string param )
{
	local Rect rectWnd;
	local UserInfo MyInfo;
	
	//Clear
	MYID = 0;
	MYTYPE = 0;
	if( GetPlayerInfo( MyInfo ) )
		MYID = MyInfo.nID;
	CURMEMBER_COUNT = 0;
	lstMember.DeleteAllItem();
	
	ParseInt( param,"MyPartyRoomStatus", ROOM_TYPE) ;
	UpdateInfoButton();
	UpdateRelationButton();

	//���ո�Īâ ����	
	if( !Me.IsShowWindow() )
	{
		rectWnd= PartyMatchWnd.GetRect();
		Me.MoveTo( rectWnd.nX, rectWnd.nY );
		Me.ShowWindow();
		Me.SetFocus();
	}
	else
		NotifyMe();
}

//���ո�Ī�� �ο� ����Ʈ
function HandleMpccRoomMemberInfo( string param )
{
	local int ID;
	local string Name;
	local int Level;
	local int ClassID;
	local int Location;
	local int partyRoomStatus;
	
	ParseInt( param, "ID", ID );
	ParseString( param,"Name", Name );
	ParseInt( param,"Level", Level );
	ParseInt( param, "ClassID", ClassID );
	ParseInt( param, "Location", Location );
	ParseInt( param, "partyRoomStatus", partyRoomStatus );
		
	AddMember( ID, Name, ClassID, Level, Location, partyRoomStatus );
}

//���ո�Ī�� �ο� ���� ����
function HandleManageMpccRoomMember( string param )
{
	local int Type;
	local int ID;
	local string Name;
	local int Level;
	local int ClassID;
	local int Location;
	local int partyRoomStatus;
	
	ParseInt( param, "Type", Type );
	ParseInt( param,"ID", ID );
	
	switch(Type)
	{
	//Add
	case 0:
		ParseString( param,"Name", Name );
		ParseInt( param,"Level", Level );
		ParseInt( param, "ClassID", ClassID );
		ParseInt( param, "Location", Location );
		ParseInt( param, "partyRoomStatus", partyRoomStatus );
		AddMember( ID, Name, ClassID, Level, Location, partyRoomStatus );
		break;
	//Modify
	case 1:
		ParseString(param,"Name",  Name);
		ParseInt( param,"Level", Level);
		ParseInt( param, "ClassID", ClassID );
		ParseInt( param, "Location", Location);
		ParseInt( param, "partyRoomStatus", partyRoomStatus);
		ModifyMember( ID, Name, ClassID, Level, Location, partyRoomStatus );
		break;
	//Delete
	case 2:
		RemoveMember( ID );
		break;
	}
	
	NotifyMe();
}

//���� �ο��� ����
function UpdateMemberCount()
{
	txtMemberCount.SetText( string( CURMEMBER_COUNT ) $ "/" $ MAXMEMBER_COUNT );
}

//ȭ�� ��ư ����
function UpdateInfoButton()
{
	switch( ROOM_TYPE )
	{
	case ROOMMASTER:
	case UNIONLEADER:
		btnRoomInfo.EnableWindow();
		break;
	case UNIONPARTY:
	case WAITNORMAL:
	case WAITPARTY:
		btnRoomInfo.DisableWindow();
		break;
	}
}
function UpdateRelationButton()
{
	local int idx;
	local LVDataRecord Record;
//	local string Name;
	
	btnBan.DisableWindow();
	btnInviteParty.DisableWindow();
	btnInviteUnion.DisableWindow();
	
	if( ROOM_TYPE == WAITNORMAL )
		return;
	
	idx = lstMember.GetSelectedIndex();
	if( idx < 0 )
		return;
	
	lstMember.GetRec( idx, Record );
	
	if( Record.LVDataList[4].nReserved1 == WAITPARTY )
	{
		if( IsMaster() )
		{
			btnBan.EnableWindow();
			btnInviteUnion.EnableWindow();
		}
	}
	else if( Record.LVDataList[4].nReserved1 == WAITNORMAL )
	{
		if( IsMaster() )
		{
			btnBan.EnableWindow();
		}
		btnInviteParty.EnableWindow();
	}
}

//�����������ΰ�?
function bool IsMaster()
{
	if( ROOM_TYPE == UNIONLEADER || ROOM_TYPE == ROOMMASTER )
		return true;
	return false;
}

//���ڰŸ���
function NotifyMe()
{
	if( Me.IsMinimizedWindow() )
		Me.NotifyAlarm();	
}

//����Ʈ�� �ο� �߰�
function AddMember( int a_ID, string a_Name, int a_ClassID, int a_Level, int a_Location, int a_partyRoomStatus )
{
	local int idx;
	local LVDataRecord Record;
	
	//Already exist
	idx = FindMember( a_ID );
	if( idx > -1 )
		return;

	Record = MakeRecord( a_ID, a_Name, a_ClassID, a_Level, a_Location, a_partyRoomStatus );
	lstMember.InsertRecord(Record );
	
	CURMEMBER_COUNT++;
	UpdateMemberCount();
	
	if( a_ID == MYID )
		MYTYPE = a_partyRoomStatus;
}

//����Ʈ���� �ο� ����
function RemoveMember( int a_ID )
{
	local int idx;
	
	idx = FindMember( a_ID );
	if( idx < 0 )
		return;
		
	lstMember.DeleteRecord( idx );
	
	CURMEMBER_COUNT--;
	UpdateMemberCount();
	UpdateRelationButton();
}

//����Ʈ���� �ο����� ����
function ModifyMember( int a_ID, string a_Name, int a_ClassID, int a_Level, int a_Location, int a_partyRoomStatus )
{
	local int idx;
	local LVDataRecord Record;
	
	idx = FindMember( a_ID );
	if( idx < 0 )
		return;
		
	Record = MakeRecord( a_ID, a_Name, a_ClassID, a_Level, a_Location, a_partyRoomStatus );
	lstMember.ModifyRecord( idx, Record );
	
	if( a_ID == MYID )
		MYTYPE = a_partyRoomStatus;
	
	UpdateRelationButton();
}

//����Ʈ���� ���ID�� ����Ʈ�� Index�� ã��
function int FindMember( int a_ID )
{
	local int i;
	local int RecordCount;
	local LVDataRecord Record;

	RecordCount = lstMember.GetRecordCount();
	for( i=0; i<RecordCount; i++ )
	{
		lstMember.GetRec( i, Record );
		if( Record.LVDataList[0].nReserved1 == a_ID )
			return i;
	}
	return -1;
}

//���� ������ ����Ʈ�� ���ڵ带 ����.
function LVDataRecord MakeRecord( int a_ID, string a_Name, int a_ClassID, int a_Level, int a_Location, int a_partyRoomStatus )
{
	local LVDataRecord Record;
	
	Record.LVDataList.length = 5;
	Record.LVDataList[0].szData = a_Name;
	Record.LVDataList[0].nReserved1 = a_ID;
	Record.LVDataList[1].szData = String( a_ClassID );
	Record.LVDataList[1].szTexture = GetClassIconName( a_ClassID );
	Record.LVDataList[1].nTextureWidth = 11;
	Record.LVDataList[1].nTextureHeight = 11;
	Record.LVDataList[2].szData = GetAmbiguousLevelString( a_Level, true );
	Record.LVDataList[3].szData = GetZoneNameWithZoneID( a_Location );
	switch( a_partyRoomStatus )
	{
		case ROOMMASTER:
		case UNIONLEADER:
			//����������
			Record.LVDataList[4].szData = GetSystemString( 2217 );
			break;
		case UNIONPARTY:
			//������Ƽ��
			Record.LVDataList[4].szData = GetSystemString( 2218 );
			break;
		case WAITPARTY:
			//�Ϲ���Ƽ��
			Record.LVDataList[4].szData = GetSystemString( 2219 );
			break;
		case WAITNORMAL:
			//�Ϲݴ����
			Record.LVDataList[4].szData = GetSystemString( 2220 );
			break;
	}	
	Record.LVDataList[4].nReserved1 = a_partyRoomStatus;
	
	return Record;
}

//���� ����� Ŭ������ ��, ��ư ����
function OnClickListCtrlRecord( string ID )
{
	if( ID == "lstMember" )
		UpdateRelationButton();
}
defaultproperties
{
}
