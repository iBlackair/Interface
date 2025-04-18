class HennaInfoWnd extends UIScriptEx;

// ���� ���� �������� ����
const HENNA_EQUIP=1;		// ��������
const HENNA_UNEQUIP=2;		// ���������

var int m_iState;
var int m_iHennaID;

function OnRegisterEvent()
{
	RegisterEvent( EV_HennaInfoWndShowHideEquip);
	RegisterEvent( EV_HennaInfoWndShowHideUnEquip);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
}

function OnClickButton( string strID )
{
	class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");

	switch( strID )
	{
	case "btnPrev" :
		if(m_iState==HENNA_EQUIP)
			RequestHennaItemList();
		else if(m_iState==HENNA_UNEQUIP)
			RequestHennaUnEquipList();
		break;
	case "btnOK" :
		if(m_iState==HENNA_EQUIP)
			RequestHennaEquip(m_iHennaID);
		else if(m_iState==HENNA_UNEQUIP)
			RequestHennaUnEquip(m_iHennaID);
		break;
	}
}

function OnShow()
{
	// ���¿� ���� ������ �����ְ� �����ݴϴ�
	if(m_iState==HENNA_EQUIP)
	{
		// Ÿ��Ʋ - ��������
		class'UIAPI_WINDOW'.static.SetWindowTitleByText("HennaInfoWnd", GetSystemString(651));
		class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndUnEquip");
		class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndEquip");
	}
	else if(m_iState==HENNA_UNEQUIP)
	{
		// Ÿ��Ʋ - ���������
		class'UIAPI_WINDOW'.static.SetWindowTitleByText("HennaInfoWnd", GetSystemString(652));
		class'UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndEquip");
		class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndUnEquip");
	}
	else
	{
		//debug("�������� �̻��̻�~~");
	}
}


function OnEvent(int Event_ID, string param)
{

	switch(Event_ID)
	{
	case EV_HennaInfoWndShowHideEquip :
		m_iState=HENNA_EQUIP;		// ���¸� "��������"�� �ٲߴϴ�.
		ShowHennaInfoWnd(param);
		break;
	case EV_HennaInfoWndShowHideUnEquip :
		m_iState=HENNA_UNEQUIP;		// ���¸� "���������"�� �ٲߴϴ�.
		ShowHennaInfoWnd(param);
		break;
	}
}

function ShowHennaInfoWnd(string param)
{
	local string strAdenaComma;

	local INT64 iAdena;
	local string strDyeName;			// ����
	local string strDyeIconName;
	local int iHennaID;
	local int iClassID;
	local INT64 iNum;
	local INT64 iFee;

	local string strTattooName;			// ����
	local string strTattooAddName;		// ����
	local string strTattooIconName;

	local int iINTnow;
	local int iINTchange;
	local int iSTRnow;
	local int iSTRchange;
	local int iCONnow;
	local int iCONchange;
	local int iMENnow;
	local int iMENchange;
	local int iDEXnow;
	local int iDEXchange;
	local int iWITnow;
	local int iWITchange;

	local color col;

	ParseINT64(param, "Adena", iAdena);						// �Ƶ���
	ParseString(param, "DyeIconName", strDyeIconName);		// ���� Icon �̸�
	ParseString(param, "DyeName", strDyeName);				// �����̸�
	ParseInt(param, "HennaID", iHennaID);				 
	ParseInt(param, "ClassID", iClassID);
	ParseINT64(param, "NumOfItem", iNum);
	ParseINT64(param, "Fee", iFee);

	ParseString(param, "TattooIconName", strTattooIconName);	// ����������̸�
	ParseString(param, "TattooName", strTattooName);		// �����̸�
	ParseString(param, "TattooAddName", strTattooAddName);	// �������� - ��ġ�����ؽ�Ʈ 

	ParseInt(param, "INTnow", iINTnow);
	ParseInt(param, "INTchange", iINTchange);
	ParseInt(param, "STRnow", iSTRnow);
	ParseInt(param, "STRchange", iSTRchange);
	ParseInt(param, "CONnow", iCONnow);
	ParseInt(param, "CONchange", iCONchange);
	ParseInt(param, "MENnow", iMENnow);
	ParseInt(param, "MENchange", iMENchange);
	ParseInt(param, "DEXnow", iDEXnow);
	ParseInt(param, "DEXchange", iDEXchange);
	ParseInt(param, "WITnow", iWITnow);
	ParseInt(param, "WITchange", iWITchange);


	m_iHennaID=iHennaID;		// ������ ����ų� �����Ҷ� �ʿ��ϹǷ� ID�� �����صӴϴ�

	if(m_iState==HENNA_EQUIP)
	{
		// ����
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfo", GetSystemString(638));			// "��������"
		class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconName", strDyeIconName);	// ���� Icon
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeName", strDyeName);						// �����̸�

		col.R=168;
		col.G=168;
		col.B=168;
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFee", GetSystemString(637) $ " : ");		// "������ : "
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFee", col);		

		strAdenaComma = MakeCostStringInt64(iFee);
		col= GetNumericColor(strAdenaComma);
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdena", strAdenaComma);		// ������ �Ƶ��� ����
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdena", col);

		col.R=255;
		col.G=255;
		col.B=0;
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaString", GetSystemString(469));		// "�Ƶ���"
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaString", col);		


		// ����
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfo", GetSystemString(639));		// "��������"
		class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconName", strTattooIconName);	// ���� Icon
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooName", strTattooName);		// �����̸�
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddName", strTattooAddName);		// ����ΰ�����
	}
	else if(m_iState==HENNA_UNEQUIP)
	{
		// ����
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfoUnEquip", GetSystemString(639));		// "��������"
		class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconNameUnEquip", strTattooIconName);	// ���� Icon
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooNameUnEquip", GetSystemString(652)$":"$strTattooName);		// �����̸�
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddNameUnEquip", strTattooAddName);		// ����ΰ�����

		// ����
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfoUnEquip", GetSystemString(638));			// "��������"
		class'UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconNameUnEquip", strDyeIconName);	// ���� Icon
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeNameUnEquip", strDyeName);						// �����̸�

		col.R=168;
		col.G=168;
		col.B=168;
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFeeUnEquip", GetSystemString(637) $ " : ");		// "������ : "
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFeeUnEquip", col);		

		strAdenaComma = MakeCostStringInt64(iFee);
		col= GetNumericColor(strAdenaComma);
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaUnEquip", strAdenaComma);		// ������ �Ƶ��� ����
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaUnEquip", col);

		col.R=255;
		col.G=255;
		col.B=0;
		class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaStringUnEquip", GetSystemString(469));		// "�Ƶ���"
		class'UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaStringUnEquip", col);		
	}

	


	// ��ġ��ȭ
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRBefore", iSTRnow);		// STR ����
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRAfter", iSTRchange);		// STR ��ȭ��
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXBefore", iDEXnow);		// DEX ����
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXAfter", iDEXchange);		// DEX ��ȭ��
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONBefore", iCONnow);		// CON ����
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONAfter", iCONchange);		// CON ��ȭ��
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTBefore", iINTnow);		// INT ����
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTAfter", iINTchange);		// INT ��ȭ��
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITBefore", iWITnow);		// WIT ����
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITAfter", iWITchange);		// WIT ��ȭ��
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENBefore", iMENnow);		// MEN ����
	class'UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENAfter", iMENchange);		// MEN ��ȭ��

	//�Ƶ���(,)
	strAdenaComma = MakeCostStringInt64((iAdena));
	col = GetNumericColor(strAdenaComma);
	class'UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtHaveAdena", strAdenaComma);		// �Ƶ��� ����
	class'UIAPI_TEXTBOX'.static.SetTooltipString("HennaInfoWnd.txtHaveAdena", ConvertNumToText(Int64ToString(iAdena)));

	class'UIAPI_WINDOW'.static.HideWindow("HennaListWnd");

	class'UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd");
	class'UIAPI_WINDOW'.static.SetFocus("HennaInfoWnd");
}
defaultproperties
{
}
