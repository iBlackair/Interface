class HennaListWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// CONST
//////////////////////////////////////////////////////////////////////////////
//const FEE_OFFSET_Y_EQUIP = -13;
//const FEE_OFFSET_Y_UNEQUIP = -12;
const FEE_OFFSET_Y_EQUIP = -23;
const FEE_OFFSET_Y_UNEQUIP = -21;

// ���� ����� �������� ����
const HENNA_EQUIP=1;		// ��������
const HENNA_UNEQUIP=2;		// ���������

var int m_iState;
var int m_iRootNameLength;
var bool m_bDrawBg;

function OnRegisterEvent()
{
	RegisterEvent( EV_HennaListWndShowHideEquip );
	RegisterEvent( EV_HennaListWndAddHennaEquip );

	RegisterEvent( EV_HennaListWndShowHideUnEquip );
	RegisterEvent( EV_HennaListWndAddHennaUnEquip );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_bDrawBg = true;
}

function OnClickButton( string strID )
{
	local string strHennaID;
	
	switch( strID )
	{
	default:
		strHennaID = Mid(strID, m_iRootNameLength+1);

		if(m_iState==HENNA_EQUIP)
			RequestHennaItemInfo(int(strHennaID));
		else if(m_iState==HENNA_UNEQUIP)
			RequestHennaUnequipInfo(int(strHennaID));
		break;
	}
}

// Ʈ�� ����
function Clear()
{
	class'UIAPI_TREECTRL'.static.Clear("HennaListWnd.HennaListTree");
}

function OnEvent(int Event_ID, string param)
{
	local INT64 iAdena;
	
	local string strName;
	local string strIconName;
	local string strDescription;
	local int iHennaID;
	local int iClassID;
	local INT64 iNum;
	local INT64 iFee;

	switch(Event_ID)
	{
	case EV_HennaListWndShowHideEquip :
		m_iState=HENNA_EQUIP;
		Clear();
		ParseINT64(param, "Adena", iAdena);
		ShowHennaListWnd(iAdena);
		break;

	case EV_HennaListWndAddHennaEquip :
	case EV_HennaListWndAddHennaUnEquip :
		ParseString(param, "Name", strName);				//�̸�
		ParseString(param, "Description", strDescription);	// ������ �ʿ������ ������
		ParseString(param, "IconName", strIconName);		// IconName;
		ParseInt(param, "HennaID", iHennaID);				// �ʿ����
		ParseInt(param, "ClassID", iClassID);				// �ʿ����
		ParseINT64(param, "NumOfItem", iNum);					// ���� - �ʿ����
		ParseINT64(param, "Fee", iFee);						// ���

		AddHennaListItem(strName, strIconName, strDescription, iFee, iHennaID);
		break;

	case EV_HennaListWndShowHideUnEquip :
		m_iState=HENNA_UNEQUIP;
		Clear();
		ParseINT64(param, "Adena", iAdena);
		ShowHennaListWnd(iAdena);
		break;
	}
}

// ���� ����� ������� �ʱ�ȭ ��Ŵ
function ShowHennaListWnd(INT64 iAdena)
{
	local XMLTreeNodeInfo	infNode;
	local string strTmp;

	if(m_iState==HENNA_EQUIP)		// �������� �����ϰ��
	{
		// Ÿ��Ʋ ����
		class'UIAPI_WINDOW'.static.SetWindowTitleByText("HennaListWnd", GetSystemString(651));
		// Ÿ��Ʋ �Ʒ� ���� ���� - ������
		class'UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtList", GetSystemString(659));
	}
	else if(m_iState==HENNA_UNEQUIP)	// ���� ����� ������ ���
	{
		// Ÿ��Ʋ - "���������"
		class'UIAPI_WINDOW'.static.SetWindowTitleByText("HennaListWnd", GetSystemString(652));
		// Ÿ��Ʋ �Ʒ� ���� ���� - "������"
		class'UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtList", GetSystemString(660));
	}

	//���� �Ƶ��� 
	class'UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtAdena", MakeCostString(Int64ToString(iAdena)));
	class'UIAPI_TEXTBOX'.static.SetTooltipString("HennaListWnd.txtAdena", ConvertNumToText(Int64ToString(iAdena)));


	//Ʈ���� Root�߰�
	infNode.strName = "HennaListRoot";
	infNode.nOffSetX = 0;
	infNode.nOffSetY = -3;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("HennaListWnd.HennaListTree", "", infNode);
	if (Len(strTmp) < 1)
	{
		//debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}

	m_iRootNameLength=Len(infNOde.strName);

	ShowWindow("HennaListWnd");
	class'UIAPI_WINDOW'.static.SetFocus("HennaListWnd");
}

// ���� �߰�
function AddHennaListItem(string strName, string strIconName, string strDescription, INT64 iFee, int iHennaID)
{
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;

	local string strRetName;
	local string strAdenaComma;


//	debug("AddHennaListItem:"$strName$", "$strIconName$", "$iFee);

	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - with No Button
	infNode = infNodeClear;
	infNode.strName = "" $ iHennaID;
	infNode.bShowButton = 0;
	
	//Tooltip - �ϴ� ����
//	infNode.Tooltip.infItem.Name = strName;
//	infNode.Tooltip.infItem.Description = strDescription;
//	infNode.Tooltip.infItem.Price = MakingFee;
//	infNode.Tooltip.nStyle1 = 2;	//TTS_INVENTORY
//	infNode.Tooltip.nStyle2 = 4;	//TTES_SHOW_PRICE1
	
	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
	infNode.nTexExpandedOffSetX = -7;		//OffSet
	infNode.nTexExpandedOffSetY = 8;		//OffSet
	infNode.nTexExpandedHeight = 46;		//Height
	infNode.nTexExpandedRightWidth = 0;		//������ �׶��̼Ǻκ��� ����
	infNode.nTexExpandedLeftUWidth = 32; 		//��Ʈ��ġ�� �׸� ���� �ؽ����� UVũ��
	infNode.nTexExpandedLeftUHeight = 40;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("HennaListWnd.HennaListTree", "HennaListRoot", infNode);
	if (Len(strRetName) < 1)
	{
		//debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	if (m_bDrawBg == true)
	{
		//Insert Node Item - ������ ���?
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureUHeight = 14;
		infNodeItem.u_nTextureWidth = 257;
		infNodeItem.u_nTextureHeight = 53;
		infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
		m_bDrawBg = false;
	}
	else
	{
		//Insert Node Item - ������ ���?
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 257;
		infNodeItem.u_nTextureHeight = 53;
		infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
		m_bDrawBg = true;	
	}
		
	
	//Insert Node Item - �����۽��� ���
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -250;
	infNodeItem.nOffSetY = 10;
	infNodeItem.u_nTextureWidth = 36;
	infNodeItem.u_nTextureHeight = 36;

	infNodeItem.u_strTexture ="L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
	class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);

	//Insert Node Item - ������ ������
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -34;
	infNodeItem.nOffSetY = 11;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strIconName;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);

	//Insert Node Item - ������ �̸�
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strName;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;

	if(m_iState==HENNA_EQUIP)
		infNodeItem.nOffSetY = 13;
	else if(m_iState==HENNA_UNEQUIP)
		infNodeItem.nOffSetY = 6;

	class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);


	if(m_iState==HENNA_UNEQUIP)
	{
		//Insert Node Item - ���� �ΰ�����
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = strDescription;
		infNodeItem.bLineBreak = true;
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 47;
		infNodeItem.nOffSetY = -34;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
	}

	//Insert Node Item - "������"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(637) $ " : ";
	infNodeItem.bLineBreak = true;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 46;

	if(m_iState==HENNA_EQUIP)
		infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
	else if(m_iState==HENNA_UNEQUIP)
		infNodeItem.nOffSetY = FEE_OFFSET_Y_UNEQUIP;

	infNodeItem.t_color.R = 168;
	infNodeItem.t_color.G = 168;
	infNodeItem.t_color.B = 168;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);

	//�Ƶ���(,)
	strAdenaComma = MakeCostString(Int64ToString(iFee));
	
	//Insert Node Item - "���ۺ�(�Ƶ���)"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strAdenaComma;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 0;

	if(m_iState==HENNA_EQUIP)
		infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
	else if(m_iState==HENNA_UNEQUIP)
		infNodeItem.nOffSetY = FEE_OFFSET_Y_UNEQUIP;

	infNodeItem.t_color = GetNumericColor(strAdenaComma);
	class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);

	//Insert Node Item - "�Ƶ���"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(469);
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;

	if(m_iState==HENNA_EQUIP)
		infNodeItem.nOffSetY = FEE_OFFSET_Y_EQUIP;
	else if(m_iState==HENNA_UNEQUIP)
		infNodeItem.nOffSetY = FEE_OFFSET_Y_UNEQUIP;

	infNodeItem.t_color.R = 255;
	infNodeItem.t_color.G = 255;
	infNodeItem.t_color.B = 0;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
}
defaultproperties
{
}
