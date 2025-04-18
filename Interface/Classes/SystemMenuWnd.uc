class SystemMenuWnd extends UICommonAPI;

var WindowHandle m_hOptionWnd;
var WindowHandle m_hUserPetitionWnd;
var WindowHandle m_hNewUserPetitionWnd;
var WindowHandle PostBoxWnd;
var TextBoxHandle m_hTbBBS;
var TextBoxHandle m_hTbMacro;

var WindowHandle ProductInventoryWnd;

var int IsPeaceZone;		//���� ���� PeaceZone�ΰ�

const DIALOGID_Gohome = 0;

function OnRegisterEvent()
{
	RegisterEvent( EV_LanguageChanged );
	RegisterEvent( EV_SetRadarZoneCode );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hOptionWnd=GetHandle("OptionWnd");
		m_hUserPetitionWnd=GetHandle("UserPetitionWnd");
		m_hNewUserPetitionWnd=GetHandle("NewUserPetitionWnd");
		m_hTbBBS=TextBoxHandle(GetHandle("SystemMenuWnd.txtBBS"));
		m_hTbMacro=TextBoxHandle(GetHandle("SystemMenuWnd.txtMacro"));
		PostBoxWnd=GetHandle("PostBoxWnd");
		ProductInventoryWnd = GetHandle("ProductInventoryWnd");
	}
	else
	{
		m_hOptionWnd=GetWindowHandle("OptionWnd");
		m_hUserPetitionWnd=GetWindowHandle("UserPetitionWnd");
		m_hNewUserPetitionWnd=GetWindowHandle("NewUserPetitionWnd");
		m_hTbBBS=GetTextBoxHandle("SystemMenuWnd.txtBBS");
		m_hTbMacro=GetTextBoxHandle("SystemMenuWnd.txtMacro");
		PostBoxWnd=GetWindowHandle("PostBoxWnd");
		ProductInventoryWnd = GetWindowHandle("ProductInventoryWnd");
	}

	SetMenuString();
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnProductInventory" :
		HandleShowProductInventory();
		break;
	case "btnPost":
		HandleShowPostBoxWnd();
		break;
	case "btnBBS":
		HandleShowBoardWnd();
		break;
	case "btnMacro":
		HandleShowMacroListWnd();
		break;
	case "btnHelpHtml":
		HandleShowHelpHtmlWnd();
		break;
	case "btnPetition":
		HandleShowPetitionBegin();
		break;
	case "btnOption":
		HandleShowOptionWnd();
		break;
	//Ȩ������ ��ũ(10.1.18 ������ �߰�)
	case "btnHomepage":
		linkHomePage();
		break;
	//
	case "btnRestart":
		ExecuteEvent(EV_OpenDialogRestart);
		break;
	case "btnQuit":
		ExecuteEvent(EV_OpenDialogQuit);
		break;
	case "btnDEADZ":
		if (class'UIAPI_WINDOW'.static.IsShowWindow("FlexOptionWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("FlexOptionWnd");
		}	
		else
		{
			class'UIAPI_WINDOW'.static.ShowWindow("FlexOptionWnd");
			class'UIAPI_WINDOW'.static.SetFocus("FlexOptionWnd");
		}
		break;
	}
}

function OnEvent(int Event_ID, String param)
{
	local int zonetype;
	if( Event_ID == EV_LanguageChanged )
	{
		SetMenuString();
	}
	else if ( Event_ID == EV_SetRadarZoneCode )
	{
		ParseInt( param, "ZoneCode", zonetype );		
		if (zonetype == 12)
		{
			IsPeaceZone = 1;
		}
		else
		{
			IsPeaceZone = 0;
		}
	}
	else if( Event_ID == EV_DialogOK )
	{
		HandleDialogOK();
	}
	else if( Event_ID == EV_DialogCancel )
	{
		
	}
}

//��ǰ �κ��丮 ����
function HandleShowProductInventory()
{
	if( ProductInventoryWnd.IsShowWindow() )
	{
		ProductInventoryWnd.HideWindow();
	}
	else
	{
		if( ! class'UIAPI_WINDOW'.static.IsShowWindow("ShopWnd") )	
		{
			ProductInventoryWnd.ShowWindow();
			ProductInventoryWnd.SetFocus();
		}
	}
}


//Ȩ������ ��ũ(10.1.18 ������ �߰�)
function HandleDialogOK()
{
	if( !DialogIsMine() )
		return;

	switch( DialogGetID() )
	{
	case DIALOGID_Gohome:
		OpenL2Home();
		break;
	}
}

function linkHomePage()
{
	DialogSetID( DIALOGID_Gohome );
	DialogShow( DIALOG_Modalless, DIALOG_OKCancel, GetSystemMessage( 3208 ) );
}




function HandleShowPostBoxWnd()
{
	if( PostBoxWnd.isShowWindow())
	{
		PostBoxWnd.HideWindow();
	}
	else
	{
		RequestRequestReceivedPostList();
		if (IsPeaceZone == 0)
			AddSystemMessage(3066);
	}

}


function HandleShowBoardWnd()
{
	local string strParam;
	ParamAdd(strParam, "Init", "1");
	ExecuteEvent(EV_ShowBBS, strParam);
}

function HandleShowHelpHtmlWnd()
{
	local  AgeWnd script1;	// ���ǥ�� ��ũ��Ʈ ��������
	
	local string strParam;
	ParamAdd(strParam, "FilePath", "..\\L2text\\help.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
	
	script1 = AgeWnd( GetScript("AgeWnd") );
	
	if(script1.bBlock == false)	script1.startAge();	//���ǥ�ø� ���ش�. 
}

function HandleShowMacroListWnd()
{
	ExecuteEvent(EV_MacroShowListWnd);
}

function HandleShowPetitionBegin()
{
	local bool useNewPetition;
	useNewPetition = GetUseNewPetitionBool();

	if(useNewPetition)
	{
		if(m_hNewUserPetitionWnd.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hNewUserPetitionWnd.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowNewUserPetition();
		}
	}
	else
	{
		if (m_hUserPetitionWnd.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hUserPetitionWnd.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			m_hUserPetitionWnd.ShowWindow();
			m_hUserPetitionWnd.SetFocus();
		}
	}
}

function HandleShowOptionWnd()
{
	if (m_hOptionWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hOptionWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hOptionWnd.ShowWindow();
		m_hOptionWnd.SetFocus();
	}
}

function SetMenuString()
{
	//����Ű �ٿ��ֱ�
	m_hTbBBS.SetText(GetSystemString(387) $ "(Alt+B)");
	m_hTbMacro.SetText(GetSystemString(711) $ "(Alt+R)");
}
defaultproperties
{
}
