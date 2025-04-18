class HelpHtmlWnd extends UIScriptEx;

var bool	m_bShow;

var HtmlHandle	m_hHelpHtmlWndHtmlViewer;


function OnRegisterEvent()
{
	RegisterEvent(EV_ShowHelp);
	RegisterEvent(EV_LoadHelpHtml);
}

function OnLoad()
{
	RegisterState( "HelpHtmlWnd", "GamingState" );
	RegisterState( "HelpHtmlWnd", "LoginState" );

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_hHelpHtmlWndHtmlViewer=GetHtmlHandle("HelpHtmlWnd.HtmlViewer");

	m_bShow = false;
}

function OnShow()
{
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_ShowHelp)
	{
		HandleShowHelp(param);
	}
	else if (Event_ID == EV_LoadHelpHtml)
	{
		HandleLoadHelpHtml(param);
	}
}

function HandleShowHelp(string param)
{
	local string strPath;
	
	if (m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("HelpHtmlWnd");
	}
	else
	{
		ParseString(param, "FilePath", strPath);
		if (Len(strPath)>0)
		{
			m_hHelpHtmlWndHtmlViewer.LoadHtml(strPath);
			PlayConsoleSound(IFST_WINDOW_OPEN);	
			class'UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
			class'UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");
		}		
	}
}

function HandleLoadHelpHtml(string param)
{
	local string strHtml;
	
	ParseString(param, "HtmlString", strHtml);
	if (Len(strHtml)>0)
	{
		m_hHelpHtmlWndHtmlViewer.LoadHtmlFromString(strHtml);
	}		
}
defaultproperties
{
}
