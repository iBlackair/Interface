class MacroInfoWnd extends UICommonAPI;

var bool	m_bShow;
var string	m_strInfo;

function OnLoad()
{
	m_bShow = false;
	m_strInfo = "";
}

function OnShow()
{
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
}

function OnClickButton( string strID )
{	
	switch( strID )
	{
	case "btnOk":
		OnClickOk();
		break;
	case "btnCancel":
		OnClickCancel();
		break;
	}
}

function SetInfoText( string strInfo )
{
	m_strInfo = strInfo;
	class'UIAPI_MULTIEDITBOX'.static.SetString( "MacroInfoWnd.txtInfo", strInfo);
}

function string GetInfoText()
{
	m_strInfo = class'UIAPI_MULTIEDITBOX'.static.GetString( "MacroInfoWnd.txtInfo");
	return m_strInfo;
}

//////////////////////////////////////////////////////////////////////////////////
//Ȯ��
function OnClickOk()
{
	// 32����Ʈ �̻��� �Ǹ� ��� �˾��� ���� �����Ѵ�. 
	local string tempStr;
	
	tempStr = class'UIAPI_MULTIEDITBOX'.static.GetString( "MacroInfoWnd.txtInfo");
	if(Len(tempStr) > 32)
	{
		class'UIAPI_MULTIEDITBOX'.static.SetString( "MacroInfoWnd.txtInfo", Left(tempStr, 32));
		tempStr = GetSystemMessage(837);
		DialogShow(DIALOG_Modalless,DIALOG_Notice, tempStr);
		return;
	}
	
	class'UIAPI_WINDOW'.static.HideWindow("MacroInfoWnd");
}

//////////////////////////////////////////////////////////////////////////////////
//���
function OnClickCancel()
{
	class'UIAPI_MULTIEDITBOX'.static.SetString( "MacroInfoWnd.txtInfo", m_strInfo);	// ������ ����Ǿ��ִ����� �־��ְ� ����
	class'UIAPI_WINDOW'.static.HideWindow("MacroInfoWnd");
}

//////////////////////////////////////////////////////////////////////////////////
// Clear
function Clear()
{
	m_strInfo = "";
	class'UIAPI_MULTIEDITBOX'.static.SetString( "MacroInfoWnd.txtInfo", "");
}
defaultproperties
{
}
