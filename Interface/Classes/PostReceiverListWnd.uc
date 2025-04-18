class PostReceiverListWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle Description;
var TextureHandle DescriptionGroupBox;
var TextBoxHandle ListCount;
var TabHandle TabCtrl;
var TextureHandle ListGroupBox;
var TextureHandle TabLineTop;
var TextureHandle tabBg;
var WindowHandle PostReceiverListWnd_Friends;
var ListCtrlHandle FriendsList;
var TextureHandle FriendsListDeco;
var WindowHandle PostReceiverListWnd_Clan;
var ListCtrlHandle ClanList;
var TextureHandle ClanListDeco;
var WindowHandle PostReceiverListWnd_Add;
var ListCtrlHandle AddList;
var ButtonHandle Btn_Add;
var ButtonHandle Btn_Del;
var TextureHandle AddListGroupBoxLine;
var TextureHandle AddListDeco;
var ButtonHandle CloseButton;

var WindowHandle    PostReceiverListAddWnd;

var int m_selectedTab;

var string countFriend;
var string countPledge;
var string countPostFriend;
var string selectFriend;

var int NumPostFriend;

var bool bPostFriendSelect;


//���̾� �α�â �̺�Ʈ �ѹ�
const DIALOGID_DelFriend = 1;
const DIALOGID_ErrorFriend = 2;

//�� ���� �ִ�ġ
const MAX_FRIEND = 128;
const MAX_PLEDGE = 220;
const MAX_POSTFRIEND = 100;

//���� �ѹ�
const FRIEND_TAB = 0;
const PLEDGE_TAB = 1;
const POSTFRIEND_TAB = 2;


function OnRegisterEvent()
{
	RegisterEvent( EV_ReceiveFriendList );
	RegisterEvent( EV_ReceivePledgeMemberList );
	RegisterEvent( EV_ReceivePostFriendList );
	RegisterEvent( EV_ConfirmAddingPostFriend );

	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );

	RegisterEvent( EV_ListCtrlLoseSelected );
	RegisterEvent( EV_Restart );
}

function OnLoad()
{
	Initialize();
	Load();
	m_selectedTab = FRIEND_TAB;
	selectedInit();

}

function selectedInit()
{
	selectFriend = "";
	bPostFriendSelect = false;
}

function Initialize()
{
	Me = GetWindowHandle( "PostReceiverListWnd" );
	Description = GetTextBoxHandle( "PostReceiverListWnd.Description" );
	DescriptionGroupBox = GetTextureHandle( "PostReceiverListWnd.DescriptionGroupBox" );
	ListCount = GetTextBoxHandle( "PostReceiverListWnd.ListCount" );
	TabCtrl = GetTabHandle( "PostReceiverListWnd.TabCtrl" );
	ListGroupBox = GetTextureHandle( "PostReceiverListWnd.ListGroupBox" );
	TabLineTop = GetTextureHandle( "PostReceiverListWnd.TabLineTop" );
	tabBg = GetTextureHandle( "PostReceiverListWnd.tabBg" );
	PostReceiverListWnd_Friends = GetWindowHandle( "PostReceiverListWnd.PostReceiverListWnd_Friends" );
	FriendsList = GetListCtrlHandle( "PostReceiverListWnd.PostReceiverListWnd_Friends.FriendsList" );
	FriendsListDeco = GetTextureHandle( "PostReceiverListWnd.PostReceiverListWnd_Friends.FriendsListDeco" );
	PostReceiverListWnd_Clan = GetWindowHandle( "PostReceiverListWnd.PostReceiverListWnd_Clan" );
	ClanList = GetListCtrlHandle( "PostReceiverListWnd.PostReceiverListWnd_Clan.ClanList" );
	ClanListDeco = GetTextureHandle( "PostReceiverListWnd.PostReceiverListWnd_Clan.ClanListDeco" );
	PostReceiverListWnd_Add = GetWindowHandle( "PostReceiverListWnd.PostReceiverListWnd_Add" );
	AddList = GetListCtrlHandle( "PostReceiverListWnd.PostReceiverListWnd_Add.AddList" );
	Btn_Add = GetButtonHandle( "PostReceiverListWnd.PostReceiverListWnd_Add.Btn_Add" );
	Btn_Del = GetButtonHandle( "PostReceiverListWnd.PostReceiverListWnd_Add.Btn_Del" );
	AddListGroupBoxLine = GetTextureHandle( "PostReceiverListWnd.PostReceiverListWnd_Add.AddListGroupBoxLine" );
	AddListDeco = GetTextureHandle( "PostReceiverListWnd.PostReceiverListWnd_Add.AddListDeco" );
	CloseButton = GetButtonHandle( "PostReceiverListWnd.CloseButton" );

	PostReceiverListAddWnd = GetWindowHandle( "PostReceiverListAddWnd" );
}

function Load(){
	
}

function OnShow()
{	
	SetCount( m_selectedTab );
	Btn_Del.DisableWindow();
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "Btn_Add":
		OnBtn_AddClick();
		break;
	case "Btn_Del":
		OnBtn_DelClick();
		break;
	case "CloseButton":
		OnCloseButtonClick();
		break;

	case "TabCtrl0":
		setFriendCount();
		break;
	case "TabCtrl1":
		setPledgeCount();
		break;
	case "TabCtrl2":
		setPostFrienddCount();
		break;
	}
}

//ģ�� ���� ī��Ʈ �� ���� ���� 
function setFriendCount()
{
	m_selectedTab = FRIEND_TAB;	
	SetCount(m_selectedTab);
}
//���� ���� ī��Ʈ �� ���� ����
function setPledgeCount()
{
	m_selectedTab = PLEDGE_TAB;
	SetCount(m_selectedTab);
}
//�޴����߰� ���� ī��Ʈ �� ���� ����
function setPostFrienddCount()
{
	m_selectedTab = POSTFRIEND_TAB;
	SetCount(m_selectedTab);
}

//�� ���� �ο��� ǥ��
function SetCount( int count )
{
	switch( count )
	{
		case FRIEND_TAB:
			ListCount.SetText( countFriend );
			break;
		case PLEDGE_TAB:
			ListCount.SetText( countPledge );
			break;
		case POSTFRIEND_TAB:
			ListCount.SetText( countPostFriend );
			break;
	}
}
//�޴��� �߰� ���� ���̸� �߰�
function OnBtn_AddClick()
{
	DisableTab();

	class'UIAPI_EDITBOX'.static.SetString( "PostReceiverListAddWnd.Name", "" );
	PostReceiverListAddWnd.ShowWindow();
	PostReceiverListAddWnd.SetFocus();
}

function DisableTab()
{
	local ButtonHandle sendBtn;
	sendBtn = GetButtonHandle( "PostWriteWnd.SendBtn" );

	sendBtn.DisableWindow();
	AddList.DisableWindow();
	TabCtrl.DisableWindow();	
	Btn_Add.DisableWindow();
	Btn_del.DisableWindow();
	CloseButton.DisableWindow();

}

function EnableTab()
{
	local ButtonHandle sendBtn;
	sendBtn = GetButtonHandle( "PostWriteWnd.SendBtn" );

	sendBtn.EnableWindow();
	TabCtrl.EnableWindow();
	AddList.EnableWindow();
	Btn_Add.EnableWindow();

	if(	bPostFriendSelect )
	{
		Btn_del.EnableWindow();
	}
	CloseButton.EnableWindow();
}

//�޴��� �߰� ���� ���� �̸� ����
function OnBtn_DelClick()
{
	if( selectFriend != "" )
	{
		DisableTab();

		DialogSetID( DIALOGID_DelFriend );
		DialogShow( DIALOG_Modalless, DIALOG_OKCancel, MakeFullSystemMsg( GetSystemMessage( 3218 ), selectFriend, "" ) );		
	}
}
//���� �̸� ���� �� Ȯ�� ��ư Ŭ�� �̺�Ʈ 
function HandleDialogOK()
{
	if( DialogIsMine() )
	{
		switch( DialogGetID() )
		{
		case DIALOGID_DelFriend:
			//�޴��� �߰� ����Ʈ�� ���� �̸� ����				
			EnableTab();
			Btn_Del.DisableWindow();		
			DeletePostFriend();		
			break;

		case DIALOGID_ErrorFriend:
			EnableTab();
			break;

		default:
			EnableTab();
			break;
		}
	}
	else
	{
		//���� ó�� �ٸ� dialog â�� ���� ���.
		EnableTab();
	}
}
//���� �̸� ���� �� ��� ��ư Ŭ�� �̺�Ʈ 
function HandleDialogCancel()
{
	if( DialogIsMine() )
	{
		switch( DialogGetID() )
		{
		//"�̸� ������ ��� �Ǿ����ϴ�." �ý��� �޽��� ������.
		case DIALOGID_DelFriend:
			EnableTab();
			AddSystemMessage(3220);
			break;

		default:
			EnableTab();
			break;
		}
	}
	else
	{
		//���� ó�� �ٸ� dialog â�� ���� ���.
		EnableTab();
	}
}

//�޴��� �߰� ����Ʈ�� ���� �̸� ����
function DeletePostFriend()
{
	local int i;
	
	NumPostFriend = NumPostFriend - 1;	
	countPostFriend = "(" $ string(NumPostFriend) $ "/" $ MAX_POSTFRIEND $ ") ";
	SetCount( POSTFRIEND_TAB );

	i = AddList.GetSelectedIndex();

	AddList.DeleteRecord( i );
	
	class'PostWndAPI'.static.RequestDeletingPostFriend( selectFriend );

	class'PostWndAPI'.static.RequestPostFriendList();

	selectedInit();
}
//�ݱ� ��ư Ŭ�� ��.
function OnCloseButtonClick()
{
	local PostWriteWnd Script;
	
	Script = PostWriteWnd( GetScript( "PostWriteWnd" ) );
	
	Script.SetBoolPostReceiverList( false );
	HandleRestart();
	Me.HideWindow();	
}

function OnEvent( int Event_ID, String Param )
{
	switch(Event_ID)
	{
	case EV_ReceiveFriendList:
		FriendsList.DeleteAllItem();
		HandleReceiveFriendList(Param);
		break;

	case EV_ReceivePledgeMemberList:
		ClanList.DeleteAllItem();
		HandleReceivePledgeMemberList(Param);
		break;

	case EV_ReceivePostFriendList:
		AddList.DeleteAllItem();
		HandleReceivePostFriendList(Param);
		break;

	case EV_ConfirmAddingPostFriend:
		HandleConfirmAddingPostFriend(Param);
		break;
	
	case EV_DialogOK:
		HandleDialogOK();
		break;

	case EV_DialogCancel:
		HandleDialogCancel();
		break;
	//����Ʈ��Ʈ�� ���� ����
	case EV_ListCtrlLoseSelected:
		HandleListCtrlLose(Param);
		break;
	//�ٽý��� ���� ��
	case EV_Restart:
		HandleRestart();
		break;
	}
}
function HandleRestart()
{
	selectFriend = "";
	bPostFriendSelect = false;
}

//ģ�� ����Ʈ �̸�Ʈ �޾����� ó��
function HandleReceiveFriendList( string param )
{
	local int Num;
	local int i;
	local string strName;
	local int FriendClass;
	local int FriendLevel;
	local LVDataRecord Record;
	local EditBoxHandle e_handle; //������ �ڵ� ����
	local array<String> addName;

	e_handle = GetEditBoxHandle( "PostWriteWnd.ReceiverID" ); //�ڵ��� �����´�

	ParseInt( Param, "Num", Num );

	countFriend = "(" $ string(Num) $ "/" $ MAX_FRIEND $ ") ";

	for( i = 0 ; i < Num ; i++ )
	{
		ParseString( Param, "Name"$i, strName );
		ParseInt( Param, "FriendClass"$i, FriendClass );
		ParseInt( Param, "FriendLevel"$i, FriendLevel );
		
		//debug("ģ�� Name--->> " $ strName );
		//debug("ģ�� FriendClass--->> " $ string(FriendClass) );
		//debug("ģ�� FriendLevel--->> " $ string(FriendLevel) );
		//debug(string(i)@"--------------------------------->>>>"@addName[i]);	
		//class'UIAPI_EDITBOX'.static.AddNameToAdditionalFriendSearchList( "PostWriteWnd.ReceiverID", strName );		

		addName[i] = strName;

		Record.LVDataList.length = 3;
		Record.LVDataList[0].szData = strName;
		Record.LVDataList[1].szTexture = GetClassIconName( FriendClass );
		Record.LVDataList[1].nTextureWidth = 11;
		Record.LVDataList[1].nTextureHeight = 11;
		Record.LVDataList[1].szData = String( FriendClass );
		Record.LVDataList[2].szData = string( FriendLevel );
		//Record.nReserved1 = FriendLevel;

		class'UIAPI_LISTCTRL'.static.InsertRecord( "PostReceiverListWnd.FriendsList", Record );
	}

	e_handle.FillFriendSearchList( addName );
	SetCount(m_selectedTab);
}

//���� ����Ʈ �̸�Ʈ �޾����� ó��
function HandleReceivePledgeMemberList( string param )
{
	local int Num;
	local int i;
	local string strName;
	local int ClanClass;
	local int ClanLevel;
	local LVDataRecord Record;
	local EditBoxHandle e_handle; //������ �ڵ� ����
	local array<String> addName;

	e_handle = GetEditBoxHandle( "PostWriteWnd.ReceiverID" ); //�ڵ��� �����´�
	ParseInt( Param, "Num", Num );
	
	//debug("-------->>>>>"$Num);

	countPledge = "(" $ string(Num) $ "/" $ MAX_PLEDGE $ ") ";
	
	for( i = 0 ; i < Num ; i++ )
	{
		ParseString( Param, "Name"$i, strName );
		ParseInt( Param, "FriendClass"$i, ClanClass );
		ParseInt( Param, "FriendLevel"$i, ClanLevel );
		
		//debug("ģ�� Name--->> " $ strName );
		//debug("ģ�� ClanClass--->> " $ string(ClanClass) );
		//debug("ģ�� ClanLevel--->> " $ string(ClanLevel) );
		
		addName[i] = strName;

		Record.LVDataList.length = 3;
		Record.LVDataList[0].szData = strName;
		Record.LVDataList[1].szTexture = GetClassIconName( ClanClass );
		Record.LVDataList[1].nTextureWidth = 11;
		Record.LVDataList[1].nTextureHeight = 11;
		Record.LVDataList[1].szData = String( ClanClass );
		Record.LVDataList[2].szData = string( ClanLevel );

		class'UIAPI_LISTCTRL'.static.InsertRecord( "PostReceiverListWnd.ClanList", Record );
	}

	e_handle.FillPledgeMemberSearchList( addName );
	SetCount(m_selectedTab);
}

//�޴��� �߰� ����Ʈ �̸�Ʈ �޾����� ó��
function HandleReceivePostFriendList( string param )
{
	local int Num;
	local int i;
	local string strName;
	local LVDataRecord Record;
	local EditBoxHandle e_handle; //������ �ڵ� ����
	local array<String> addName;

	e_handle = GetEditBoxHandle( "PostWriteWnd.ReceiverID" ); //�ڵ��� �����´�
	ParseInt( Param, "Num", Num );
	NumPostFriend = Num;

	//debug("Post ģ�� ����--->> " $ string(Num) );	

	countPostFriend = "(" $ string(NumPostFriend) $ "/" $ MAX_POSTFRIEND $ ") ";

	for( i = 0 ; i < Num ; i++ )
	{
		ParseString( Param, "Name"$i, strName );
		
		addName[i] = strName;

		Record.LVDataList.length = 1;
		Record.LVDataList[0].szData = strName;

		class'UIAPI_LISTCTRL'.static.InsertRecord( "PostReceiverListWnd.AddList", Record );
	}

	e_handle.FillAdditionalFriendSearchList( addName );
	SetCount(m_selectedTab);
}

//�޴� �� �߰��� �� �̸� �߰��� ���� ������ �̺�Ʈ ó��.
function HandleConfirmAddingPostFriend( string param )
{
	local string strName;
	local int Result;

	ParseString( Param, "Name", strName );
	ParseInt( Param, "Result", Result );
	
	if( Result == 1 )
	{
		//debug( "�޴��� �߰� ����" );
		class'PostWndAPI'.static.RequestPostFriendList();
		EnableTab();
	}
	else if( Result == -1 )
	{
		//debug( "�����ؼ� �Է��� ��� --> �Ƹ� ���� ��" );
		//���� �̸��� ��� �ϴ� ���Դϴ�. ��� �Ŀ� �ٽ� �õ����ּ���.
		DialogSetID( DIALOGID_ErrorFriend );
		DialogShow( DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3223) );
	}
	else if( Result == -2 || Result == 0 )
	{
		//debug( "�������� �ʴ� �̸�!!" $  strName );
		//??�� �������� �ʴ� �̸��Դϴ�. �ٽ� Ȯ���Ͻð� �Է��� �ּ���.
		DialogSetID( DIALOGID_ErrorFriend );
		DialogShow( DIALOG_Modalless, DIALOG_Notice, MakeFullSystemMsg( GetSystemMessage( 3215 ), strName, "" ) );
	}
	else if( Result == -3 )
	{
		//debug( "100�� �Ѿ��� ���." );
		//�̸� �߰� �ѵ�(100��)��  �ʰ��Ͽ� ���� ����� ��  �����ϴ�.
		DialogSetID( DIALOGID_ErrorFriend );
		DialogShow( DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3222) );
	}
	else if( Result == -4 )
	{
		//debug( "�ߺ��� �̸��� ���." );
		//�̹� �޴� �� �߰� ��Ͽ� �����ϴ� �̸��Դϴ�.
		DialogSetID( DIALOGID_ErrorFriend );
		DialogShow( DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3216) );
	}
	else
	{
		//debug( "���� ��..? ����!!!>>>Result=="$string(Result) );
		//���� �̸��� ��� �� �� ���� ��Ȳ�Դϴ�.
		DialogSetID( DIALOGID_ErrorFriend );
		DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3217));
	}	
}

//�޴� �� �߰����� ���� �������� ���.
function HandleListCtrlLose( string param )
{
	local string ListCtrlName;
	
	ParseString( Param, "ListCtrlName", ListCtrlName );

	if( ListCtrlName == AddList.GetWindowName() )
	{
		bPostFriendSelect = false;
		Btn_Del.DisableWindow();
	}
}

//���ڵ带 ����Ŭ���ϸ�....
function OnDBClickListCtrlRecord( string ListCtrlID )
{
	local LVDataRecord	record;	
	
	switch(ListCtrlID)
	{
		case "FriendsList" :
			FriendsList.GetSelectedRec( record );
			class'UIAPI_EDITBOX'.static.SetString( "PostWriteWnd.ReceiverID", record.LVDataList[0].szData );
			break;

		case "ClanList":
			ClanList.GetSelectedRec( record );
			class'UIAPI_EDITBOX'.static.SetString( "PostWriteWnd.ReceiverID", record.LVDataList[0].szData );
			break;

		case "AddList":
			AddList.GetSelectedRec( record );
			class'UIAPI_EDITBOX'.static.SetString( "PostWriteWnd.ReceiverID", record.LVDataList[0].szData );
			break;
	}
}

//���ڵ带 Ŭ���ϸ�....
function OnClickListCtrlRecord( string ListCtrlID )
{
	local LVDataRecord record;	

	switch(ListCtrlID)
	{
		case "AddList":
			bPostFriendSelect = true;
			Btn_Del.EnableWindow();
			AddList.GetSelectedRec( record );
			selectFriend = record.LVDataList[0].szData;			
			break;
	}
}
defaultproperties
{
}
