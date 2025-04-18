class TutorialViewerWnd extends UICommonAPI;

var HtmlHandle m_hTutorialViewerWndHtmlTutorialViewer;

function OnRegisterEvent()
{
	RegisterEvent( EV_TutorialViewerWndShow );
	RegisterEvent( EV_TutorialViewerWndHide );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_hTutorialViewerWndHtmlTutorialViewer=GetHtmlHandle("TutorialViewerWnd.HtmlTutorialViewer");
}

function OnEvent( int Event_ID, string param )
{
	local string HtmlString;
	local Rect rect;

	local int HtmlHeight;

	switch( Event_ID )
	{
	case EV_TutorialViewerWndShow :
		ParseString(param, "HtmlString", HtmlString);

		m_hTutorialViewerWndHtmlTutorialViewer.LoadHtmlFromString(HtmlString);

		rect=class'UIAPI_WINDOW'.static.GetRect("TutorialViewerWnd");
		HtmlHeight=m_hTutorialViewerWndHtmlTutorialViewer.GetFrameMaxHeight();



		
		if(HtmlHeight < 328) 
			HtmlHeight = 328;
		else if(HtmlHeight > 680-8) // ��Ų ���� ������ ���� - innowind 2007. 6. 22
			HtmlHeight = 680-8;

		rect.nHeight=HtmlHeight+30+8;		// +26�� Frame ���̿� ��� �ؽ��� ���̸� ���Ѱ�.  +8�� Html �� �Ʒ��κ��� ���� ������ ������ �־ ���Ƿ� ����ġ�� �־��ذ�
		
		class'UIAPI_WINDOW'.static.SetWindowSize("TutorialViewerWnd", rect.nWidth, rect.nHeight);
		class'UIAPI_WINDOW'.static.SetWindowSize("TutorialViewerWnd.HtmlBg", rect.nWidth - 10, rect.nHeight -30 - 12);
		class'UIAPI_WINDOW'.static.SetWindowSize("TutorialViewerWnd.HtmlTutorialViewer", rect.nWidth-20, rect.nHeight-30-20);	// -innowind 2007.6.22
		ShowWindowWithFocus("TutorialViewerWnd");
		break;
	case EV_TutorialViewerWndHide :
		HideWindow("TutorialViewerWnd");
		break;
	}
}
defaultproperties
{
}
