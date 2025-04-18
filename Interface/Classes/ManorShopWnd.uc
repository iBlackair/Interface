class ManorShopWnd extends SeedShopWnd;

function OnRegisterEvent()
{
	registerEvent( EV_ManorShopWndOpen );
	registerEvent( EV_ManorShopWndAddItem );
	registerEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	m_WindowName="ManorShopWnd";
}

function OnEvent(int Event_ID,string param)
{
	switch( Event_ID )
	{
	case EV_ManorShopWndOpen:
		HandleOpenWindow(param);
		break;
	case EV_ManorShopWndAddItem:
		HandleAddItem(param);
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	default:
		break;
	}
}

function MoveItemTopToBottom( int index, bool bAllItem )
{
	local int bottomIndex;
	local ItemInfo info, bottomInfo;
	if( class'UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName$".TopList", index, info) )
	{
		// 1�ϰ�� ������ �Է��ϴ� ���̾�α״� ������� �ʴ´�.
//		debug("info.ConsumeType:"$info.ConsumeType$", ����:"$info.ItemNum);
		if( !bAllItem && IsStackableItem( info.ConsumeType ) && (info.ItemNum!=IntToInt64(1)) )		// stackable?
		{
			DialogSetID( DIALOG_TOP_TO_BOTTOM );
			DialogSetReservedItemID( info.ID );
			
			if( m_shopType == ShopSell || m_shopType == ShopBuy )
				DialogSetParamInt64( info.ItemNum );
			else
				DialogSetParamInt64(IntToInt64(-1));

			DialogSetDefaultOK();
			DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ) );
		}
		else
		{
			info.bShowCount = false;

			if( m_shopType == ShopSell )
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );
				if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					bottomInfo.ItemNum += info.ItemNum;
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo);
				}
				else
				{
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
				}
				class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".TopList", index );		// ������ �� ��� �ڽ��� �κ��丮 ��Ͽ��� �������� ����
			}
			else if( m_shopType == ShopBuy )												// ���� �ٿ� �߰��Ǵ� ���Ը�ŭ ���� �ش�.
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );
				if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					bottomInfo.ItemNum += info.ItemNum;
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo);
				}
				else
				{
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
					class'UIAPI_INVENWEIGHT'.static.AddWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum );
				}
				
				if(bAllItem)
				{
					class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".TopList", index );		// ������ �ǸŸ���Ʈ�� �ִ� ��� �������� ������� ������ ����.
				}
			}
			else if( m_shopType == ShopPreview)	//�̸�����
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );
				info.ItemNum = IntToInt64(1);
				class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );				
			}
			AddPrice( info.Price * info.ItemNum );
		}
	}
}


function HandleOpenWindow( string param )
{

	Super.HandleOpenWindow(param);

	// ���� Ÿ��Ʋ ���� - lancelot 2006. 11. 1.
	class'UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 738);
	class'UIAPI_WINDOW'.static.SetTooltipType(  m_WindowName$".TopList", "InventoryPrice1HideEnchant");
}

function HandleAddItem( string param )
{
	local ItemInfo info;

	ParamToItemInfo( param, info );
	info.bShowCount=false;
	class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".TopList", info );
}

function HandleOKButton()
{
	local string	param;
	local int		topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo	topInfo, bottomInfo;
	local INT64		limitedItemCount;

	bottomCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
//	debug("ShopWnd m_shopType:" $ m_shopType $ ", bottomCount:" $ bottomCount);
	if( m_shopType == ShopBuy )
	{
		// limited item check
		topCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".TopList" );
		for( topIndex=0 ; topIndex < topCount ; ++topIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".TopList", topIndex, topInfo );
			if(	topInfo.ItemNum > IntToInt64(0) )		// this item can be purchased only by limited number
			{
				limitedItemCount = IntToInt64(0);
				// search in BottomList for same classID
				bottomCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
				for( bottomIndex=0; bottomIndex < bottomCount ; ++bottomIndex )		// match found, then check whether the number exceeds limited number
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					if( IsSameClassID(bottomInfo.ID, topInfo.ID) )
						limitedItemCount += bottomInfo.ItemNum;
				}

				//debug("limited Item count " $ limitedItemCount );
				if( limitedItemCount > topInfo.ItemNum )
				{
					// warning dialog
					DialogShow(DIALOG_Modalless, DIALOG_WARNING, GetSystemMessage(1338) );
					return;
				}
			}
		}
		// pack every item in BottomList
		ParamAdd( param, "merchant", string(m_merchantID) );
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
			ParamAddItemIDWithIndex( param, bottomInfo.ID, bottomIndex );
			ParamAddINT64( Param, "Count_" $ bottomIndex, bottomInfo.ItemNum );
		}
		RequestBuySeed( param );
	}
	else if( m_shopType == ShopSell )
	{
		// pack every item in BottomList
		ParamAdd( param, "merchant", string(m_merchantID) );
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
			ParamAddItemIDWithIndex( param, bottomInfo.ID, bottomIndex);
			ParamAddINT64( Param, "Count_" $ bottomIndex, bottomInfo.ItemNum );
		}

		// ��������� SELL �� ������ ���� �����Ǿ� �־ �������� - lancelot 2006. 11. 1.
		// RequestProcureCrop( param );
	}
	else if( m_shopType == ShopPreview )
	{
		if( bottomCount > 0 )
		{
			DialogSetID( DIALOG_PREVIEW );
			DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(1157) );
		}
	}


	HideWindow(m_WindowName);
}

defaultproperties
{
    
}
