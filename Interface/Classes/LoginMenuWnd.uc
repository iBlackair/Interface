class LoginMenuWnd extends UICommonAPI;


var WindowHandle	m_hOptionWnd;
var CharacterPasswordHelpHtmlWnd   CharacterPasswordHelpHtmlWndScript;
var CharacterPasswordWnd           CharacterPasswordWndScript;

function onShow()
{
	// ��й�ȣ �Է��� Ȥ�� ���� �ִٸ� �ݴ´�.
	// (�ڵ� ���� ����, ��ȣ Ʋ�� �� ���¿��� ����)
	hidePasswordWndAll();
}
function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		m_hOptionWnd=GetHandle("OptionWnd");
	else
		m_hOptionWnd=GetWindowHandle("OptionWnd");

	CharacterPasswordHelpHtmlWndScript = CharacterPasswordHelpHtmlWnd( GetScript("CharacterPasswordHelpHtmlWnd") );
	CharacterPasswordWndScript = CharacterPasswordWnd( GetScript("CharacterPasswordWnd") );
}

function OnClickButton(string strID)
{
	switch(strID)
	{
	case "btnNewAccount" :
		ShowMessageInLogin(GetSystemMessage(1186));
		break;
	case "btnLossAccount" :
		ShowMessageInLogin(GetSystemMessage(1187));
		break;
	case "btnOption" :
		ShowOptionWnd();
		break;
	case "btnCredit" :
		SetUIState("CreditState");
		InitCreditState();
		break;
	case "btnReplay" :
		SetUIState("ReplaySelectState");
		break;
	case "btnHomepage" :
		OpenL2Home();
		break;
	}
}

function ShowOptionWnd()
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

// �н����� �����찡 ���� �ִٸ� ������� �Ѵ�.
function hidePasswordWndAll()
{
	 CharacterPasswordHelpHtmlWndScript.Me.HideWindow();
	 CharacterPasswordWndScript.Me.HideWindow();
}
defaultproperties
{
}
