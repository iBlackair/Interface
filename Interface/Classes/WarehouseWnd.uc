class WarehouseWnd extends UICommonAPI;

const KEEPING_PRICE = 30;			// ��ĭ �� ������

const DEFAULT_MAX_COUNT = 200;		// ���� â�� ������ �ٸ� â����� �ִ� ����

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;

enum WarehouseCategory
{
	WC_None,			// dummy
	WC_Private,
	WC_Clan,
	WC_Castle,
	WC_Etc,
};

enum WarehouseType
{
	WT_Deposit,
	WT_Withdraw,
};

var WarehouseCategory	m_category;
var WarehouseType		m_type;
var int					m_maxPrivateCount;
var String				m_WindowName;

var ItemWindowHandle	m_topList;
var ItemWindowHandle	m_bottomList;

var WindowHandle m_dialogWnd;

function OnRegisterEvent()
{
	registerEvent( EV_WarehouseOpenWindow );
	registerEvent( EV_WarehouseAddItem );
	registerEvent( EV_WarehouseDeleteItem );
	registerEvent( EV_SetMaxCount );
	registerEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	
	m_WindowName="WarehouseWnd";

	InitHandle();
}

function InitHandle()
{
	if(CREATE_ON_DEMAND==0)
	{
		m_dialogWnd = GetHandle( "DialogBox" );
		m_topList = ItemWindowHandle( GetHandle( m_WindowName$".TopList" ) );
		m_bottomList = ItemWindowHandle( GetHandle( m_WindowName$".BottomList" ) );
	}
	else
	{
		m_dialogWnd = GetWindowHandle( "DialogBox" );
		m_topList = GetItemWindowHandle( m_WindowName$".TopList" );
		m_bottomList = GetItemWindowHandle( m_WindowName$".BottomList" );
	}
}

function Clear()
{
	m_type = WT_Deposit;
	m_category = WC_None;

	m_topList.Clear();
	m_bottomList.Clear();

	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".PriceText", "");

	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", "");

	class'UIAPI_INVENWEIGHT'.static.ZeroWeight("WarehouseWnd.InvenWeight");
}

function OnEvent(int Event_ID,string param)
{
	switch( Event_ID )
	{
	case EV_WarehouseOpenWindow:
		HandleOpenWindow(param);
		break;
	case EV_WarehouseAddItem:
		HandleAddItem(param);
		break;
	case EV_WarehouseDeleteItem:
		HandleDeleteItem(param);
		break;
	case EV_SetMaxCount:
		HandleSetMaxCount(param);
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	default:
		break;
	}
}

function OnClickButton( string ControlName )
{
	local int index;
	if( ControlName == "UpButton" )
	{
		index = m_bottomList.GetSelectedNum();
		MoveItemBottomToTop( index, false );
	}
	else if( ControlName == "DownButton" )
	{
		index = m_topList.GetSelectedNum();
		MoveItemTopToBottom( index, false );
	}
	else if( ControlName == "OKButton" )
	{
		HandleOKButton();
	}
	else if( ControlName == "CancelButton" )
	{
		Clear();
		HideWindow(m_WindowName);
	}
}

function OnDBClickItem( string ControlName, int index )
{
	if(ControlName == "TopList")
	{
		MoveItemTopToBottom( index, false );
	}
	else if(ControlName == "BottomList")
	{
		MoveItemBottomToTop( index, false );
	}

}

// �������� Ŭ���Ͽ��� ��� (����Ŭ�� �ƴ�)
function OnClickItem( string ControlName, int index )
{
	if(ControlName == "TopList")
	{
		if( DialogIsMine() && m_dialogWnd.IsShowWindow())
		{
			DialogHide();
			m_dialogWnd.HideWindow();
		}		
	}
}

function OnDropItem( string strID, ItemInfo info, int x, int y)
{
	local int index;

	// debug("OnDropItem.Enchanted : " @ info.Enchanted);
	
	if( strID == "TopList" && info.DragSrcName == "BottomList" )
	{
		//index = m_bottomList.FindItem( info.ID );
		index = m_bottomList.FindItemWithAllProperty( info );
						
		// debug("������ �Ʒ��� ");

		if( index >= 0 )
			MoveItemBottomToTop( index, info.AllItemCount > IntToInt64(0) );
	}
	else if( strID == "BottomList" && info.DragSrcName == "TopList" )
	{
		//debug("�Ʒ��� ����  " @ info.Enchanted);
		//index = m_topList.FindItem( info.ID );
		index = m_topList.FindItemWithAllProperty( info );
		if( index >= 0 )
			MoveItemTopToBottom( index, info.AllItemCount > IntToInt64(0) );
	}
}

function MoveItemTopToBottom( int index, bool bAllItem )
{
	local ItemInfo topInfo, bottomInfo;
	local int bottomIndex;
	if( m_topList.GetItem( index, topInfo) )
	{
		// 1�ϰ�� ������ �Է��ϴ� ���̾�α״� ������� �ʴ´�. 
		if( !bAllItem && IsStackableItem( topInfo.ConsumeType ) && (topInfo.ItemNum>IntToInt64(1)) )		// stackable?
		{
			DialogSetID( DIALOG_TOP_TO_BOTTOM );
			DialogSetReservedItemID( topInfo.ID );
			DialogSetParamInt64( topInfo.ItemNum );
			DialogSetDefaultOK();	
			DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), topInfo.Name, "" ) );
		}
		else
		{
			//topInfo.ItemNum k= 1;
			bottomIndex = m_bottomList.FindItem( topInfo.ID );
						
			if( bottomIndex != -1 && IsStackableItem( topInfo.ConsumeType ) )				// ���ڸ� ��ġ��
			{
				m_bottomList.GetItem( bottomIndex, bottomInfo );
				bottomInfo.ItemNum += topInfo.ItemNum;
				m_bottomList.SetItem( bottomIndex, bottomInfo );
			}
			else
			{
				m_bottomList.AddItem( topInfo );
			}
			m_topList.DeleteItem( index );		// ������ �� ��� �ڽ��� �κ��丮 ��Ͽ��� �������� ����

			if( m_type == WT_Withdraw )
				class'UIAPI_INVENWEIGHT'.static.AddWeight( "WarehouseWnd.InvenWeight", topInfo.ItemNum * topInfo.Weight );		// ���� �ٿ� �����ֱ�
			AdjustPrice();
			AdjustCount();
		}
	}
}

function MoveItemBottomToTop( int index, bool bAllItem )
{
	local ItemInfo bottomInfo, topInfo;
	local int	topIndex;
	if( m_bottomList.GetItem(index, bottomInfo) )
	{
		if( !bAllItem && IsStackableItem( bottomInfo.ConsumeType ) && (bottomInfo.ItemNum > IntToInt64(1)) )		// ���� �����
		{
			DialogSetID( DIALOG_BOTTOM_TO_TOP );
			DialogSetReservedItemID( bottomInfo.ID );
			DialogSetParamInt64( bottomInfo.ItemNum );
			DialogSetDefaultOK();	
			DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), bottomInfo.Name, "" ) );
		}
		else
		{
			topIndex = m_topList.FindItem( bottomInfo.ID );
			if( topIndex != -1 && IsStackableItem( bottomInfo.ConsumeType ) )				// ���ڸ� ��ġ��
			{
				m_topList.GetItem( topIndex, topInfo );
				topInfo.ItemNum += bottomInfo.ItemNum;
				m_topList.SetItem( topIndex, topInfo );
			}
			else
			{
				m_topList.AddItem( bottomInfo );
			}
			m_bottomList.DeleteItem( index );

			if( m_type == WT_Withdraw )
				class'UIAPI_INVENWEIGHT'.static.ReduceWeight( "WarehouseWnd.InvenWeight", bottomInfo.ItemNum * bottomInfo.Weight );		// ���� �ٿ��� �� �ֽ�

			AdjustPrice();
			AdjustCount();
		}
	}
}

function HandleDialogOK()
{
	local int id, num, index, topIndex;
	local ItemInfo info, topInfo;
	local ItemID cID;

	if( DialogIsMine() )
	{
		id = DialogGetID();
		num = int( DialogGetString() );
		cID = DialogGetReservedItemID();
		if( id == DIALOG_TOP_TO_BOTTOM && num > 0 )
		{
			topIndex = m_topList.FindItem( cID );
			if( topIndex >= 0 )
			{
				m_topList.GetItem( topIndex, topInfo );
				index = m_bottomList.FindItem( cID );
				if( index >= 0 )
				{
					m_bottomList.GetItem( index, info );
					info.ItemNum += IntToInt64(num);
					m_bottomList.SetItem( index, info );
				}
				else
				{
					info = topInfo;
					info.ItemNum = IntToInt64(num);
					info.bShowCount = false;
					m_bottomList.AddItem( info );
				}
	
				if( m_type == WT_Withdraw )
					class'UIAPI_INVENWEIGHT'.static.AddWeight( "WarehouseWnd.InvenWeight", info.ItemNum * info.Weight );		// ���� �ٿ� �����ֱ�

				topInfo.ItemNum -= IntToInt64(num);
				if( topInfo.ItemNum <= IntToInt64(0) )
					m_topList.DeleteItem( topIndex );
				else
					m_topList.SetItem( topIndex, topInfo );
			}
		}
		else if( id == DIALOG_BOTTOM_TO_TOP && num > 0 )
		{
			index = m_bottomList.FindItem( cID );
			if( index >= 0 )
			{
				m_bottomList.GetItem( index, info );
				info.ItemNum -= IntToInt64(num);
				if( info.ItemNum > IntToInt64(0) )
					m_bottomList.SetItem( index, info );
				else 
					m_bottomList.DeleteItem( index );

				topIndex = m_topList.FindItem( cID );
				if( topIndex >=0 && IsStackableItem( info.ConsumeType ) )
				{
					m_topList.GetItem( topIndex, topInfo );
					topInfo.ItemNum += IntToInt64(num);
					m_topList.SetItem( topIndex, topInfo );
				}
				else
				{
					info.ItemNum = IntToInt64(num);
					m_topList.AddItem( info );
				}

				if( m_type == WT_Withdraw )
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight( "WarehouseWnd.InvenWeight", info.ItemNum * info.Weight );		// ���� �ٿ��� �� �ֱ�
			}
		}
		AdjustPrice();
		AdjustCount();
	}
}

function HandleOpenWindow( string param )
{
	local string type;
	local int tmpInt;
	local string adenaString;
	local WindowHandle m_inventoryWnd;
	//branch
	local WindowHandle m_EnchantWnd;
	local WindowHandle m_AttEnchantWnd;
	//end of branch

	local INT64 adena;

	if(CREATE_ON_DEMAND==0)
	//branch
	{
		m_inventoryWnd = GetHandle( "InventoryWnd" );	//�κ��丮�� ������ �ڵ��� ���´�.
		m_EnchantWnd = GetHandle( "ItemEnchantWnd" );		//��æƮ ������ �ڵ��� ���´�.
		m_AttEnchantWnd = GetHandle( "AttributeEnchantWnd" );
	}
	//end of branch

	else
	//branch
	{
		m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//�κ��丮�� ������ �ڵ��� ���´�.
		m_EnchantWnd = GetWindowHandle( "ItemEnchantWnd" );		//��æƮ ������ �ڵ��� ���´�.
		m_AttEnchantWnd = GetWindowHandle( "AttributeEnchantWnd" );
	}
	//end of branch

	Clear();

	ParseString( param, "type", type );
	ParseInt( param, "category", tmpInt ); 
	m_category = WarehouseCategory( tmpInt );
	ParseInt64( param, "adena", adena );

	switch( m_category )
	{
	case WC_Private:
		class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 1216);
		break;
	case WC_Clan:
		class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 1217);
		break;
	case WC_Castle:
		class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 1218);
		break;
	case WC_Etc:
		class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 131);
		break;
	default:
		break;
	};
	if( type == "deposit" )
		m_type = WT_Deposit;
	else if( type == "withdraw" )
		m_type = WT_Withdraw;;

	adenaString = MakeCostString( Int64ToString(adena) );
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", adenaString);
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", ConvertNumToText(Int64ToString(adena)) );

	if( m_inventoryWnd.IsShowWindow() )			//�κ��丮 â�� ���������� �ݾ��ش�. 
	{
		m_inventoryWnd.HideWindow();
	}
	//branch
	if( m_EnchantWnd.IsShowWindow() )
	{
		ItemEnchantWnd( GetScript( "ItemEnchantWnd" ) ).OnClickButton("ExitBtn");
		m_EnchantWnd.HideWindow();		
	}
	if( m_AttEnchantWnd.IsShowWindow() )
	{
		AttributeEnchantWnd( GetScript( "AttributeEnchantWnd" ) ).OnCancelClick();
	}
	//end of branch
	ShowWindow( m_WindowName );
	class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);

	if( m_type == WT_Deposit )
	{
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".TopText", GetSystemString(138) );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".BottomText", GetSystemString(132) );

		ShowWindow( m_WindowName $ ".BottomCountText" );
		HideWindow( m_WindowName $ ".TopCountText" );
	}
	else if( m_type == WT_Withdraw )
	{
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".TopText", GetSystemString(132) );
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $ ".BottomText", GetSystemString(133) );

		ShowWindow( m_WindowName $ ".TopCountText" );
		HideWindow( m_WindowName $ ".BottomCountText" );
	}
}

function HandleAddItem( string param )
{
	local ItemInfo info;
	
	ParamToItemInfo( param, info );
	m_topList.AddItem( info );
	AdjustCount();
}
function HandleDeleteItem(string param)
{
	local int index;
	local ItemInfo info;
	ParamToItemInfo( param, info );
	index = m_topList.FindItem(info.ID);
	if (index != -1)
	{
		m_topList.DeleteItem(index);
	}
	index = m_bottomList.FindItem(info.ID);
	if (index != -1)
	{
		m_bottomList.DeleteItem(index);
	}	
	AdjustCount();
}
// �� ĭ�� KEEPING_PRICE �� ��ŭ
function AdjustPrice()
{
	local string adena;
	local int count;
	if( m_type == WT_Deposit )
	{
		count = m_bottomList.GetItemNum();
		adena = MakeCostString( string(count*KEEPING_PRICE) );
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceText", adena);
		class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".PriceText", ConvertNumToText(string(count*KEEPING_PRICE)) );
	}
}

function AdjustCount()
{
	local int num, maxNum;
	if( m_category == WC_Private )
		maxNum = m_maxPrivateCount;
	else 
		maxNum = DEFAULT_MAX_COUNT;

	if( m_type == WT_Deposit )
	{
		num = m_bottomList.GetItemNum();
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".BottomCountText", "(" $ string(num) $ "/" $ string(maxNum) $ ")");
		//debug("AdjustCount Deposit num " $ num $ ", maxCount " $ maxNum );
	}
	else if( m_type == WT_Withdraw )
	{
		num = m_topList.GetItemNum();
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".TopCountText", "(" $ string(num) $ "/" $ string(maxNum) $ ")");
		//debug("AdjustCount Withdraw num " $ num $ ", maxCount " $ maxNum );
	}
}

function HandleOKButton()
{
	local string	param;
	local int		bottomCount, bottomIndex;
	local ItemInfo	bottomInfo;

	bottomCount = m_bottomList.GetItemNum();
	if( m_type == WT_Deposit )
	{
		// pack every item in BottomList
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			m_bottomList.GetItem( bottomIndex, bottomInfo );
			ParamAdd( param, "dbID" $ bottomIndex, string(bottomInfo.Reserved) );
			ParamAdd( Param, "count" $ bottomIndex, Int64ToString(bottomInfo.ItemNum) );
		}
		RequestWarehouseDeposit( param );
	}
	else if( m_type == WT_Withdraw )
	{
		// pack every item in BottomList
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			m_bottomList.GetItem( bottomIndex, bottomInfo );
			ParamAdd( param, "dbID" $ bottomIndex, string(bottomInfo.Reserved) );
			ParamAdd( Param, "count" $ bottomIndex, Int64ToString(bottomInfo.ItemNum) );
		}

		RequestWarehouseWithdraw( param );
	}

	HideWindow(m_WindowName);
}

function HandleSetMaxCount( string param )
{
	ParseInt( param, "warehousePrivate", m_maxPrivateCount );
	//debug("HandleStoreSetMaxCount " $ m_maxCount );
}

defaultproperties
{
    
}
