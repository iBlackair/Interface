class BoardWnd extends UIScriptEx;

var bool	m_bShow;
var bool	m_bBtnLock;
var string 	m_Command[8];

var HtmlHandle	m_hBoardWndHtmlViewer;

var TabHandle	m_hBoardWndTabCtrl;

function OnRegisterEvent()
{
	RegisterEvent( EV_ShowBBS );
	RegisterEvent( EV_ShowBoardPacket );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();


	m_hBoardWndHtmlViewer=GetHtmlHandle("BoardWnd.HtmlViewer");
	m_hBoardWndTabCtrl=GetTabHandle("BoardWnd.TabCtrl");

	m_bShow = false;
	m_bBtnLock = false;
}

function OnShow()
{
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
	class'UIAPI_WINDOW'.static.SetFocus("ChatWnd");
	
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_ShowBBS)
	{
		HandleShowBBS(param);
	}
	else if (Event_ID == EV_ShowBoardPacket)
	{
		HandleShowBoardPacket(param);
	}
}

function OnClickButton( string strID )
{	
	Debug( "-->" @ strID );


	switch( strID )
	{
	case "btnBookmark":
		OnClickBookmark();
		break;
	}
	
	//�ǹ�ư Ŭ��
	if (Left(strID, 7) == "TabCtrl")
	{
		strID = Mid(strID, 7);
		if (!class'UIAPI_WINDOW'.static.IsMinimizedWindow( "BoardWnd" ))
		{
			ShowBBSTab(int(strID));
		}
	}
}

//�ʱ�ȭ
function Clear()
{
	
}

function HandleShowBBS(string param)
{
	local int Index;
	local int Init;
	
	ParseInt(param, "Index", Index);
	ParseInt(param, "Init", Init);
	
	//�ʱ���·� ���°�? (SystemMenu�κ���)
	if (Init>0)
	{
		if (m_bShow)
		{
			//�̹� ���̰� ������ �ݴ´�.
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			class'UIAPI_WINDOW'.static.HideWindow("BoardWnd");
			return;
		}
		else
		{
			if (!m_hBoardWndHtmlViewer.IsPageLock())
			{
				m_hBoardWndHtmlViewer.SetPageLock(true);
				m_hBoardWndTabCtrl.SetTopOrder(0, false);
				m_hBoardWndHtmlViewer.Clear();
				RequestBBSBoard();
			}
		}
		
		//���߿� HandleShowBoardPacket���� ShowWindow�� �Ѵ�.
	}
	else
	{
		m_hBoardWndTabCtrl.SetTopOrder(Index, false);
		m_hBoardWndHtmlViewer.Clear();
		ShowBBSTab(Index);
	}
}

function HandleShowBoardPacket(string param)
{
	local int idx;
	local int OK;
	local string Address;
	
	ParseInt(param, "OK", OK);
	if (OK<1)
	{
		class'UIAPI_WINDOW'.static.HideWindow("BoardWnd");
		return;
	}
	
	//Clear
	for (idx=0; idx<8; idx++)
		m_Command[idx] = "";
	
	ParseString(param, "Command1", m_Command[0]);
	ParseString(param, "Command2", m_Command[1]);
	ParseString(param, "Command3", m_Command[2]);
	ParseString(param, "Command4", m_Command[3]);
	ParseString(param, "Command5", m_Command[4]);
	ParseString(param, "Command6", m_Command[5]);
	ParseString(param, "Command7", m_Command[6]);
	ParseString(param, "Command8", m_Command[7]);
	m_bBtnLock = false;
	
	ParseString(param, "Address", Address);
	m_hBoardWndHtmlViewer.SetHtmlBuffData(Address);
	if (!m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		class'UIAPI_WINDOW'.static.ShowWindow("BoardWnd");
		class'UIAPI_WINDOW'.static.SetFocus("BoardWnd");
	}
}

function ShowBBSTab(int Index)
{
	local string strBypass;
	local EControlReturnType Ret;
	
	switch( Index )
	{
	//ó������
	case 0:
		strBypass = "bypass _bbshome";
		break; 
	//���ã��
	case 1:
		strBypass = "bypass _bbsgetfav"; 
		break;
	//Ȩ������ ��ũ(10.1.11 ������ ����)
	case 2:
		strBypass = "bypass _bbslink";
		break;
	//������ũ
	case 3:
		strBypass = "bypass _bbsloc";
		break;
	//���͸�ũ
	case 4:
		strBypass = "bypass _bbsclan";
		break;
	//�޸�
	case 5:
		strBypass = "bypass _bbsmemo";
		break;
	//����
	case 6:
		strBypass = "bypass _maillist_0_1_0_"; 
		break;
	//ģ������
	case 7:
		strBypass = "bypass _friendlist_0_"; 
		break;
	}
	
	if (Len(strBypass)>0)
	{
		Ret = m_hBoardWndHtmlViewer.ControllerExecution(strBypass);
		if (Ret == CRTT_CONTROL_USE)
		{
			m_bBtnLock = true;
		}
	}	
}

function OnClickBookmark()
{
	local EControlReturnType Ret;
	
	if (Len(m_Command[7])>0 && !m_bBtnLock)
	{
		Ret = m_hBoardWndHtmlViewer.ControllerExecution(m_Command[7]);
		if (Ret == CRTT_CONTROL_USE)
		{
			m_bBtnLock = true;
		}
	}
}
defaultproperties
{
}
