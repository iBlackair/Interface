class ProductInventoryDrawerWnd extends UICommonAPI;

const DIALOGID_RECIEVE = 6460;

var WindowHandle Me;
var TextBoxHandle ProductInventoryDrawerWndTitle;
var TreeHandle ProductItemName;
var TreeHandle ProductItemInfo;
var TextureHandle ProductItem;

var TextBoxHandle ProductItemDetailListTitle;
var TextBoxHandle ProductItemDetailListCounter;
var TreeHandle ProductItemDetailList;
var TextureHandle ProductItemDetailListBg;
var TextBoxHandle PresentMessageTitle;
var TextBoxHandle SenderTitle;
var NameCtrlHandle Sender;
var TreeHandle ProductItemDetailList2;

var TextBoxHandle ProductBuyInfoTitle;
var TextBoxHandle ProductBuyInfo;

var ButtonHandle RecieveBtn;
var ButtonHandle CloseBtn;

var bool bDrawBgTree;

var int goodsCondition;

var ProductInventoryWnd ProductInventory;

//UI�� UC
var L2Util util;

var int SelectItemNum;

function OnRegisterEvent()
{
	RegisterEvent( EV_GoodsInventoryItemDesc );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "ProductInventoryDrawerWnd" );
	ProductInventoryDrawerWndTitle = GetTextBoxHandle( "ProductInventoryDrawerWnd.ProductInventoryDrawerWndTitle" );
	ProductItemName = GetTreeHandle( "ProductInventoryDrawerWnd.ProductItemName" );
	ProductItemInfo = GetTreeHandle( "ProductInventoryDrawerWnd.ProductItemInfo" );
	ProductItem = GetTextureHandle( "ProductInventoryDrawerWnd.ProductItem" );

	//ProductInfoBg = GetTextureHandle( "ProductInventoryDrawerWnd.ProductInfoBg" );
	ProductItemDetailListTitle = GetTextBoxHandle( "ProductInventoryDrawerWnd.ProductItemDetailListTitle" );
	ProductItemDetailListCounter = GetTextBoxHandle( "ProductInventoryDrawerWnd.ProductItemDetailListCounter" );
	ProductItemDetailList = GetTreeHandle( "ProductInventoryDrawerWnd.ProductItemDetailList" );

	PresentMessageTitle = GetTextBoxHandle( "ProductInventoryDrawerWnd.PresentMessageTitle" );
	SenderTitle = GetTextBoxHandle( "ProductInventoryDrawerWnd.SenderTitle" );
	Sender = GetNameCtrlHandle( "ProductInventoryDrawerWnd.Sender" );
	ProductItemDetailList2 = GetTreeHandle( "ProductInventoryDrawerWnd.ProductItemDetailList2" );

	ProductBuyInfoTitle = GetTextBoxHandle( "ProductInventoryDrawerWnd.ProductBuyInfoTitle" );
	ProductBuyInfo = GetTextBoxHandle( "ProductInventoryDrawerWnd.ProductBuyInfo" );

	RecieveBtn = GetButtonHandle( "ProductInventoryDrawerWnd.RecieveBtn" );
	CloseBtn = GetButtonHandle( "ProductInventoryDrawerWnd.CloseBtn" );

	ProductItemDetailList.SetTooltipType( "Inventory" );
}

function Load()
{
	util = L2Util(GetScript("L2Util"));
	ProductInventory = ProductInventoryWnd( GetScript("ProductInventoryWnd") );

	class'UIAPI_TREECTRL'.static.ShowScrollBar("ProductInventoryDrawerWnd.ProductItemName", false);
}

function OnClickButton( string Name )
{
	local Array<string> Result;
	Split( Name, ".", Result );

	switch( Name )
	{
	case "RecieveBtn":
		OnRecieveBtnClick();
		break;
	case "CloseBtn":
		OnCloseBtnClick();
		break;
	}
}

function OnEvent( int Event_ID, string param )
{
	switch( Event_ID )
	{
		case EV_GoodsInventoryItemDesc :			
			OnGoodsInventroyItemDesc( param );
			break;
		case EV_DialogOK :
			HandleDialogOK();
			break;
		case EV_DialogCancel :
			HandleDialogCancel();
			break;
	}
}

function HandleDialogOK()
{
	if( !DialogIsMine() )
	{
		if (!RecieveBtn.IsEnableWindow())
		{
			// ���� ��Ȱ��ȭ �Ǿ� �ִٸ� Ǯ�� �ش�.
			ProductInventory.SetDisableTree( true );
			RecieveBtn.EnableWindow();
			CloseBtn.EnableWindow();
		}
		return;
	}

	switch( DialogGetID() )
	{
		case DIALOGID_RECIEVE:		
			//debug("index>>>>" $ string( ProductInventory.GetSelectIndex() ) );
			//RequestUseGoodsInventoryItem( ProductInventory.GetSelectIndex() );
			RequestUseGoodsInventoryItem( SelectItemNum );
			ProductInventory.SetDisableTree( true );
			RecieveBtn.EnableWindow();
			CloseBtn.EnableWindow();
			break;
	}
}

function HandleDialogCancel()
{
	if( !DialogIsMine() )
	{
		if (!RecieveBtn.IsEnableWindow())
		{
			// ���� ��Ȱ��ȭ �Ǿ� �ִٸ� Ǯ�� �ش�.
			ProductInventory.SetDisableTree( true );
			RecieveBtn.EnableWindow();
			CloseBtn.EnableWindow();
		}
		return;
	}

	switch( DialogGetID() )
	{
		case DIALOGID_RECIEVE:		
			ProductInventory.SetDisableTree( true );
			RecieveBtn.EnableWindow();
			CloseBtn.EnableWindow();
			break;
	}
}

function OnGoodsInventroyItemDesc( string param )
{
	local int i;

	local int index;
	//��ǰ Ÿ��(0:��Ÿ��,1:��ǰ������)
	local int goodsType;	
	//��ǰ IconID
	local int goodsIconID;
	//��ǰ�̸�
	local string goodsName;
	//0:ȯ�ҺҰ�, 1:ȯ�� ����
	//local int goodsCondition;
	//��ǰ����
	local string goodsDesc;
	//0:���� ������ �ƴ�, 1:���� ������
	local int goodsGift;
	//���� ������
	local string goodsSender;
	//���� �޽���
	local string goodsSenderMessage;
	//��ǰ ���� �Ͻ�
	local string goodsDate;

	//���� ������ ����Ʈ�� ����
	local int gameItemCount;
	//���� �������� Ŭ���� ID( ���� ���� ��ŭ )
	local int gameItemClassID;
	//���� ������ ����
	local int gameItemQuantity;

	local ItemID cID;

	local Color clr;
	local string str;

	ParseInt(param, "index", index);
	
	if( index == -1 )
	{
		return;
	}

	SelectItemNum = index;
	ProductInventory.SetExpandedOpen( string(SelectItemNum) );

	ParseInt(param, "goodsType", goodsType);
	ParseInt(param, "goodsIconID", goodsIconID);
	ParseString(param, "goodsName", goodsName);
	ParseInt(param, "goodsCondition", goodsCondition);
	ParseString(param, "goodsDesc", goodsDesc);
	ParseInt(param, "goodsGift", goodsGift);
	ParseString(param, "goodsSender", goodsSender);
	ParseString(param, "goodsSenderMessage", goodsSenderMessage);
	ParseString(param, "goodsDate", goodsDate);
	ParseInt(param, "gameItemCount", gameItemCount);
	
	TreeClear( "ProductInventoryDrawerWnd.ProductItemDetailList" );
	ShowSkillTree();
	
	//������...
	if( goodsType == 0 )
	{
		//debug( string(goodsIconID));
		//debug( class'UIDATA_ITEM'.static.GetItemTextureName( GetItemID( goodsIconID ) ));
		ProductItem.SetTexture( class'UIDATA_ITEM'.static.GetItemTextureName( GetItemID( goodsIconID ) ) );
	}
	else
	{
		//debug(GetGoodsIconName( goodsIconID ) );
		ProductItem.SetTexture( GetGoodsIconName( goodsIconID ) );
	}


	util.TreeClear( "ProductInventoryDrawerWnd.ProductItemName" );
	//Root ��� ����.
	util.TreeInsertRootNode( "ProductInventoryDrawerWnd.ProductItemName", "root", "" );
	//Insert Node Item - ������ �̸�
	if( goodsCondition == 0 || goodsCondition == 2 )
	{
		util.TreeInsertTextMultiNodeItem( "ProductInventoryDrawerWnd.ProductItemName", "root", goodsName, 4, -2, 38, util.ETreeItemTextType.COLOR_DEFAULT );
	}
	else if( goodsCondition == 1 )
	{
		util.TreeInsertTextMultiNodeItem( "ProductInventoryDrawerWnd.ProductItemName", "root", goodsName, 4, -2, 38, util.ETreeItemTextType.COLOR_YELLOW );
	}



	//��ų ����	
	util.TreeClear( "ProductInventoryDrawerWnd.ProductItemInfo" );
	//Root ��� ����.
	util.TreeInsertRootNode( "ProductInventoryDrawerWnd.ProductItemInfo", "root", "" );
	//Insert Node Item - ������ �̸�
	util.TreeInsertTextNodeItem( "ProductInventoryDrawerWnd.ProductItemInfo", "root", goodsDesc );

	//<TextColor R="175" G="152" B="120"/>	
	clr.R = 175;
	clr.G = 152;
	clr.B = 120;
	clr.A = 255;

	//������
	if( goodsGift == 0 )
	{
		Sender.SetNameWithColor( GetSystemString(2475), NCT_Normal,TA_Left, clr );
	}
	else
	{
		str = substitute( goodsSender, "_", "/", true );
		Sender.SetNameWithColor( str, NCT_Normal,TA_Left, clr );
	}

	util.TreeClear( "ProductInventoryDrawerWnd.ProductItemDetailList2" );
	//Root ��� ����.
	util.TreeInsertRootNode( "ProductInventoryDrawerWnd.ProductItemDetailList2", "root", "" );
	//Insert Node Item - ������ �̸�
	util.TreeInsertTextNodeItem( "ProductInventoryDrawerWnd.ProductItemDetailList2", "root", goodsSenderMessage );

	ProductBuyInfo.SetText( goodsDate );

	for( i = 0 ; i < gameItemCount ; i++ )
	{
		ParseInt( param, "gameItemClassID_" $ i, gameItemClassID );
		ParseInt( param, "gameItemQuantity_"$i, gameItemQuantity );

		cID = GetItemID( gameItemClassID );
		
		MakeTreeNode( cID, class'UIDATA_ITEM'.static.GetItemName( cID ) , i , gameItemClassID, gameItemQuantity );
	}

	ProductItemDetailListCounter.SetText("("$string(gameItemCount)$"/10)");

	Me.ShowWindow();
}

function MakeTreeNode( ItemID cID, string goodsName,int index, int id, int itemnum )
{
	local string setTreeName;
	local string TREENAME;
	local string strRetName;
	local string stritemName;
	
	setTreeName = "root";
	TREENAME = "ProductInventoryDrawerWnd.ProductItemDetailList";
	
	strRetName = util.TreeInsertItemNode( TREENAME, "" $ index , setTreeName );

	if( bDrawBgTree == true )
	{
		//Insert Node Item - ������ ���?
		util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 298, 38, , , , ,14 );
	}
	else
	{
		util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 298, 38 );
	}

	bDrawBgTree = !bDrawBgTree;	

	//Insert Node Item - �����۽��� ���
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -291, 2 );
	//Insert Node Item - ������ ������
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, class'UIDATA_ITEM'.static.GetItemTextureName( cID ), 32, 32, -34, 3 );

	stritemName = "" $ goodsName $ " (" $ String(itemnum) $ ")";
	
	util.TreeInsertTextMultiNodeItem( TREENAME, strRetName, stritemName, 4, 0, 38, util.ETreeItemTextType.COLOR_DEFAULT, , id, itemnum );
}

function OnRecieveBtnClick()
{
	if( SelectItemNum != -1 )
	{
		if( goodsCondition == 0 || goodsCondition == 2 )
		{
			RequestUseGoodsInventoryItem( SelectItemNum );
		}
		else if( goodsCondition == 1)
		{
			ProductInventory.SetDisableTree( false );
			RecieveBtn.DisableWindow();
			CloseBtn.DisableWindow();
			DialogSetID( DIALOGID_RECIEVE );
			//DialogShow( DIALOG_Modalless, DIALOG_WARNING, "�����Ͻ� ��ǰ �������� ���� ĳ������ �κ��丮���� �����ϰ� �Ǹ� �ش� �������� ����� ������ ���ֵǾ� û��öȸ�� ���ѵ˴ϴ�.\\n\\n������ ������ �������� �����Ͻðڽ��ϱ�?" );
			DialogShow( DIALOG_Modalless, DIALOG_WARNING,  GetSystemMessage(3387) );
		}
	}
}

function OnCloseBtnClick()
{
	RequestGoodsInventoryItemDesc( -1 );
	SelectItemNum = -1;
	ProductInventory.SetSelectClear();
	Me.HideWindow();
}

// Ʈ�� ����
function TreeClear( string TREENAME )
{
	class'UIAPI_TREECTRL'.static.Clear( TREENAME );
}

function ShowSkillTree()
{	
	//Root ��� ����.
	util.TreeInsertRootNode( "ProductInventoryDrawerWnd.ProductItemDetailList", "root", "", 0, 4 );
}
defaultproperties
{
}
