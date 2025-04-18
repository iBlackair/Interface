class ItemDescWnd extends UICommonAPI;


var string m_WindowName;
var WindowHandle	m_hItemDescWnd;
var HtmlHandle		m_hHtmlViewer;

function OnRegisterEvent()
{
	RegisterEvent(EV_ItemDescWndShow);
	RegisterEvent(EV_ItemDescWndLoadHtmlFromString);
	RegisterEvent(EV_ItemDescWndSetWindowTitle);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_WindowName="ItemDescWnd";
	
	if(CREATE_ON_DEMAND==0)
	{
		m_hItemDescWnd=GetHandle(m_WindowName);
		m_hHtmlViewer=HtmlHandle(GetHandle(m_WindowName$".HtmlViewer"));
	}
	else
	{
		m_hItemDescWnd=GetWindowHandle(m_WindowName);
		m_hHtmlViewer=GetHtmlHandle(m_WindowName$".HtmlViewer");
	}
}

function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{
	case EV_ItemDescWndShow :
		m_hItemDescWnd.ShowWindow();
		m_hItemDescWnd.SetFocus();
		break;
	case EV_ItemDescWndLoadHtmlFromString :
		HandleLoadHtmlFromString(param);
		break;
	case EV_ItemDescWndSetWindowTitle :
		HandleWindowTitle(param);
		break;
	}
}

function HandleWindowTitle(string param)
{
	local string title;

	ParseString(param, "Title", title);

	m_hItemDescWnd.SetWindowTitle(title);
}

function HandleLoadHtmlFromString(string param)
{
	local string htmlString;
	ParseString(param, "HTMLString", htmlString);

	m_hHtmlViewer.LoadHtmlFromString(htmlString);
}


defaultproperties
{
    
}
