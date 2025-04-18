class SkillTrainListWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// CONST
//////////////////////////////////////////////////////////////////////////////
const OFFSET_X_ICON_TEXTURE=0;
const OFFSET_Y_ICON_TEXTURE=4;
const OFFSET_Y_SECONDLINE = -17;

var int m_iType;

var int m_iState;
var int m_iRootNameLength;
var bool m_bDrawBg;
var WindowHandle	m_SkillTrainListWnd;

function OnRegisterEvent()
{
	RegisterEvent( EV_SkillTrainListWndShow );
	RegisterEvent( EV_SkillTrainListWndHide );
	RegisterEvent( EV_SkillTrainListWndAddSkill );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		m_SkillTrainListWnd= GetHandle("SkillTrainListWnd.SkillTrainListTree");
	else
		m_SkillTrainListWnd= GetWindowHandle("SkillTrainListWnd.SkillTrainListTree");
}

function OnClickButton( string strItemID )
{
	local string strID_Level;
	local string strID;
	local string strLevel;
	local int iID;
	local int iLevel;
	local int iIdxComma;
	local int iLength;

	iID = 0;
	iLevel = 0;

	strID_Level = Mid(strItemID, m_iRootNameLength+1);
	iLength=Len(strID_Level);
//	debug("����:"$strTemp$", ����:"$iLength);
	iIdxComma=InStr(strID_Level, ",");

	strID=Left(strID_Level, iIdxComma);
	strLevel=Right(strID_Level, iLength-iIdxComma-1);

//	debug("iIdxComma:"$iIdxComma$", iLength-iIdxComma:"$(iLength-iIdxComma));
//	debug("ID:"$int(strID)$", Level:"$int(strLevel));

	iID=int(strID);
	iLevel=int(strLevel);

//#ifdef CT26P3
	// TTP #42253 X��ư�� ������ ������ SkillInfo�� ������ ��û���� �ʵ��� ���� - gorillazin
	if (iID > 0 && iLevel > 0)
	{
		//switch(m_iType)
		//{
		//case ESTT_NORMAL :
		//case ESTT_FISHING :
		//case ESTT_CLAN :
			RequestAcquireSkillInfo(iID, iLevel, m_iType);
		//	break;
		//default:
		//	break;
		//}
	}
//#else
//	RequestAcquireSkillInfo(iID, iLevel, m_iType);
//endif //CT26P3 - gorillazin
	
	HideWindow("SkillTrainListWnd");
	m_SkillTrainListWnd.SetScrollPosition(0); // ��ũ�ѹ� �ʱ�ȭ
	
	m_bDrawBg = true;
}

// Ʈ�� ����
function Clear()
{
	class'UIAPI_TREECTRL'.static.Clear("SkillTrainListWnd.SkillTrainListTree");
}

function OnEvent(int Event_ID, string param)
{
	local int iType;

	local string strIconName;
	local string strName;
	local int iID;
	local int iLevel;
	local int iSPConsume;

	local string strEnchantName;

	switch(Event_ID)
	{
	case EV_SkillTrainListWndShow :
		ParseInt(param, "Type"	, iType);
		Clear();
		m_iType=iType;

		if(IsShowWindow("SkillTrainInfoWnd"))
			HideWindow("SkillTrainInfoWnd");

		ShowSkillTrainListWnd(iType);
		break;

	case EV_SkillTrainListWndAddSkill :
		ParseString(param, "strIconName", strIconName); 
		ParseString(param, "strName", strName);
		ParseInt(param, "iID", iID);
		ParseInt(param, "iLevel", iLevel);
		ParseInt(param, "iSPConsume", iSPConsume);
		ParseString(param, "strEnchantName", strEnchantName);

		AddSkillTrainListItem(strIconName, strName, iID, iLevel, iSPConsume, strEnchantName);
		break;

	case EV_SkillTrainListWndHide :
		if(IsShowWindow("SkillTrainListWnd"))
			HideWindow("SkillTrainListWnd");
		break;
	}
}

function OnShow()
{
	ShowWindow("SkillTrainListWnd.txtSPString");
	ShowWindow("SkillTrainListWnd.txtSP");
}

// ��ų Ʈ���̴� ������ �ʱ�ȭ ��Ŵ
function ShowSkillTrainListWnd(int iType)
{
	local XMLTreeNodeInfo	infNode;
	local string strTmp;
	local int iWindowTitle;
	local int iSPIdx;

	local UserInfo infoPlayer;
	local int iPlayerSP;

	GetPlayerInfo(infoPlayer);

	switch(m_iType)
	{
	case ESTT_CLAN :
	case ESTT_SUB_CLAN:
		iWindowTitle=1436;
		iSPIdx=1372;
		iPlayerSP=GetClanNameValue(infoPlayer.nClanID);
		break;
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	//case 4:
	//case 5:
	default:
		iWindowTitle=477;
		iSPIdx=92;
		iPlayerSP=infoPlayer.nSP;
		break;

	}

	class'UIAPI_WINDOW'.static.SetWindowTitle("SkillTrainListWnd", iWindowTitle);					// ���� Ÿ��Ʋ ����
		
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainListWnd.txtSPString", GetSystemString(iSPIdx));	// SP or ���͸�ġ �۾�
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainListWnd.txtSP", iPlayerSP);						// SP or ���͸�ġ

	//Ʈ���� Root�߰�
	infNode.strName = "SkillTrainListRoot";
	infNode.nOffSetX = 7;
	infNode.nOffSetY = 0;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("SkillTrainListWnd.SkillTrainListTree", "", infNode);
	if (Len(strTmp) < 1)
	{
		//debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}

	m_iRootNameLength=Len(infNode.strName);

	class'UIAPI_WINDOW'.static.ShowWindow("SkillTrainListWnd");
	class'UIAPI_WINDOW'.static.SetFocus("SkillTrainListWnd");
}

function AddSkillTrainListItem(string strIconName, string strName, int iID, int iLevel, int iSPConsume, string strEnchantName)
{
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;

	local string strRetName;

	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - with No Button
	infNode = infNodeClear;
	infNode.strName = ""$ iID $","$ iLevel;
	infNode.bShowButton = 0;

	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
	infNode.nTexExpandedOffSetX = -7;		//OffSet
	infNode.nTexExpandedOffSetY = 0;		//OffSet
	infNode.nTexExpandedHeight = 38;		//Height
	infNode.nTexExpandedRightWidth = 0;		//������ �׶��̼Ǻκ��� ����
	infNode.nTexExpandedLeftUWidth = 32; 		//��Ʈ��ġ�� �׸� ���� �ؽ����� UVũ��
	infNode.nTexExpandedLeftUHeight = 38;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";


	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SkillTrainListWnd.SkillTrainListTree", "SkillTrainListRoot", infNode);
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
		infNodeItem.u_nTextureHeight = 38;
		infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SkillTrainListWnd.SkillTrainListTree", strRetName, infNodeItem);
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
		infNodeItem.u_nTextureHeight = 38;
		infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SkillTrainListWnd.SkillTrainListTree", strRetName, infNodeItem);
		m_bDrawBg = true;	
	}

	/*
	//Insert Node Item - ������ ������ �׵θ� ���� �ؽ���
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = OFFSET_X_ICON_TEXTURE;
	infNodeItem.nOffSetY = OFFSET_Y_ICON_TEXTURE;
	infNodeItem.u_nTextureWidth = ;		//-4
	infNodeItem.u_nTextureHeight = 34;
	infNodeItem.u_strTexture = "l2ui_ch3.InventoryWnd.Inventory_OutLine";

	InsertNodeItem(strRetName, infNodeItem);

	//Insert Node Item - ������ ������ �׵θ� �Ʒ��� �ؽ���
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -33;
	infNodeItem.nOffSetY = OFFSET_Y_ICON_TEXTURE;
	infNodeItem.u_nTextureWidth = 35;
	infNodeItem.u_nTextureHeight = 35;
	infNodeItem.u_strTexture = "l2ui_ch3.InventoryWnd.Inventory_OutLine";

	InsertNodeItem(strRetName, infNodeItem);
	*/
	
	//Insert Node Item - �����۽��� ���
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -251;		// -4 // -2
	infNodeItem.nOffSetY = 2;			// -2 // -1
	infNodeItem.u_nTextureWidth = 36;
	infNodeItem.u_nTextureHeight = 36;

	infNodeItem.u_strTexture ="L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
	InsertNodeItem( strRetName, infNodeItem);

	//Insert Node Item - ������ ������
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -34;
	infNodeItem.nOffSetY = OFFSET_Y_ICON_TEXTURE-1;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strIconName;

	InsertNodeItem(strRetName, infNodeItem);

	//Insert Node Item - ������ �̸�
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strName;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 5;

	InsertNodeItem(strRetName, infNodeItem);

	//switch(m_iType)
	//{
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	//case ESTT_CLAN :
		//Insert Node Item - "Lv"
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = GetSystemString(88);
		infNodeItem.bLineBreak = true;
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 46;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE ;

		infNodeItem.t_color.R = 163;
		infNodeItem.t_color.G = 163;
		infNodeItem.t_color.B = 163;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);

		//Insert Node Item - ����
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = string(iLevel);
		infNodeItem.nOffSetX = 2;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE;

		infNodeItem.t_color.R = 176;
		infNodeItem.t_color.G = 155;
		infNodeItem.t_color.B = 121;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);

		//Insert Node Item - "�ʿ�SP:"
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;

		switch(m_iType)
		{
		case ESTT_CLAN :
		case ESTT_SUB_CLAN:
			infNodeItem.t_strText = GetSystemString(1437)$" : ";
			break;
		//case ESTT_NORMAL :
		//case ESTT_FISHING :
		//case 4:
		default:
			infNodeItem.t_strText = GetSystemString(365)$" : ";
			break;
		}
		infNodeItem.bLineBreak = true;
		infNodeItem.nOffSetX = 83;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE;

		infNodeItem.t_color.R = 163;
		infNodeItem.t_color.G = 163;
		infNodeItem.t_color.B = 163;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);

		//Insert Node Item - �ʿ�SP
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = string(iSPConsume);
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = OFFSET_Y_SECONDLINE;

		infNodeItem.t_color.R = 176;
		infNodeItem.t_color.G = 155;
		infNodeItem.t_color.B = 121;
		infNodeItem.t_color.A = 255;
		InsertNodeItem(strRetName, infNodeItem);
	//	break;
	//default:
	//	break;
	//}
}

function InsertNodeItem(string strNodeName, XMLTreeNodeItemInfo infNodeItemName)
{
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SkillTrainListWnd.SkillTrainListTree", strNodeName, infNodeItemName);
}
defaultproperties
{
}
