class RecipeBuyManufactureWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// RECIPE CONST
//////////////////////////////////////////////////////////////////////////////
const RECIPEWND_MAX_MP_WIDTH = 165.0f;

const CRYSTAL_TYPE_WIDTH = 14;
const CRYSTAL_TYPE_HEIGHT = 14;

var int		m_MerchantID;	//�Ǹ����� ServerID
var int		m_RecipeID;	//RecipeID
var int		m_SuccessRate;	//������
var INT64	m_Adena;		//�Ƶ���
var int		m_MaxMP;

var BarHandle MPBar;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeShopItemInfo );
	RegisterEvent( EV_UpdateMP );
	
	RegisterEvent( EV_InventoryAddItem );
	RegisterEvent( EV_InventoryUpdateItem );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		MPBar = BarHandle( GetHandle( "RecipeBuyManufactureWnd.barMp" ) );
	}
	else
	{
		MPBar = GetBarHandle( "RecipeBuyManufactureWnd.barMp" );
	}
}

function OnEvent(int Event_ID, string param)
{
	local Rect 	rectWnd;
	local int		ServerID;
	local int		MPValue;

	// 2006/07/10 NeverDie
	local int		MerchantID;
	local int		RecipeID;
	local int		CurrentMP;
	local int		MaxMP;
	local int		MakingResult;
	local INT64		Adena;
	
	if (Event_ID == EV_RecipeShopItemInfo)
	{
		class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyListWnd");
		
		Clear();
		
		//�������� ��ġ�� RecipeBuyListWnd�� ����
		rectWnd = class'UIAPI_WINDOW'.static.GetRect("RecipeBuyListWnd");
		class'UIAPI_WINDOW'.static.MoveTo("RecipeBuyManufactureWnd", rectWnd.nX, rectWnd.nY);
		
		//show
		class'UIAPI_WINDOW'.static.ShowWindow("RecipeBuyManufactureWnd");
		class'UIAPI_WINDOW'.static.SetFocus("RecipeBuyManufactureWnd");
		
		ParseInt( param, "MerchantID", MerchantID );
		ParseInt( param, "RecipeID", RecipeID );
		ParseInt( param, "CurrentMP", CurrentMP );
		ParseInt( param, "MaxMP", MaxMP );
		ParseInt( param, "MakingResult", MakingResult );
		ParseINT64( param, "Adena", Adena );
//		debug("MP" $CurrentMP $"  " $MaxMP);
		ReceiveRecipeShopSellList( MerchantID, RecipeID, CurrentMP, MaxMP, MakingResult, Adena );
	}
	else if (Event_ID == EV_UpdateMP)
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentMP", MPValue );
		if (m_MerchantID==ServerID && m_MerchantID>0)
		{
			SetMPBar(MPValue);
		}
	}
	else if( Event_ID == EV_InventoryAddItem || Event_ID == EV_InventoryUpdateItem )
	{
		HandleInventoryItem(param);
	}
}

function OnClickButton( string strID )
{
	local string param;
	
	switch( strID )
	{
	case "btnClose":
		CloseWindow();
		break;
	case "btnPrev":
		//RecipeBuyListWnd�� ���ư�
		class'RecipeAPI'.static.RequestRecipeShopSellList(m_MerchantID);
		
		CloseWindow();
		break;
	case "btnRecipeTree":
		if (class'UIAPI_WINDOW'.static.IsShowWindow("RecipeTreeWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");	
		}
		else
		{
			ParamAdd(param, "RecipeID", string(m_RecipeID));
			ParamAdd(param, "SuccessRate", string(m_SuccessRate));
			ExecuteEvent( EV_RecipeShowRecipeTreeWnd, param);
		}
		break;
	case "btnManufacture":
		class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
		break;
	}
}

//������ �ݱ�
function CloseWindow()
{
	Clear();
	class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyManufactureWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//�ʱ�ȭ
function Clear()
{
	m_MerchantID = 0;
	m_RecipeID = 0;
	m_SuccessRate = 0;
	m_Adena = IntToInt64(0);
	m_MaxMP = 0;
	class'UIAPI_ITEMWINDOW'.static.Clear("RecipeBuyManufactureWnd.ItemWnd");
}

//�⺻���� ����
function ReceiveRecipeShopSellList(int MerchantID,int RecipeID,int CurrentMP,int MaxMP,int MakingResult,INT64 Adena)
{
	local int			i;
	
	local string		strTmp;
	local int			nTmp;
	local int			nTmp2;
	
	local int			ProductID;
	local int			ProductNum;
	local string		ItemName;
	
	local string		param;
	local ItemInfo		infItem;
	
	//�������� ����
	m_MerchantID = MerchantID;
	m_RecipeID = RecipeID;
	m_SuccessRate = class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
	m_Adena = Adena;
	m_MaxMP = MaxMP;
	
	//������ Ÿ��Ʋ ����
	strTmp = GetSystemString(663) $ " - " $ class'UIDATA_USER'.static.GetUserName(MerchantID);
	class'UIAPI_WINDOW'.static.SetWindowTitleByText("RecipeBuyManufactureWnd", strTmp);
	
	//Product ID
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	//(������)�ؽ���
	strTmp = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeBuyManufactureWnd.texItem", strTmp);
	
	//������ �̸�
	ItemName = MakeFullItemName(ProductID);
	
	//Crystal Type(Grade Emoticon���)
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	strTmp = GetItemGradeTextureName(nTmp);
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeBuyManufactureWnd.texGrade", strTmp);
	if(nTmp == 6) // s80 �������ϰ�� �ؽ��� ����� �÷���
	{
		class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyManufactureWnd.texGrade",CRYSTAL_TYPE_WIDTH * 2, CRYSTAL_TYPE_HEIGHT);
	}
	else	//�������� ���� �������
	{
		class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyManufactureWnd.texGrade",CRYSTAL_TYPE_WIDTH, CRYSTAL_TYPE_HEIGHT);
	}
	
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtName", ItemName);
	
	//MP�Һ�
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMPConsume", "" $ nTmp);
	
	//����Ȯ��
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtSuccessRate", m_SuccessRate $ "%");
	
	//�������
	ProductNum = class'UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtResultValue", "" $ ProductNum);
	
	//MP�� ǥ��
	//debug("CurrentMP" $CurrentMP);
	SetMPBar(CurrentMP);
	
	//��������
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtCountValue", "" $ Int64ToString(GetInventoryItemCount(GetItemID(ProductID))));
	
	//���۰��
	strTmp = "";
	if (MakingResult == 0)
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(960), ItemName, "");
	}
	else if (MakingResult == 1)
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(959), ItemName, "" $ ProductNum);
	}
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", strTmp);
	
	//ItemWnd�� �߰�
	param = class'UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
	ParseInt(param, "Count", nTmp);
	for (i=0; i<nTmp; i++)
	{
		//Set ItemID
		ParseInt(param, "ID_" $ i, nTmp2);
		infItem.ID = GetItemID(nTmp2);
		
		//NeedNum
		ParseINT64(param, "NeededNum_" $ i, infItem.Reserved64);
		infItem.Name = class'UIDATA_ITEM'.static.GetItemName(infItem.ID);
		infItem.AdditionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName(infItem.ID);
		infItem.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(infItem.ID);
		infItem.Description = class'UIDATA_ITEM'.static.GetItemDescription(infItem.ID);
		infItem.ItemNum = GetInventoryItemCount(infItem.ID);
		if (infItem.Reserved64>infItem.ItemNum)
			infItem.bDisabled = true;
		else
			infItem.bDisabled = false;
		class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeBuyManufactureWnd.ItemWnd", infItem);
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
	class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyManufactureWnd.texMPBar", nMPWidth, 12);
	*/
//	debug("MP STATUS" $m_MaxMP $" " $CurrentMP);
	MPBar.SetValue(m_MaxMP , CurrentMP);
}

//�κ��������� ������Ʈ�Ǹ� �������� ���纸������ �ٲ��ش�
function HandleInventoryItem(string param)
{
	local ItemID cID;
	local int idx;
	local ItemInfo infItem;
	
	if (ParseItemID(param, cID))
	{
		idx = class'UIAPI_ITEMWINDOW'.static.FindItem( "RecipeBuyManufactureWnd.ItemWnd", cID);
		if (idx>-1)
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeBuyManufactureWnd.ItemWnd", idx, infItem);
			infItem.ItemNum = GetInventoryItemCount(infItem.ID);
			if (infItem.Reserved64>infItem.ItemNum)
				infItem.bDisabled = true;
			else
				infItem.bDisabled = false;
			class'UIAPI_ITEMWINDOW'.static.SetItem( "RecipeBuyManufactureWnd.ItemWnd", idx, infItem);
		}
	}
}
defaultproperties
{
}
