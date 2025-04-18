class PostReceiverListAddWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle BtnAdd;
var ButtonHandle BtnCancel;
var EditBoxHandle eName;
var TextBoxHandle Description;
var TextureHandle GroupBox;

var bool            bOpenPostReceiverListAddWnd;


function OnRegisterEvent()
{
	//RegisterEvent(  );
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "PostReceiverListAddWnd" );
	BtnAdd = GetButtonHandle( "PostReceiverListAddWnd.BtnAdd" );
	BtnCancel = GetButtonHandle( "PostReceiverListAddWnd.BtnCancel" );
	eName = GetEditBoxHandle( "PostReceiverListAddWnd.Name" );
	Description = GetTextBoxHandle( "PostReceiverListAddWnd.Description" );
	GroupBox = GetTextureHandle( "PostReceiverListAddWnd.GroupBox" );
}

function Load()
{
}

/**
 * â ����� ��� �Ʒ�â �ʱ�ȭ.
 */
function OnHide()
{
	local PostReceiverListWnd Script;
	
	Script = PostReceiverListWnd( GetScript( "PostReceiverListWnd" ) );
	Script.selectedInit();
	Script.EnableTab();
	
	eName.SetString("");
}

//���̸� �߰� â���� �߰�, �ݱ� ��ư�� ���� �̺�Ʈ
function OnClickButton( string Name )
{
	switch( Name )
	{
	case "BtnAdd":
		OnBtnAddClick();
		break;
	case "BtnCancel":
		OnBtnCancelClick();
		break;
	}
}

//�߰� ��ư Ŭ�� ��
function OnBtnAddClick()
{
	local UserInfo userinfo;
	local string UserName;
	local string AddName;
	
	AddName = eName.GetString();
	
	//�ڱ� �̸� �޾ƿ�.
	if( GetPlayerInfo( userinfo ) )
	{
		UserName = userinfo.Name;		
	}	

	if( eName.GetString() != "" )
	{
		//�ڱ� �̸��� ������ Ȯ��
		if( UserName == AddName )
		{
			DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3221) );
		}
		else
		{			
			//���� �� �߰��� ģ���� �̹� ��� �Ǿ� ������.
			if( SearchPostFriend( AddName ) )
			{
				DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3216) );
				//DialogShow( DIALOG_Modalless,DIALOG_Notice, "�̹� �޴� �� �߰� ��Ͽ� �����ϴ� �̸� �Դϴ�." );
			}
			//�̸� �߰�.
			else
			{
				class'PostWndAPI'.static.RequestAddingPostFriend( AddName );
				Me.HideWindow();
			}
			
			eName.SetString("");
		}
	}
}

//�޴� �� �߰� ��Ͽ��� �̹� �߰��� �̸��� �˻�. 
function bool SearchPostFriend( string s )
{
	local int i;
	local int count;
	local LVDataRecord record;	
	local ListCtrlHandle AddList;

	AddList = GetListCtrlHandle( "PostReceiverListWnd.PostReceiverListWnd_Add.AddList" );
	//�� ���ڵ� ī��Ʈ
	count = class'UIAPI_LISTCTRL'.static.GetRecordCount( "PostReceiverListWnd.AddList" );
	
	//Ȯ��.
	for( i = 0 ; i < count ; i++ )
	{
		AddList.GetRec( i, record );
		if( s == record.LVDataList[0].szData )
		{
			return true;
		}
	}
	return false;
}

//�ݱ�.
function OnBtnCancelClick()
{
	local PostReceiverListWnd Script;
	
	Script = PostReceiverListWnd( GetScript( "PostReceiverListWnd" ) );
	Script.selectedInit();
	Script.EnableTab();

	Me.HideWindow();
	eName.SetString("");
}
defaultproperties
{
}
