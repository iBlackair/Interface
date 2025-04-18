class ProductInventoryWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle txtItemList;
var TreeHandle ProductListTree;
var ButtonHandle HelpHtmlBtn;
var TextureHandle ProductListBack;
var WindowHandle HelpHtmlWnd;

var string TREENAME;
var string ROOTNAME;

var bool bDrawBgTree;

var int selectItemIndex;

var string beforeTreeName;

var WindowHandle     m_inventoryWnd;

//UI�� UC
var L2Util util;


function OnRegisterEvent()
{
	RegisterEvent( EV_GoodsInventoryItemList );
	RegisterEvent( EV_GoodsInventoryResult );
}

function OnLoad()
{
	TreeName="ProductInventoryWnd.ProductListTree";
    RootName="root";
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "ProductInventoryWnd" );
	txtItemList = GetTextBoxHandle( "ProductInventoryWnd.txtItemList" );
	ProductListTree = GetTreeHandle( "ProductInventoryWnd.ProductListTree" );
	HelpHtmlBtn = GetButtonHandle( "ProductInventoryWnd.HelpHtmlBtn" );
	ProductListBack = GetTextureHandle( "ProductInventoryWnd.ProductListBack" );

	HelpHtmlWnd = GetWindowHandle( "ProductInventoryHelpHtmlWnd" );

	m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//�κ��丮�� ������ �ڵ��� ���´�.
}

function Load()
{
	util = L2Util(GetScript("L2Util"));	
}

function OnShow()
{
	if( m_inventoryWnd.IsShowWindow() )			//�κ��丮 â�� ���������� �ݾ��ش�. 
	{
		m_inventoryWnd.HideWindow();
	}

	//â�� ���� List �� ����. 
	TreeClear();
	class'UIAPI_TREECTRL'.static.Clear( "ProductInventoryDrawerWnd.ProductItemDetailList" );
	RequestGoodsInventoryItemList();
}

function OnHide()
{
	DescHide();
}

function DescHide()
{
	local WindowHandle win;	
	win = GetWindowHandle( "ProductInventoryDrawerWnd" );
	
	DialogHide();
	class'UIAPI_WINDOW'.static.EnableWindow("ProductInventoryDrawerWnd.RecieveBtn");
	class'UIAPI_WINDOW'.static.EnableWindow("ProductInventoryDrawerWnd.CloseBtn");
	beforeTreeName = "";
	SetDisableTree( true );

	if( win.IsShowWindow() )
	{
		win.HideWindow();
		RequestGoodsInventoryItemDesc( -1 );
		SetSelectClear();
	}
}

function OnClickButton( string strID )
{
	local Array<string> Result;	

	//debug( strID );

	//local ProductInventoryDrawerWnd sc;
	//sc = ProductInventoryDrawerWnd(GetScript("ProductInventoryDrawerWnd"));	

	Split( strID, ".", Result );

	if( strID == "HelpHtmlBtn" )
	{
		OnHelpHtmlBtnClick();
		//class'UIAPI_WINDOW'.static.ShowWindow("ProductInventoryDrawerWnd");
		//sc.testCall();
	}

	if( Result[0] == ROOTNAME )
	{
		if( beforeTreeName != strID )
		{
			ProductListTree.SetExpandedNode( beforeTreeName, false );
			ProductListTree.SetExpandedNode( strID, true );
			selectItemIndex = int( Result[1]);
			RequestGoodsInventoryItemDesc( selectItemIndex );
		}
		else
		{
			ProductListTree.SetExpandedNode( beforeTreeName, true );
		}

		beforeTreeName = strID;
	}
}

function OnEvent( int Event_ID, string param )
{
	switch( Event_ID )
	{
		case EV_GoodsInventoryItemList :
			//Me.ShowWindow();
			OnGoodsInventoryItemList(param);
			break;

		case EV_GoodsInventoryResult :
			OnGoodsInventoryResult( param );
			break;
	}
}

function OnGoodsInventoryItemList( string param )
{
	//15
	//goodsCount=12 goodsIconID_0=1 goodsName_0=�̸�0 goodsCondition_0=0 goodsIconID_1=2 goodsName_1=�̸�1 goodsCondition_1=1 goodsIconID_2=3 goodsName_2=�̸�2 goodsCondition_2=0 goodsIconID_3=4 goodsName_3=�̸�3 goodsCondition_3=1
 	local int i;

	local int goodsCount;
	local int goodsType;
	local int goodsIconID;  
	local string goodsName;
	//0:ȯ�ҺҰ�, 1:ȯ�� ����
	local int goodsCondition;

	local string strTexture;

	local ItemID cID;

	TreeClear();
	ShowSkillTree();

	//debug(param);

	ParseInt(param, "goodsCount", goodsCount);
	
	for( i = 0 ; i < goodsCount ; i++)
	{
		ParseInt( param, "goodsType_"$i, goodsType );
		ParseInt( param, "goodsIconID_"$i, goodsIconID );
		ParseString( param, "goodsName_"$i, goodsName );
		ParseInt( param, "goodsCondition_"$i, goodsCondition );

		cID = GetItemID( goodsIconID );

		//MakeTreeNode( cID, goodsName, goodsCondition, goodsIconID );
		if( goodsType == 0 )
		{
			strTexture = class'UIDATA_ITEM'.static.GetItemTextureName( cID );
		}
		else
		{
			strTexture = GetGoodsIconName( goodsIconID );
		}
		MakeTreeNode( cID, goodsName, goodsCondition, i, strTexture );			
	}

}


function MakeTreeNode( ItemID cID, string goodsName, int goodsCondition, int index, string Texture )
{
	local string setTreeName;
	local string strRetName;

	setTreeName = ROOTNAME;
	strRetName = util.TreeInsertItemTooltipNode( TREENAME, "" $ index , setTreeName, -2, 0, 38, 0, 30, 38, util.getCustomTooltip() );

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
	util.TreeInsertTextureNodeItem( TREENAME, strRetName, Texture, 32, 32, -34, 3 );
	//util.TreeInsertTextureNodeItem( TREENAME, strRetName, GetGoodsIconName( 0 ), 32, 32, -34, 3 );
	//debug( GetGoodsIconName( 1 ) );

	if( goodsCondition == 0 || goodsCondition == 2 )
	{
		util.TreeInsertTextMultiNodeItem( TREENAME, strRetName, goodsName, 4, 0, 38, util.ETreeItemTextType.COLOR_DEFAULT );
	}
	else if( goodsCondition == 1 )
	{
		util.TreeInsertTextMultiNodeItem( TREENAME, strRetName, goodsName, 4, 0, 38, util.ETreeItemTextType.COLOR_YELLOW );
	}
}


function OnGoodsInventoryResult( string param )
{
	local int Result;

	ParseInt(param, "Result", Result);
		
	if( Result == 1 )
	{
		//��ǰ��ȸ ����		
	}	
	else if( Result == 2 )
	{
		//��ǰ ���� ����
		AddSystemMessage( 3412 );
		DescHide();
	}


	if( Result < 0 )
	{
		Me.HideWindow();
		DescHide();

		if( Result == -1 )
		{
			//�߸��� ��û (���� ����)
			//3377 : ��û�� �߸��Ǿ����ϴ�.
			DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3377) );
		}
		else if( Result == -2 )
		{
			//�� �� ���� �ý��� ����
			//3385 : �ý��� ������ ��ǰ �κ��丮�� �̿��Ͻ� �� �����ϴ�. ��� �� �ٽ� �õ����ּ���.
			DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3385) );
		}
		else if( Result == -3 )
		{
			//���� �κ��丮 �뷮 �ʰ�
			//3386 : ���� �κ��丮�� ����/���� ������ �ʰ��Ͽ� ��ǰ�� ���� �� �����ϴ�. �κ��丮�� ����/������ 80�ۼ�Ʈ �̸��� ���� ���� �� �ֽ��ϴ�.
			DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3386) );
		}
		else if( Result == -4 )
		{
			//SA ���� ���� �Ұ�
			//3411 : ���� ��ǰ ���� ������ ������ �� �����ϴ�. ��� �� �ٽ� �õ����ּ���.
			DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3411) );
		}
		else if( Result == -5 )
		{
			//���� �ŷ� ��
			//3413 : �ŷ� ��, ���� ���� �� ���� ���� �߿��� ��ǰ �κ��丮�� �̿��Ͻ� �� �����ϴ�.
			//AddSystemMessage( 3413 );
			DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3413) );
		}
		else if( Result == -6 )
		{
			//���� �� ��ǰ �������� ����
			//3417 : ���� ��ǰ �κ��丮 ���� ������ ��ǰ�� �������� �ʽ��ϴ�.
			DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3417) );
		}


		else if( Result == -101 )
		{
			//���� ó�� ���� �۾��� ���� ��ǰ �κ��丮�� ������ �� ����. (-101)
			//���� �̿��ڰ� ���� ��ǰ �κ��丮�� ��ȸ�� �� �����ϴ�. ��� �� �ٽ� �õ����ּ���.
			//DialogShow( DIALOG_Modalless, DIALOG_Notice, "���� �̿��ڰ� ���� ��ǰ �κ��丮�� ��ȸ�� �� �����ϴ�. ��� �� �ٽ� �õ����ּ���." );
			DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(3378) );
		}
		else if( Result == -102 )
		{
			//���� �� SA ���� ����� ����
			//3410 : ���� �̿��ڰ� ���� ��ǰ�� �����Ͻ� �� �����ϴ�. ��� �� �ٽ� �õ����ּ���.
			DialogShow( DIALOG_Modalless, DIALOG_Notice,  GetSystemMessage(3410) );
		}
		else if( Result == -103 )
		{
			//���� �۾� ���� ��
			//3379 : ���� ��û�� ���� �Ϸ���� �ʾҽ��ϴ�. ��� ��ٷ��ּ���.
			//AddSystemMessage( 3379 );
			DialogShow( DIALOG_Modalless, DIALOG_Notice,  GetSystemMessage(3379) );
		}
		else if( Result == -104 )
		{
		}
		else if( Result == -105 )
		{
			//�䱸 ��ǰ �̹� û��öȸ
			//3381 : ��ǰ�� �̹� û��öȸ ó���Ǿ����ϴ�.
			DialogShow( DIALOG_Modalless, DIALOG_Notice,  GetSystemMessage(3381) );
		}
		else if( Result == -106 )
		{
			//�䱸 ��ǰ �̹� ����
			//3382 : ��ǰ�� �̹� �����ϼ̽��ϴ�.
			DialogShow( DIALOG_Modalless, DIALOG_Notice,  GetSystemMessage(3382) );
		}
		else if( Result == -107 )
		{
			//��ǰ�� ������ �� ���� ����
			//3383 : �� ���������� �����Ͻ� ��ǰ�� �����Ͻ� �� �����ϴ�.
			DialogShow( DIALOG_Modalless, DIALOG_Notice,  GetSystemMessage(3383) );
		}
		else if( Result == -108 )
		{
			//��ǰ�� ������ �� ���� ĳ����
			//3384 : �� ĳ���ͷδ� �����Ͻ� ��ǰ�� �����Ͻ� �� �����ϴ�.
			DialogShow( DIALOG_Modalless, DIALOG_Notice,  GetSystemMessage(3384) );
		}
	}
}


function OnHelpHtmlBtnClick()
{
	HelpHtmlWnd.ShowWindow();
}


// Ʈ�� ����
function TreeClear()
{
	ProductListTree.SetScrollPosition(0);
	class'UIAPI_TREECTRL'.static.Clear( TREENAME );
}

function ShowSkillTree()
{	
	//Root ��� ����.
	util.TreeInsertRootNode( TREENAME, ROOTNAME, "", 0, 4 );
}

function int GetSelectIndex()
{
	return selectItemIndex;
}

function SetSelectClear()
{
	ProductListTree.SetExpandedNode( beforeTreeName, false );
	beforeTreeName = "";
}

function SetDisableTree( bool b )
{
	if( b == true )
	{
		ProductListTree.EnableWindow();
	}
	else
	{
		ProductListTree.DisableWindow();
	}
}

function SetExpandedOpen( string NodeName )
{
	local string openNode;

	openNode = ProductListTree.GetExpandedNode( "root" );

	if( openNode == "" )
	{
		ProductListTree.SetExpandedNode( "root."$NodeName, true );
	}
}

defaultproperties
{
    
}
