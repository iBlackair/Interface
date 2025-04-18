class RecipeBuyListWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// RECIPE CONST
//////////////////////////////////////////////////////////////////////////////
const RECIPEWND_MAX_MP_WIDTH = 165.0f;

var int		m_MerchantID;	//�Ǹ����� ServerID
var int		m_MaxMP;

var BarHandle MPBar;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeShowBuyListWnd );
	RegisterEvent( EV_RecipeShopSellItem );
	RegisterEvent( EV_UpdateMP );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		MPBar = BarHandle( GetHandle( "RecipeBuyListWnd.barMp" ) );
	}
	else
	{
		MPBar = GetBarHandle( "RecipeBuyListWnd.barMp" );
	}

	//���� �Ƶ��� = 0
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyListWnd.txtAdena", "0");
}

function OnEvent(int Event_ID, string param)
{
	local Rect 	rectWnd;
	local int		ServerID;
	local int		MPValue;

	// 2006/07/10 NeverDie
	local int CurrentMP;
	local int MaxMP;
	local INT64 Adena;
	local int RecipeID;
	local int CanbeMade;
	local INT64 MakingFee;

	if (Event_ID == EV_RecipeShowBuyListWnd)
	{
		Clear();
		
		//�������� ��ġ�� RecipeBuyManufactureWnd�� ����
		rectWnd = class'UIAPI_WINDOW'.static.GetRect("RecipeBuyManufactureWnd");
		class'UIAPI_WINDOW'.static.MoveTo("RecipeBuyListWnd", rectWnd.nX, rectWnd.nY);
		
		ParseInt( param, "ServerID", ServerID);
		ParseInt( param, "CurrentMP", CurrentMP);
		ParseInt( param, "MaxMP", MaxMP);
		ParseInt64( param, "Adena", Adena);
		ReceiveRecipeShopSellList( ServerID, CurrentMP, MaxMP, Adena );
		
		class'UIAPI_WINDOW'.static.ShowWindow("RecipeBuyListWnd");
		class'UIAPI_WINDOW'.static.SetFocus("RecipeBuyListWnd");
	}
	else if (Event_ID == EV_RecipeShopSellItem)
	{
		ParseInt( param, "RecipeID", RecipeID);
		ParseInt( param, "CanbeMade", CanbeMade);
		ParseInt64( param, "MakingFee", MakingFee);
		AddRecipeShopSellItem( RecipeID, CanbeMade, MakingFee );
	}
	else if (Event_ID == EV_UpdateMP)
	{
		ParseInt( param, "ServerID", ServerID );
		ParseInt( param, "CurrentMP", MPValue );
		if (m_MerchantID==ServerID && m_MerchantID>0)
			SetMPBar(MPValue);
	}
}

function OnClickButton( string strID )
{
	local string strRecipeID;
	
	switch( strID )
	{
	case "btnClose":
		CloseWindow();
		break;
	default:
		strRecipeID = Mid(strID, 5);
		class'RecipeAPI'.static.RequestRecipeShopMakeInfo(m_MerchantID, int(strRecipeID));
		break;
	}
}

//������ �ݱ�
function CloseWindow()
{
	Clear();
	class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyListWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//�ʱ�ȭ
function Clear()
{
	m_MerchantID = 0;
	m_MaxMP = 0;
	class'UIAPI_TREECTRL'.static.Clear("RecipeBuyListWnd.MainTree");
}

//�⺻���� ����
function ReceiveRecipeShopSellList(int ServerID, int CurrentMP, int MaxMP, INT64 Adena)
{
	local string		strTmp;
	local XMLTreeNodeInfo	infNode;
	
	m_MerchantID = ServerID;
	m_MaxMP = MaxMP;
	
	//������ Ÿ��Ʋ ����
	strTmp = GetSystemString(663) $ " - " $ class'UIDATA_USER'.static.GetUserName(ServerID);
	class'UIAPI_WINDOW'.static.SetWindowTitleByText("RecipeBuyListWnd", strTmp);
	
	//MP�� ǥ��
	SetMPBar(CurrentMP);
	
	//���� �Ƶ��� = 0
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyListWnd.txtAdena", MakeCostStringInt64(Adena));
	class'UIAPI_TEXTBOX'.static.SetTooltipString("RecipeBuyListWnd.txtAdena", ConvertNumToText(Int64ToString(Adena)));
	
	//Ʈ���� Root�߰�
	infNode.strName = "root";
	infNode.nOffSetX = 7;
	infNode.nOffSetY = 7;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("RecipeBuyListWnd.MainTree", "", infNode);
	if (Len(strTmp) < 1)
	{
		//debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}
}

//MP Bar
function SetMPBar(int CurrentMP)
{
	/*
	local int	nTmp;
	local int	nMPWidth;
	
	nTmp = RECIPEWND_MAX_MP_WIDTH * CurrentMP;
	nMPWidth = nTmp / m_MaxMP;
	if (nMPWidth>RECIPEWND_MAX_MP_WIDTH)
	{
		nMPWidth = RECIPEWND_MAX_MP_WIDTH;
	}
	class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyListWnd.texMPBar", nMPWidth, 12);
	*/
	debug("MP" $m_MaxMP $" " $CurrentMP);
	MPBar.SetValue(m_MaxMP , CurrentMP);
}

//������ ����Ʈ �߰�
function AddRecipeShopSellItem(int RecipeID, int CanbeMade, INT64 MakingFee)
{
	local string	strTmp;

	local XMLTreeNodeInfo		infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo		infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	local string	strRetName;
	
	//For Recipe
	local int		ProductID;
	local string	AdenaComma;
	local string	strName;
	local string	strDescription;
	
	local ItemID	cID;
	
	//������ Product ID
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	cID = GetItemID(ProductID);
	
	//������ �̸�
	strName = class'UIDATA_ITEM'.static.GetItemName(cID);
	
	//������ ����
	strDescription = class'UIDATA_ITEM'.static.GetItemDescription(cID);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - with No Button
	infNode = infNodeClear;
	infNode.strName = "" $ RecipeID;
	infNode.bShowButton = 0;
	
	//Tooltip
	infNode.Tooltip = SetTooltip(strName, strDescription, MakingFee);
	infNode.bFollowCursor = true;
	
	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
	infNode.nTexExpandedOffSetX = -7;		//OffSet
	infNode.nTexExpandedOffSetY = -3;		//OffSet
	infNode.nTexExpandedHeight = 46;		//Height
	infNode.nTexExpandedRightWidth = 0;		//������ �׶��̼Ǻκ��� ����
	infNode.nTexExpandedLeftUWidth = 32; 		//��Ʈ��ġ�� �׸� ���� �ؽ����� UVũ��
	infNode.nTexExpandedLeftUHeight = 40;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("RecipeBuyListWnd.MainTree", "root", infNode);
	if (Len(strRetName) < 1)
	{
		//Log("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	//Node Tooltip Clear
	infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
	
	//������ �̸�
	strTmp = class'UIDATA_ITEM'.static.GetItemTextureName(cID);
	if (Len(strTmp)<1)
	{
		strTmp = "Default.BlackTexture";
	}
	
	//Insert Node Item - ������ ������
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = 4;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strTmp;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - ������ �̸�
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strName;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 10;
	infNodeItem.nOffSetY = 0;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "���ۺ�"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(641);
	infNodeItem.bLineBreak = true;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 42;
	infNodeItem.nOffSetY = -22;
	infNodeItem.t_color.R = 168;
	infNodeItem.t_color.G = 168;
	infNodeItem.t_color.B = 168;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - " : "
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = " : ";
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = -22;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//�Ƶ���(,)
	AdenaComma = MakeCostStringInt64(MakingFee);
	
	//Insert Node Item - "���ۺ�(�Ƶ���)"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = AdenaComma;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = -22;
	infNodeItem.t_color = GetNumericColor(AdenaComma);
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "�Ƶ���"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(469);
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = -22;
	infNodeItem.t_color.R = 255;
	infNodeItem.t_color.G = 255;
	infNodeItem.t_color.B = 0;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "����Ȯ��"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(642);
	infNodeItem.bLineBreak = true;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 42;
	infNodeItem.nOffSetY = -8;
	infNodeItem.t_color.R = 168;
	infNodeItem.t_color.G = 168;
	infNodeItem.t_color.B = 168;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - " : "
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = " : ";
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = -8;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "�ۼ�Ʈ"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID) $ "%";
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = -8;
	infNodeItem.t_color.R = 176;
	infNodeItem.t_color.G = 155;
	infNodeItem.t_color.B = 121;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.bStopMouseFocus = true;
	infNodeItem.b_nHeight = 10;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
}

function CustomTooltip SetTooltip(string Name, string Description, INT64 MakingFee)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	local DrawItemInfo infoClear;
	
	local string AdenaComma;
	
	//�Ƶ���(,)
	AdenaComma = MakeCostStringInt64(MakingFee);
	
	Tooltip.DrawList.Length = 4;
	
	//�̸�
	info = infoClear;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_strText = Name;
	Tooltip.DrawList[0] = info;
	
	//����	
	info = infoClear;
	info.eType = DIT_TEXT;
	info.nOffSetY = 6;
	info.bLineBreak = true;
	info.t_bDrawOneLine = true;
	info.t_color.R = 163;
	info.t_color.G = 163;
	info.t_color.B = 163;
	info.t_color.A = 255;
	info.t_strText = GetSystemString(322) $ " : ";
	Tooltip.DrawList[1] = info;
	
	//�Ƶ���
	info = infoClear;
	info.eType = DIT_TEXT;
	info.nOffSetY = 6;
	info.t_bDrawOneLine = true;
	info.t_color = GetNumericColor(AdenaComma);
	info.t_strText = AdenaComma $ " " $ GetSystemString(469);
	Tooltip.DrawList[2] = info;
	
	//�о��ֱ� ��Ʈ��
	info = infoClear;
	info.eType = DIT_TEXT;
	info.nOffSetY = 6;
	info.bLineBreak = true;
	info.t_bDrawOneLine = true;
	info.t_color = GetNumericColor(AdenaComma);
	info.t_strText = "(" $ ConvertNumToText(Int64ToString(MakingFee)) $ ")";
	Tooltip.DrawList[3] = info;

	return Tooltip;
}
defaultproperties
{
}
