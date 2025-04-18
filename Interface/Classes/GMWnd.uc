class GMWnd extends UICommonAPI;

const DIALOGID_Recall = 0;
const DIALOGID_SendHome = 1;
const DIALOGID_NPCList = 2;
const DIALOGID_ItemList = 3;
const DIALOGID_SkillList = 4;

var Color m_WhiteColor;
var EditBoxHandle m_hEditBox;
var WindowHandle m_hGMwnd;
var WindowHandle m_hGMDetailStatusWnd;
var WindowHandle m_hGMInventoryWnd;
var WindowHandle m_hGMMagicSkillWnd;
var WindowHandle m_hGMQuestWnd;
var WindowHandle m_hGMWarehouseWnd;
var WindowHandle m_hGMClanWnd;
//diff_elsacred_s
var WindowHandle m_hGMFindTreeWnd;
//diff_elsacred_e
var int m_TargetID;

var WindowHandle m_dialogWnd;

var ComboBoxHandle m_hCbClassName;

var string m_WindowName;


function OnRegisterEvent()
{
	RegisterEvent( EV_ShowGMWnd );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
	RegisterEvent( EV_TargetUpdate );
}

function OnLoad()
{
	m_WindowName="GMWnd";
	InitHandle();

	m_WhiteColor.R = 220;
	m_WhiteColor.G = 220;
	m_WhiteColor.B = 220;
	m_WhiteColor.A = 255;
	
	m_TargetID = 0;
}

function SetClassTypeComboBox()
{
	local int classNameSysString;
	local int i;
	local array<int> EnableClassIndexList;
	local int len;
	local int classIndex;
	local UserInfo targetInfo;
	local int myClassIndex;

	m_hCbClassName.Clear();

	GetTargetInfo(targetInfo);

	if(targetInfo.bNPC)
		return;

	class'UIDataManager'.static.GetEnableClassIndexList(targetInfo.Class, EnableClassIndexList);
	len=EnableClassIndexList.Length;

	debug("Ÿ���̸�:"$targetInfo.Name$", Ŭ����:"$targetInfo.Class$", ���ɱ���:"$len);

	for(i=0; i<len; ++i)
	{
		classIndex=EnableClassIndexList[i];
		debug("�ε���:"$classIndex);
		classNameSysString=class'UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex);
		m_hCbClassName.SYS_AddStringWithReserved(classNameSysString, classIndex);

		// ���ݼ��õ� ���� Ŭ������ �޺��ڽ��� �������ֱ� ���ؼ� �ε����� ����
		if(targetInfo.Class==classindex)
			myClassIndex=i;
	}

	// ���� ���õ� ���� Ŭ������ �޺��ڽ��� �������ݴϴ�.
	m_hCbClassName.SetSelectedNum(myClassIndex);
}




function InitHandle()
{
	m_hGMwnd = GetWindowHandle( m_WindowName );
	m_hEditBox = GetEditBoxHandle( "GMWnd.EditBox" );
	m_hGMDetailStatusWnd = GetWindowHandle( "GMDetailStatusWnd" );
	m_hGMInventoryWnd = GetWindowHandle( "GMInventoryWnd" );
	m_hGMMagicSkillWnd = GetWindowHandle( "GMMagicSkillWnd" );
	m_hGMQuestWnd = GetWindowHandle( "GMQuestWnd" );
	m_hGMWarehouseWnd = GetWindowHandle( "GMWarehouseWnd" );
	m_hGMClanWnd = GetWindowHandle( "GMClanWnd" );
//diff_elsacred_s
	m_hGMFindTreeWnd = GetWindowHandle("GMFindTreeWnd");
	m_dialogWnd = GetWindowHandle( "DialogBox" );	//���̾�α� �ڵ� �޾ƿ���
//diff_elsacred_e
	m_hCbClassName = GetComboboxHandle(m_WindowName$".cbClassName");
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_ShowGMWnd:
		HandleShowGMWnd();
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	case EV_DialogCancel:
		HandleDialogCancel();
		break;
	case EV_TargetUpdate:
		HandleTargetUpdate();
		break;
	}
}

function HandleShowGMWnd()
{
	if( m_hOwnerWnd.IsShowWindow() )
		m_hOwnerWnd.HideWindow();
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hGMwnd.SetFocus();	// ���϶� ��Ŀ���� GMâ�� ����ϴ�.
		//class'UIAPI_WINDOW'.static.SetFocus(m_hGMwnd);
	}
}

function OnShow()
{
	SetClassTypeComboBox();
}

function HandleDialogOK()
{
	if( !DialogIsMine() )
		return;

	switch( DialogGetID() )
	{
	case DIALOGID_Recall:
		Recall();
		break;
	case DIALOGID_SendHome:
		SendHome();
		break;
	}
}

//Ÿ�� ���� ������Ʈ ó��	-- �Է�â�� �̸��� �־��ֱ�
function HandleTargetUpdate()
{
	local int m_nowTargetID;
	local UserInfo	info;
			
	//Ÿ��ID ������
	m_nowTargetID = class'UIDATA_TARGET'.static.GetTargetID();
			
	if(m_nowTargetID == m_TargetID) 	// �ѹ� ��Ʈ���� ���� ���� ������ ����.
	{
		//m_TargetID = 0;	// ������ Ÿ�پ��̵� �ʱ�ȭ
		return;
	}
	
	if (m_nowTargetID<1)	// ���̵� ������ �׳� ����.
	{
		m_TargetID = 0;	// ������ Ÿ�پ��̵� �ʱ�ȭ
		m_hEditBox.SetString("");
		return;
	}
	GetTargetInfo(info);	// ���̵� ���� ��쿡�� ������ ���´�. 

	if((m_nowTargetID>0 ) && (info.bNpc == false))	//NPC�ϰ�쿡�� ���������� �ʴ´�. 
	{		
		m_hEditBox.SetString(info.Name);
	}
	
	m_TargetID = m_nowTargetID;	// ������ Ÿ�پ��̵� �����صд�. 

	SetClassTypeComboBox();
}

function HandleDialogCancel()
{
	if( !DialogIsMine() )
		return;
}

function OnClickButton( String a_ButtonID )
{
	switch( a_ButtonID )
	{
	case "TeleButton":
		OnClickTeleButton();
		break;
	case "MoveButton":
		OnClickMoveButton();
		break;
	case "RecallButton":
		OnClickRecallButton();
		break;
	case "DetailStatusButton":
		OnClickDetailStatusButton();
		break;
	case "InventoryButton":
		OnClickInventoryButton();
		break;
	case "MagicSkillButton":
		OnClickMagicSkillButton();
		break;
	case "QuestButton":
		OnClickQuestButton();
		break;
	case "InfoButton":
		OnClickInfoButton();
		break;
	case "StoreButton":
		OnClickStoreButton();
		break;
	case "ClanButton":
		OnClickClanButton();
		break;
	case "PetitionButton":
		OnClickPetitionButton();
		break;
	case "SendHomeButton":
		OnClickSendHomeButton();
		break;
	case "NPCListButton":
		OnClickNPCListButton();
		break;
	case "ItemListButton":
		OnClickItemListButton();
		break;
	case "SkillListButton":
		OnClickSkillListButton();
		break;
	case "ForcePetitionButton":
		OnClickForcePetitionButton();
		break;
	case "ChangeServerButton":
		OnClickChangeServerButton();
		break;
	case "btnClassChange" :
		OnClickBtnClassChange();
		break;
	case "UIButton":
		OnClickUIButton();
		break;
	}
}

function OnClickBtnClassChange()
{
	local int selected;
	local int classindex;


	selected = m_hCbClassName.GetSelectedNum();
	classIndex=m_hCbClassName.GetReserved(selected);
	if(  classIndex>=0 )
		ExecuteCommand( "//setclass " @ classIndex );
}


function OnClickTeleButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
		ExecuteCommand( "//teleportto" @ EditBoxString );
}

function OnClickMoveButton()
{
	ExecuteCommand( "//instant_move" );
}

function OnClickRecallButton()
{
	DialogSetID( DIALOGID_Recall );
	DialogShow(DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 1220 ) );
}

function Recall()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
		ExecuteCommand( "//recall" @ EditBoxString );
}

function OnClickDetailStatusButton()
{
	local String EditBoxString;
	local GMDetailStatusWnd GMDetailStatusWndScript;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
	{
		GMDetailStatusWndScript = GMDetailStatusWnd( m_hGMDetailStatusWnd.GetScript() );
		GMDetailStatusWndScript.ShowStatus( EditBoxString );
	}
	else
		AddSystemMessage( 364 );
}

function OnClickInventoryButton()
{
	local String EditBoxString;
	local GMInventoryWnd GMInventoryWndScript;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
	{
		GMInventoryWndScript = GMInventoryWnd( m_hGMInventoryWnd.GetScript() );
		GMInventoryWndScript.ShowInventory( EditBoxString );
	}
	else
		AddSystemMessage( 364);
}

function OnClickMagicSkillButton()
{
	local String EditBoxString;
	local GMMagicSkillWnd GMMagicSkillWndScript;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
	{
		GMMagicSkillWndScript = GMMagicSkillWnd( m_hGMMagicSkillWnd.GetScript() );
		GMMagicSkillWndScript.ShowMagicSkill( EditBoxString );
	}
	else
		AddSystemMessage( 364 );
}

function OnClickQuestButton()
{
	local String EditBoxString;
	local GMQuestWnd GMQuestWndScript;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
	{
		GMQuestWndScript = GMQuestWnd( m_hGMQuestWnd.GetScript() );
		GMQuestWndScript.ShowQuest( EditBoxString );
	}
	else
		AddSystemMessage(  364 );
}

function OnClickInfoButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
		ExecuteCommand( "//debug" @ EditBoxString );
}

function OnClickStoreButton()
{
	local String EditBoxString;
	local GMWarehouseWnd GMWarehouseWndScript;

	//debug("GMstore");
	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
	{
		GMWarehouseWndScript = GMWarehouseWnd( m_hGMWarehouseWnd.GetScript() );
		GMWarehouseWndScript.ShowWarehouse( EditBoxString );
	}
	else
		AddSystemMessage( 364 );
}

function OnClickClanButton()
{
	local String EditBoxString;
	local GMClanWnd GMClanWndScript;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
	{
		GMClanWndScript = GMClanWnd( m_hGMClanWnd.GetScript() );
		GMClanWndScript.ShowClan( EditBoxString );
	}
	else
		AddSystemMessage( 364 );
}

function OnClickPetitionButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
		ExecuteCommand( "//add_peti_chat" @ EditBoxString );
}

function OnClickSendHomeButton()
{
	DialogSetID( DIALOGID_SendHome );
	DialogShow(DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 1221 ) );
}

function SendHome()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
		ExecuteCommand( "//sendhome" @ EditBoxString );
}

function OnClickNPCListButton()
{
	local String EditBoxString;

//diff_elsacred_s
	local GMFindTreeWnd m_GMFindTreeWnd;
//diff_elsacred_e

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString == "" )
		return;
//diff_elsacred_s
	if( EditBoxString != "" )
	{
		m_GMFindTreeWnd= GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript() );
		m_GMFindTreeWnd.ShowNPCList(EditBoxString);
	}

}

function OnClickItemListButton()
{
	local String EditBoxString;
//diff_elsacred_s
	local GMFindTreeWnd m_GMFindTreeWnd;
//diff_elsacred_e
	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString == "" )
		return;
	
//diff_elsacred_s
	if( EditBoxString != "" )
	{
		m_GMFindTreeWnd= GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript());
		m_GMFindTreeWnd.ShowItemList(EditBoxString);			
	}

//diff_elsacred_e
}

function OnClickSkillListButton()
{
	local String EditBoxString;
//diff_elsacred_s
	local GMFindTreeWnd m_GMFindTreeWnd;
//diff_elsacred_e	
	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString == "" )
		return;
//diff_elsacred_s
	if( EditBoxString != "" )
	{
		m_GMFindTreeWnd= GMFindTreeWnd ( m_hGMFindTreeWnd.GetScript());
		m_GMFindTreeWnd.ShowSkillList(EditBoxString);	
	}
//diff_elsacred_e

}

function OnClickForcePetitionButton()
{
	local String EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if( EditBoxString != "" )
		ExecuteCommand( "//force_peti" @ EditBoxString @ GetSystemMessage( 1528 ) );
}

function OnClickChangeServerButton()
{
	local String EditBoxString;
	local UserInfo PlayerInfo;

	EditBoxString = m_hEditBox.GetString();

	if( EditBoxString == "" )
		return;

	if( !GetPlayerInfo( PlayerInfo ) )
		return;

	class'GMAPI'.static.BeginGMChangeServer( int( EditBoxString ), PlayerInfo.Loc );
}

function OnClickUIButton()
{
	local WindowHandle UIToolWnd;

	UIToolWnd = GetWindowHandle( "UIToolWnd" );
	UIToolWnd.ShowWindow();
	UIToolWnd.SetFocus();	
}


defaultproperties
{
    
}
