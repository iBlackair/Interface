//------------------------------------------------------------------------------------------------------------------------
//
// ����         : ShopWnd  ( ���� UC )
//
//------------------------------------------------------------------------------------------------------------------------

class ShopWnd extends UICommonAPI;


//------------------------------------------------------------------------------------------------------------------------
// const
//------------------------------------------------------------------------------------------------------------------------
const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_PREVIEW       = 333;

// ����� �߰� by jin 2009.03.24.
const REFUND_ITEM = 444;

//------------------------------------------------------------------------------------------------------------------------
// Variables  
//------------------------------------------------------------------------------------------------------------------------
enum ShopType
{
	ShopNone,		// Invalid type
	ShopBuy,
	ShopSell,
	ShopPreview,
	// ����� �߰� by jin 2009.03.18.
	ShopRefund,
};

var int		 m_merchantID;
var int		 m_npcID;				    // only for shoppreveiw
var bool	 m_isCompleteTransaction;
var INT64	 m_currentPrice;			// ����/�Ǹ�/����� ��Ͽ� �÷����� �������� ������ �ջ��� ��
var INT64	 m_UserAdena;
var String   m_WindowName;			    // ��ӿ� ����Ϸ��� ������ �̸� �߰� - lancelot 2006. 11. 27.

var ShopType m_LastShopType;
var ShopType m_shopType;

//------------------------------------------------------------------------------------------------------------------------
// Control Handle
//------------------------------------------------------------------------------------------------------------------------
var WindowHandle me;

// Tab Handle
var TabHandle m_TransactionTabHandle;
var TabHandle m_PreviewTabHandle;

// ItemWindow Handle
var ItemWindowHandle m_BuyTopListHandle;
var ItemWindowHandle m_SellTopListHandle;
var ItemWindowHandle m_RefundTopListHandle;

var ItemWindowHandle m_BuyBottomListHandle;
var ItemWindowHandle m_SellBottomListHandle;
var ItemWindowHandle m_RefundBottomListHandle;

var ItemWindowHandle m_PreviewTopListHandle;
var ItemWindowHandle m_PreviewBottomListHandle;

// Texture Handle
var TextureHandle m_TexTransactionBGLine;
var TextureHandle m_TexPreviewBGLine;

var TextureHandle m_TexRefundSlotBG;
var TextureHandle m_TexBuySellSlotBG;
var TextureHandle m_TexPreviewSlotBG;

// TextBox Handle
var TextBoxHandle m_PriceConstTextBoxHandle;
var TextBoxHandle m_PriceTextBoxHandle;
var TextBoxHandle m_AdenaTextBoxHandle;
var TextBoxHandle m_BottomTextBoxHandle;

// Button Handle
var ButtonHandle m_OkButtonHandle;

var ButtonHandle m_CancelButtonHandle;

var WindowHandle m_itemEnchantWndHandle;
var ItemEnchantWnd m_itemEnchantWndScript;

//------------------------------------------------------------------------------------------------------------------------
//
// Event Functions.
//
//------------------------------------------------------------------------------------------------------------------------


function OnRegisterEvent()
{
	registerEvent( EV_ShopOpenWindow );
	registerEvent( EV_ShopAddItem );
	registerEvent( EV_DialogOK );
	registerEvent( EV_DialogCancel );
	registerEvent( EV_OnEndTransactionList );
}


function OnLoad()
{
	OnRegisterEvent();
	m_WindowName="ShopWnd";

	me = GetWindowHandle("ShopWnd");

	m_TransactionTabHandle = GetTabHandle("ShopWnd.TransactionSelectTab");
	m_PreviewTabHandle = GetTabHandle("ShopWnd.PreviewSelectTab");

	m_BuyTopListHandle = GetItemWindowHandle("ShopWnd.BuyTopList");	
	m_SellTopListHandle = GetItemWindowHandle("ShopWnd.SellTopList");		
	m_RefundTopListHandle = GetItemWindowHandle("ShopWnd.RefundTopList");	
	m_BuyTopListHandle.SetTooltipType("InventoryPrice1HideEnchantStackable");
	m_SellTopListHandle.SetTooltipType("InventoryPrice2");	
	m_RefundTopListHandle.SetTooltipType("InventoryPrice1");

	m_BuyBottomListHandle = GetItemWindowHandle("ShopWnd.BuyBottomList");	
	m_SellBottomListHandle = GetItemWindowHandle("ShopWnd.SellBottomList");	
	m_RefundBottomListHandle = GetItemWindowHandle("ShopWnd.RefundBottomList");
	m_BuyBottomListHandle.SetTooltipType("InventoryPrice1");
	m_SellBottomListHandle.SetTooltipType("InventoryPrice2");
	m_RefundBottomListHandle.SetTooltipType("InventoryPrice1");

	m_PreviewTopListHandle = GetItemWindowHandle("ShopWnd.PreviewTopList");
	m_PreviewBottomListHandle = GetItemWindowHandle("ShopWnd.PreviewBottomList");

	m_TexTransactionBGLine = GetTextureHandle("ShopWnd.TransactionSelectTabBgLine");
	m_TexPreviewBGLine = GetTextureHandle("ShopWnd.Sell_TexTabBgLine");

	m_TexRefundSlotBG = GetTextureHandle("ShopWnd.RefundItemListBg");
	m_TexBuySellSlotBG = GetTextureHandle("ShopWnd.Buy_TopSlotListBg");	
	m_TexPreviewSlotBG = GetTextureHandle("ShopWnd.Sell_TopSlotListBg");

	m_PriceConstTextBoxHandle = GetTextBoxHandle("ShopWnd.PriceConstText");
	m_PriceTextBoxHandle = GetTextBoxHandle("ShopWnd.PriceText");
	m_AdenaTextBoxHandle = GetTextBoxHandle("ShopWnd.AdenaText");
	m_BottomTextBoxHandle = GetTextBoxHandle("ShopWnd.BottomText");

	m_OkButtonHandle = GetButtonHandle("ShopWnd.OKButton");
	m_CancelButtonHandle = GetButtonHandle("ShopWnd.CancelButton");

	m_isCompleteTransaction = false;
	m_LastShopType = ShopNone;

	m_itemEnchantWndHandle = GetWindowHandle("ItemEnchantWnd");
	m_itemEnchantWndScript = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
	
}


function OnEvent(int Event_ID, string param)
{
	switch( Event_ID )
	{
	case EV_ShopOpenWindow:
		// ��ǰ �κ��丮�� ���� �ִٸ� ���� �ʴ´�.
		if (!GetWindowHandle("ProductInventoryWnd").IsShowWindow())	HandleOpenWindow(param);
		break;
	case EV_ShopAddItem:
		HandleAddItem(param);
		break;
	case EV_DialogOK:
		setEnableWindow(true);
		HandleDialogOK();
		break;
	case EV_DialogCancel:
		setEnableWindow(true);
		break;
	case EV_OnEndTransactionList:
		HandleEndTransactionList(param);
		break;
	default:
		break;
	}
}


function OnClickButton(string ControlName)
{
	local int index;
	local int bottomIndex;
	local int topIndex;
	local ItemInfo deleteItemInfo;
	local ItemInfo addItemInfo;

	if(ControlName == "UpButton")
	{
		if(m_shopType == ShopBuy)
			index = m_BuyBottomListHandle.GetSelectedNum();
		else if(m_shopType == ShopSell)
			index = m_SellBottomListHandle.GetSelectedNum();
		else if(m_shopType == ShopRefund)
			index = m_RefundBottomListHandle.GetSelectedNum();
		else
			index = m_PreviewBottomListHandle.GetSelectedNum();

		MoveItemBottomToTop(index, false);
	}
	else if(ControlName == "DownButton")
	{
		if(m_shopType == ShopBuy)
			index = m_BuyTopListHandle.GetSelectedNum();
		else if(m_shopType == ShopSell)
			index = m_SellTopListHandle.GetSelectedNum();
		else if(m_shopType == ShopRefund)
			index = m_RefundTopListHandle.GetSelectedNum();
		else
			index = m_PreviewTopListHandle.GetSelectedNum();

		MoveItemTopToBottom(index, false);
	}
	else if(ControlName == "OKButton")
	{
		setEnableWindow(true);
		HandleOKButton();
	}
	else if(ControlName == "CancelButton")
	{		
		setEnableWindow(true);
		HideWindow(m_WindowName);
	}
	// ����� �߰� by jin 2009.03.20.
	else if(ControlName == "TransactionSelectTab0")	// ����
	{
		if(m_shopType == ShopBuy)
			return;
		else if(m_shopType == ShopSell)
		{
			bottomIndex = m_SellBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_SellBottomListHandle.GetItem(index, deleteItemInfo);
					if(IsStackableItem(deleteItemInfo.ConsumeType))
					{
						topIndex = m_SellTopListHandle.FindItem(deleteItemInfo.ID);
						m_SellTopListHandle.GetItem(topIndex, addItemInfo);
						if(topIndex >= 0)
						{
							addItemInfo.ItemNum += deleteItemInfo.ItemNum;
							m_SellTopListHandle.SetItem(topIndex, addItemInfo);
						}
						else
							m_SellTopListHandle.AddItem(deleteItemInfo);
					}
					else
						m_SellTopListHandle.AddItem(deleteItemInfo);
				}
			}
		}
		else if(m_shopType == ShopRefund)
		{
			bottomIndex = m_RefundBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_RefundBottomListHandle.GetItem(index, deleteItemInfo);
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(deleteItemInfo.Weight) * deleteItemInfo.ItemNum);
					m_RefundTopListHandle.AddItem(deleteItemInfo);
				}
			}
		}

		m_currentPrice = IntToInt64(0);

		m_SellBottomListHandle.Clear();
		m_RefundBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.ShowWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.HideWindow();

		m_BuyTopListHandle.ShowWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.HideWindow();	

		m_BuyBottomListHandle.ShowWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.HideWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1434));	// text : [����]
		m_BottomTextBoxHandle.SetText(GetSystemString(139));	// text : [���Ÿ��]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(142));// text : [���ž�]

		m_shopType = ShopBuy;
	}
	else if(ControlName == "TransactionSelectTab1")	// �Ǹ�
	{
		if(m_shopType == ShopSell)
			return;
		else if(m_shopType == ShopBuy)
		{
			bottomIndex = m_BuyBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_BuyBottomListHandle.GetItem(index, deleteItemInfo);
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(deleteItemInfo.Weight) * deleteItemInfo.ItemNum);
				}
			}
		}
		else if(m_shopType == ShopRefund)
		{
			bottomIndex = m_RefundBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_RefundBottomListHandle.GetItem(index, deleteItemInfo);
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(deleteItemInfo.Weight) * deleteItemInfo.ItemNum);
					m_RefundTopListHandle.AddItem(deleteItemInfo);
				}
			}
		}

		m_currentPrice = IntToInt64(0);

		m_BuyBottomListHandle.Clear();
		m_RefundBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.ShowWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.HideWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.ShowWindow();
		m_RefundTopListHandle.HideWindow();	

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.ShowWindow();
		m_RefundBottomListHandle.HideWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1157));	// text : [�Ǹ�]
		m_BottomTextBoxHandle.SetText(GetSystemString(137));	// text : [�ǸŸ��]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(143));// text : [�Ǹž�]

		m_shopType = ShopSell;
		
	}
	else if(ControlName == "TransactionSelectTab2")	// �籸��
	{
		if(m_shopType == ShopRefund)
			return;
		else if(m_shopType == ShopSell)
		{
			bottomIndex = m_SellBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_SellBottomListHandle.GetItem(index, deleteItemInfo);
					if(IsStackableItem(deleteItemInfo.ConsumeType))
					{
						topIndex = m_SellTopListHandle.FindItem(deleteItemInfo.ID);
						m_SellTopListHandle.GetItem(topIndex, addItemInfo);
						if(topIndex >= 0)
						{
							addItemInfo.ItemNum += deleteItemInfo.ItemNum;
							m_SellTopListHandle.SetItem(topIndex, addItemInfo);
						}
						else
							m_SellTopListHandle.AddItem(deleteItemInfo);
					}
					else
						m_SellTopListHandle.AddItem(deleteItemInfo);
				}
			}
		}
		else if(m_shopType == ShopBuy)
		{
			bottomIndex = m_BuyBottomListHandle.GetItemNum();
			if(bottomIndex != 0)
			{
				for(index = 0; index < bottomIndex; ++index)
				{
					m_BuyBottomListHandle.GetItem(index, deleteItemInfo);
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(deleteItemInfo.Weight) * deleteItemInfo.ItemNum);
				}
			}
		}

		m_currentPrice = IntToInt64(0);

		m_BuyBottomListHandle.Clear();
		m_SellBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.HideWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.ShowWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.ShowWindow();	

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.ShowWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(2028));	// text : [�籸��]
		m_BottomTextBoxHandle.SetText(GetSystemString(2205));	// text : [�籸�Ÿ��]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(2206));// text : [�籸�ž�]

		m_shopType = ShopRefund;
	}
}


function OnDBClickItem(string ControlName, int index)
{
	if(ControlName == "BuyTopList" || ControlName == "RefundTopList" || ControlName == "SellTopList" || ControlName == "PreviewTopList")
	{		
		MoveItemTopToBottom(index, false);
	}
	else if(ControlName == "BuyBottomList" || ControlName == "RefundBottomList" || ControlName == "SellBottomList" || ControlName == "PreviewBottomList")
	{
		MoveItemBottomToTop(index, false);
	}
}

function OnDropItem(string strID, ItemInfo info, int x, int y)
{
	local int index;
	//debug("OnDropItem strID " $ strID $ ", src=" $ info.DragSrcName);
	if(m_shopType == ShopBuy)
	{
		if(strID == "BuyTopList" && info.DragSrcName == "BuyBottomList")
		{
			index = m_BuyBottomListHandle.FindItem(info.ID);
			if(index >= 0)
				MoveItemBottomToTop(index, info.AllItemCount > IntToInt64(0));
		}
		else if(strID == "BuyBottomList" && info.DragSrcName == "BuyTopList")
		{
			index = m_BuyTopListHandle.FindItem(info.ID);
			if( index >= 0 )
				MoveItemTopToBottom(index, info.AllItemCount > IntToInt64(0));
		}
	}
	else if(m_shopType == ShopSell)
	{
		if(strID == "SellTopList" && info.DragSrcName == "SellBottomList")
		{
			index = m_SellBottomListHandle.FindItem(info.ID);
			if(index >= 0)
				MoveItemBottomToTop(index, info.AllItemCount > IntToInt64(0));
		}
		else if(strID == "SellBottomList" && info.DragSrcName == "SellTopList")
		{
			index = m_SellTopListHandle.FindItem(info.ID);
			if( index >= 0 )
				MoveItemTopToBottom(index, info.AllItemCount > IntToInt64(0));
		}
	}
	else if(m_shopType == ShopRefund)
	{
		if(strID == "RefundTopList" && info.DragSrcName == "RefundBottomList")
		{
			index = m_RefundBottomListHandle.FindItem(info.ID);
			if(index >= 0)
				MoveItemBottomToTop(index, info.AllItemCount > IntToInt64(0));
		}
		else if(strID == "RefundBottomList" && info.DragSrcName == "RefundTopList")
		{
			index = m_RefundTopListHandle.FindItem(info.ID);
			if( index >= 0 )
				MoveItemTopToBottom(index, info.AllItemCount > IntToInt64(0));
		}
	}
	else if(m_shopType == ShopPreview)
	{
		if(strID == "PreviewTopList" && info.DragSrcName == "PreviewBottomList")
		{
			index = m_PreviewBottomListHandle.FindItem(info.ID);
			if(index >= 0)
				MoveItemBottomToTop(index, info.AllItemCount > IntToInt64(0));
		}
		else if(strID == "PreviewBottomList" && info.DragSrcName == "PreviewTopList")
		{
			index = m_PreviewTopListHandle.FindItem(info.ID);
			if( index >= 0 )
				MoveItemTopToBottom(index, info.AllItemCount > IntToInt64(0));
		}
	}
}


//------------------------------------------------------------------------------------------------------------------------
//
// General Functions.
//
//------------------------------------------------------------------------------------------------------------------------

function OnHide()
{
	m_LastShopType = ShopNone;

	if(m_shopType != ShopPreview)
		RequestBuySellUIClose();
	Clear();
	m_isCompleteTransaction = false;

	m_itemEnchantWndScript.SetIsShopping(false);
}

function Clear()
{
	m_shopType = ShopNone;
	m_merchantID = -1;
	m_npcID = -1;
	m_currentPrice = IntToInt64(0);

	m_BuyTopListHandle.Clear();
	m_SellTopListHandle.Clear();
	m_RefundTopListHandle.Clear();

	m_BuyBottomListHandle.Clear();
	m_SellBottomListHandle.Clear();
	m_RefundBottomListHandle.Clear();

	m_PreviewTopListHandle.Clear();
	m_PreviewBottomListHandle.Clear();

	m_PriceTextBoxHandle.SetText("0");
	m_PriceTextBoxHandle.SetTooltipString("");

	m_AdenaTextBoxHandle.SetText("0");
	m_AdenaTextBoxHandle.SetTooltipString("");

	class'UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName$".InvenWeight");

	m_TransactionTabHandle.InitTabCtrl();
	//m_isCompleteTransaction = false;
}

function MoveItemTopToBottom(int index, bool bAllItem)
{
	local int bottomIndex;
	local ItemInfo info, bottomInfo;

	if (index < 0) 
		return;

	if(m_shopType == ShopBuy)
		m_BuyTopListHandle.GetItem(index, info);
	else if(m_shopType == ShopSell)
		m_SellTopListHandle.GetItem(index, info);
	else if(m_shopType == ShopRefund)
		m_RefundTopListHandle.GetItem(index, info);
	else if(m_shopType == ShopPreview)
		m_PreviewTopListHandle.GetItem(index, info);

	if(!bAllItem && IsStackableItem(info.ConsumeType) && (info.ItemNum!=IntToInt64(1)) && (m_shopType != ShopRefund))		// stackable?
	{
		setEnableWindow(false);
		DialogSetID(DIALOG_TOP_TO_BOTTOM);
		DialogSetReservedItemID(info.ID);
		DialogSetDefaultOK();
		if(m_shopType == ShopSell)
			DialogSetParamInt64(info.ItemNum);
		else
			DialogSetParamInt64(IntToInt64(-1));
		
		DialogSetDefaultOK();	
		DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), info.Name, ""));
	}
	else
	{
		info.bShowCount = false;

		if(m_shopType == ShopBuy)
		{
			info.ItemNum = IntToInt64(1);	// ���� ������ ��� ItemNum�� ���� �Ǿ� ���� ���� ��찡 �ֱ� ������ �Ϻη� 1�� �� ����Ѵ�.
			
			m_BuyBottomListHandle.AddItem(info);
			class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum);
		}
		else if(m_shopType == ShopSell)
		{
			bottomIndex = m_SellBottomListHandle.FindItem(info.ID);	// ClassID
			if(bottomIndex >= 0 && IsStackableItem(info.ConsumeType))
			{
				m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
				bottomInfo.ItemNum += info.ItemNum;
				m_SellBottomListHandle.SetItem(bottomIndex, bottomInfo);
			}
			else
			{
				m_SellBottomListHandle.AddItem(info);
			}
			m_SellTopListHandle.DeleteItem(index);	// ������ �� ��� �ڽ��� �κ��丮 ��Ͽ��� �������� ����
		}
		else if( m_shopType == ShopRefund )	// ����� �߰� by jin 2009.03.18.
		{
			info.Reserved = REFUND_ITEM;	// ����� ���������� ǥ���ϴ� �÷��׸� ������� �ʴ� �Ӽ��� info.Reserved �Ӽ��� �����Ѵ�.
			m_RefundTopListHandle.DeleteItem(index);
			m_RefundBottomListHandle.AddItem(info);
			class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum);
		}
		else if( m_shopType == ShopPreview )
		{
			bottomIndex = m_PreviewBottomListHandle.FindItem(info.ID);	// ClassID
			info.ItemNum = IntToInt64(1);
			m_PreviewBottomListHandle.AddItem(info);
		}

		if(info.Reserved != REFUND_ITEM)
			AddPrice(info.Price * info.ItemNum);
		else
			AddPrice(info.Price);
	}
}

function MoveItemBottomToTop(int index, bool bAllItem)
{
	local ItemInfo info, info2;
	local int bottomIndex;

	if (index < 0) 
		return;

	if(m_shopType == ShopBuy)
		m_BuyBottomListHandle.GetItem(index, info);
	else if(m_shopType == ShopSell)
		m_SellBottomListHandle.GetItem(index, info);
	else if(m_shopType == ShopRefund)
		m_RefundBottomListHandle.GetItem(index, info);
	else if(m_shopType == ShopPreview)
		m_PreviewBottomListHandle.GetItem(index, info);

	
	if(!bAllItem && IsStackableItem(info.ConsumeType) && (info.ItemNum!=IntToInt64(1)) && (info.Reserved!=REFUND_ITEM))	// stackable?
	{
		setEnableWindow(false);
		DialogSetID(DIALOG_BOTTOM_TO_TOP);
		DialogSetDefaultOK();
		DialogSetReservedItemID(info.ID);
		DialogSetParamInt64(info.ItemNum);
		DialogSetDefaultOK();	
		DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), info.Name, ""));
	}
	else
	{
		if(m_shopType == ShopBuy)
		{
			m_BuyBottomListHandle.DeleteItem(index);

			class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum);
		}
		else if(m_shopType == ShopSell)
		{
			m_SellBottomListHandle.DeleteItem(index);

			bottomIndex = m_SellTopListHandle.FindItem(info.ID);	// ServerID
			if(bottomIndex == -1)
				m_SellTopListHandle.AddItem(info);	// ������ �Ǹ��ϴ� ��� �ٽ� �ڽ��� �κ��丮 �������
			else
			{
				m_SellTopListHandle.GetItem(bottomIndex, info2);
				info2.ItemNum += info.ItemNum;
				m_SellTopListHandle.SetItem(bottomIndex, info2);
			}
		}
		else if(m_shopType == ShopRefund)
		{
			m_RefundBottomListHandle.DeleteItem(index);

			if(info.Reserved == REFUND_ITEM)	// �������� ����� �� �������̶�� RefundItemList�� ����������.
				m_RefundTopListHandle.AddItem(info);

			class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName$".InvenWeight", IntToInt64(info.Weight) * info.ItemNum);
		}
		else if(m_shopType == ShopPreview)
		{
			m_PreviewBottomListHandle.DeleteItem(index);
		}

		if(info.Reserved != REFUND_ITEM)
			AddPrice(-info.Price * info.ItemNum);
		else
			AddPrice(-info.Price);
	}
}

function HandleDialogOK()
{
	local int id, index, topIndex;
	local INT64 num;
	local ItemInfo info, topInfo;
	local string param;
	local ItemID cID;

	// ���� ���̾�α� �� ���� �ֳ�? ������..
	if(DialogIsMine())
	{
		id = DialogGetID();
		num = StringToInt64( DialogGetString() );
		cID = DialogGetReservedItemID();
		if(id == DIALOG_TOP_TO_BOTTOM && num > IntToInt64(0))
		{
			// Refund������ �� DialogOK�� ȣ�� �� ���� ������ ���ĸ� ����Ͽ� �ϴ� �߰��� ���´�.
			if(m_shopType == ShopBuy)
				topIndex = m_BuyTopListHandle.FindItem(cID);
			else if(m_shopType == ShopSell)
				topIndex = m_SellTopListHandle.FindItem(cID);
			else if(m_shopType == ShopRefund)
				topIndex = m_RefundTopListHandle.FindItem(cID);
			else if(m_shopType == ShopPreview)
				topIndex = m_PreviewTopListHandle.FindItem(cID);

			if(topIndex >= 0)
			{
				if(m_shopType == ShopBuy)
				{
					m_BuyTopListHandle.GetItem(topIndex, topInfo);

					index = m_BuyBottomListHandle.FindItem(cID);
					if(index >= 0)
					{
						m_BuyBottomListHandle.GetItem(index, info);
						info.ItemNum += num;
						m_BuyBottomListHandle.SetItem(index, info);
						AddPrice(num * info.Price);
					}
					else
					{
						info = topInfo;
						info.ItemNum = num;
						info.bShowCount = false;
						m_BuyBottomListHandle.AddItem(info);
						AddPrice(num * info.Price);
					}

					class'UIAPI_INVENWEIGHT'.static.AddWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * num);
				}
				else if(m_shopType == ShopSell)
				{
					m_SellTopListHandle.GetItem(topIndex, topInfo);

					// ���̾�α׿��� ������ ���� �Է��ϴ� �� ����.
					if(topInfo.ItemNum < num)
						num = topInfo.ItemNum;

					// BottomList�� ������ �߰� (��ٱ��Ͽ� ���)
					index = m_SellBottomListHandle.FindItem(cID);
					if(index >= 0)
					{
						m_SellBottomListHandle.GetItem(index, info);
						info.ItemNum += num;
						m_SellBottomListHandle.SetItem(index, info);
						AddPrice(num * info.Price);
					}
					else
					{
						info = topInfo;
						info.ItemNum = num;
						info.bShowCount = false;
						m_SellBottomListHandle.AddItem(info);
						AddPrice(num * info.Price);
					}

					// TopList���� ������ ����, ����
					topInfo.ItemNum -= num;
					if( topInfo.ItemNum <= IntToInt64(0) )
						m_SellTopListHandle.DeleteItem(topIndex);
					else
						m_SellTopListHandle.SetItem(topIndex, topInfo);
				}
				// �籸�Žÿ��� ���� ���̾�α� �ڽ��� �� ���� ����.
				else if(m_shopType == ShopPreview)
				{
					m_PreviewTopListHandle.GetItem(topIndex, topInfo);

					index = m_PreviewBottomListHandle.FindItem(cID);
					if(index >= 0)
					{
						m_PreviewBottomListHandle.GetItem(index, info);
						info.ItemNum += num;
						m_PreviewBottomListHandle.SetItem(index, info);
						AddPrice(num * info.Price);
					}
					else
					{
						info = topInfo;
						info.ItemNum = num;
						info.bShowCount = false;
						m_PreviewBottomListHandle.AddItem(info);
						AddPrice(num * info.Price);
					}
				}
			}
		}
		else if(id == DIALOG_BOTTOM_TO_TOP && num > IntToInt64(0))
		{
			if(m_shopType == ShopBuy)
				index = m_BuyBottomListHandle.GetSelectedNum();
			else if(m_shopType == ShopSell)
				index = m_SellBottomListHandle.GetSelectedNum();
			else if(m_shopType == ShopRefund)
				index = m_RefundBottomListHandle.GetSelectedNum();
			else if(m_shopType == ShopPreview)
				index = m_PreviewBottomListHandle.GetSelectedNum();

			if(index >= 0)
			{
				if(m_shopType == ShopBuy)
				{
					m_BuyBottomListHandle.GetItem(index, info);

					info.ItemNum -= num;
					if(info.ItemNum > IntToInt64(0))
						m_BuyBottomListHandle.SetItem(index, info);
					else 
						m_BuyBottomListHandle.DeleteItem(index);

					class'UIAPI_INVENWEIGHT'.static.ReduceWeight( m_WindowName$".InvenWeight", IntToInt64(info.Weight) * num );

					if(info.ItemNum <= IntToInt64(0))	// ������ ������ �Ǵ� ���� �����ϱ� ����
						num = info.ItemNum + num;

					AddPrice(-num * info.Price);
				}
				else if(m_shopType == ShopSell)
				{
					m_SellBottomListHandle.GetItem(index, info);

					if(info.ItemNum < num)
						num = info.ItemNum;

					info.ItemNum -= num;
					if(info.ItemNum > IntToInt64(0))
						m_SellBottomListHandle.SetItem(index, info);
					else 
						m_SellBottomListHandle.DeleteItem(index);

					topIndex = m_SellTopListHandle.FindItem(cID);
					if(topIndex >=0 && IsStackableItem(info.ConsumeType))
					{
						m_SellTopListHandle.GetItem(topIndex, topInfo);
						topInfo.ItemNum += num;
						m_SellTopListHandle.SetItem(topIndex, topInfo);
					}
					else
					{
						info.ItemNum = num;
						m_SellTopListHandle.AddItem(info);
					}

					if(info.ItemNum <= IntToInt64(0))	// ������ ������ �Ǵ� ���� �����ϱ� ����
						num = info.ItemNum + num;

					AddPrice(-num * info.Price);		
				}
				else if(m_shopType == ShopPreview)
				{
					m_PreviewBottomListHandle.GetItem(index, info);

					info.ItemNum -= num;
					if(info.ItemNum > IntToInt64(0))
						m_PreviewBottomListHandle.SetItem(index, info);
					else 
						m_PreviewBottomListHandle.DeleteItem(index);

					if(info.ItemNum <= IntToInt64(0))	// ������ ������ �Ǵ� ���� �����ϱ� ����
						num = info.ItemNum + num;

					AddPrice(-num * info.Price);
				}
			}
		}
		else if(id == DIALOG_PREVIEW)
		{
			num = IntToInt64(m_PreviewBottomListHandle.GetItemNum());

			if(num > IntToInt64(0))
			{
				// pack every item in BottomList
				ParamAdd(param, "merchant", string(m_merchantID));
				ParamAdd(param, "npc", string(m_npcID));
				ParamAddINT64(param, "num", num);
				for(index = 0; index < Int64ToInt(num); ++index)
				{
					m_PreviewBottomListHandle.GetItem(index, info);
					ParamAddItemIDWithIndex(param, info.ID, index);
				}

				RequestPreviewItem( param );
				HideWindow(m_WindowName);
			}
		}
	}
}

function HandleOpenWindow(string param)
{
	local string type;
	local INT64 adena;
	local string adenaString;
	local WindowHandle m_inventoryWnd;

	ParseString(param, "type", type);
	if(type == "buy")
	{
		Clear();
		m_inventoryWnd = GetWindowHandle("InventoryWnd");
		if(m_inventoryWnd.IsShowWindow())	// close the inventory window
			m_inventoryWnd.HideWindow();

		ParseInt(param, "merchant", m_merchantID); 

		ParseINT64(param, "adena", adena);	
		adenaString = MakeCostStringInt64(adena);
		m_AdenaTextBoxHandle.SetText(adenaString);
		m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText(Int64ToString(adena)));

		m_UserAdena = adena;

		ShowWindow( m_WindowName );
		class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);
		m_shopType = ShopBuy;	// ���� �������� ���� ù shop type�� [����]�̴�. ���� ������ �ǿ� ���� ��ȭ.
	}
	else if(type == "sell")
	{
		m_shopType = ShopSell;
	}
	else if(type == "refund")
	{
		m_shopType = ShopRefund;
	}
	else if(type == "preview")
	{
		Clear();
		m_inventoryWnd = GetWindowHandle("InventoryWnd");
		if(m_inventoryWnd.IsShowWindow())	// close the inventory window
			m_inventoryWnd.HideWindow();

		ParseInt(param, "merchant", m_merchantID); 

		ParseINT64(param, "adena", adena);	
		adenaString = MakeCostStringInt64(adena);
		m_AdenaTextBoxHandle.SetText(adenaString);
		m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText(Int64ToString(adena)));

		ShowWindow( m_WindowName );
		class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);
		m_shopType = ShopPreview;
	}
	else
		m_shopType = ShopNone;

	if(m_shopType == ShopBuy)
	{
		m_TexTransactionBGLine.ShowWindow();
		m_TexPreviewBGLine.HideWindow();
		m_TexRefundSlotBG.HideWindow();
		m_TexBuySellSlotBG.ShowWindow();
		m_TexPreviewSlotBG.HideWindow();

		m_TransactionTabHandle.ShowWindow();
		m_PreviewTabHandle.HideWindow();

		m_BuyTopListHandle.ShowWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.HideWindow();
		m_PreviewTopListHandle.HideWindow();		

		m_BuyBottomListHandle.ShowWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.HideWindow();
		m_PreviewBottomListHandle.HideWindow();

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1434));	// text : [����]
		m_BottomTextBoxHandle.SetText(GetSystemString(139));	// text : [���Ը��]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(142));// text : [���ž�]
	}
	else if(m_shopType == ShopPreview)
	{
		ParseInt(param, "npc", m_npcID);

		m_TexTransactionBGLine.HideWindow();
		m_TexPreviewBGLine.ShowWindow();
		m_TexRefundSlotBG.HideWindow();
		m_TexBuySellSlotBG.HideWindow();
		m_TexPreviewSlotBG.ShowWindow();

		m_TransactionTabHandle.HideWindow();
		m_PreviewTabHandle.ShowWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.HideWindow();
		m_PreviewTopListHandle.ShowWindow();		

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.HideWindow();
		m_PreviewBottomListHandle.ShowWindow();

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1337));	// text : [Ȯ��]
		m_BottomTextBoxHandle.SetText(GetSystemString(812));	// text : [���� ���]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(813));// text : [���]
	}

	if(m_itemEnchantWndHandle.IsShowWindow())
	{
		m_itemEnchantWndScript.OnClickButton("ExitBtn");
	}
	m_itemEnchantWndScript.SetIsShopping(true);
}

function HandleAddItem(string param)
{
	local ItemInfo info;
	
	ParamToItemInfo(param, info);
	if(m_shopType == ShopBuy && info.ItemNum > IntToInt64(0))
		info.bShowCount = true;

	if(m_shopType == ShopBuy)
		m_BuyTopListHandle.AddItem(info);
	else if(m_shopType == ShopSell)
		m_SellTopListHandle.AddItem(info);
	else if(m_shopType == ShopRefund)
		m_RefundTopListHandle.AddItem(info);
	else if(m_shopType == ShopPreview)
		m_PreviewTopListHandle.AddItem(info);
}

function AddPrice( INT64 price )
{
	local string adena;
	
	m_currentPrice = m_currentPrice + price;
	
	adena = MakeCostStringInt64( m_currentPrice );
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".PriceText", adena);
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName$".PriceText", ConvertNumToText(Int64ToString(m_currentPrice)));
}

function HandleOKButton()
{
	local string	param;
	local int		topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo	topInfo, bottomInfo;
	local INT64		limitedItemCount;
	//local int		buyCount, refundCount, indexForDisassemble;

	if(m_isCompleteTransaction)
		return;

	m_LastShopType = m_shopType;

	// ���� ���¿��� ����ó��
	if(m_shopType == ShopBuy)
	{
		topCount = m_BuyTopListHandle.GetItemNum();

		for(topIndex = 0; topIndex < topCount; ++topIndex)
		{
			m_BuyTopListHandle.GetItem(topIndex, topInfo);
			if(topInfo.ItemNum > IntToInt64(0))		// this item can be purchased only by limited number
			{
				limitedItemCount = IntToInt64(0);
				// search in BottomList for same classID
				bottomCount = m_BuyBottomListHandle.GetItemNum();
				for(bottomIndex=0; bottomIndex < bottomCount; ++bottomIndex)	// match found, then check whether the number exceeds limited number
				{
					m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);
					if(IsSameClassID(bottomInfo.ID, topInfo.ID))
						limitedItemCount += bottomInfo.ItemNum;
				}

				//debug("limited Item count " $ limitedItemCount );
				if(limitedItemCount > topInfo.ItemNum)
				{
					// warning dialog
					DialogShow(DIALOG_Modalless, DIALOG_WARNING, GetSystemMessage(1338));
					return;
				}
			}
		}

		if(m_currentPrice > m_UserAdena)
		{
			DialogShow(DIALOG_Modal, DIALOG_OK, GetSystemMessage(279));
			m_isCompleteTransaction = false;
			return;
		}
	}

	// ���� ����, ���� ó��
	if(m_shopType == ShopBuy)
	{
		bottomCount = m_BuyBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);

				ParamAdd(param, "ClassID_" $ bottomIndex, string(bottomInfo.ID.ClassID));
				ParamAddInt64(param, "Count_" $ bottomIndex, bottomInfo.ItemNum);
			}

			RequestBuyItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopSell)
	{
		bottomCount = m_SellBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAddItemIDWithIndex(param, bottomInfo.ID, bottomIndex);
				ParamAddInt64(param, "Count_" $ bottomIndex, bottomInfo.ItemNum);
			}

			RequestSellItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopRefund)
	{
		bottomCount = m_RefundBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_RefundBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAdd(param, "index_" $ bottomIndex, string(bottomInfo.ID.ServerID));
			}

			RequestRefundItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopPreview)
	{
		bottomCount = m_PreviewBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			DialogSetID(DIALOG_PREVIEW);
			DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(1157));
		}	

		//HideWindow(m_WindowName);
	}
}

function HandleEndTransactionList(string param)
{
	local int WindowOpenType;

	ParseInt(param, "type", WindowOpenType); 

	if(m_LastShopType == ShopSell)
	{
		m_TransactionTabHandle.SetTopOrder(1, false);
		m_shopType = ShopSell;

		m_BuyBottomListHandle.Clear();
		m_RefundBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.ShowWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.HideWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.ShowWindow();
		m_RefundTopListHandle.HideWindow();	

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.ShowWindow();
		m_RefundBottomListHandle.HideWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1157));	// text : [�Ǹ�]
		m_BottomTextBoxHandle.SetText(GetSystemString(137));	// text : [�ǸŸ��]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(143));// text : [�Ǹž�]
	}
	else if(m_LastShopType == ShopRefund)
	{
		m_TransactionTabHandle.SetTopOrder(2, false);
		m_shopType = ShopRefund;

		m_BuyBottomListHandle.Clear();
		m_SellBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.HideWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.ShowWindow();

		m_BuyTopListHandle.HideWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.ShowWindow();	

		m_BuyBottomListHandle.HideWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.ShowWindow();	

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(2028));	// text : [�籸��]
		m_BottomTextBoxHandle.SetText(GetSystemString(2205));	// text : [�籸�Ÿ��]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(2206));// text : [�籸�ž�]
	}	
	else
		m_shopType = ShopBuy;

	if(WindowOpenType == 0)
	{
		m_TransactionTabHandle.SetTopOrder(0, false);
		m_shopType = ShopBuy;

		m_SellBottomListHandle.Clear();
		m_RefundBottomListHandle.Clear();

		m_PriceTextBoxHandle.SetText("0");
		m_PriceTextBoxHandle.SetTooltipString("");

		m_TexBuySellSlotBG.ShowWindow();	
		m_TexPreviewSlotBG.HideWindow();		
		m_TexRefundSlotBG.HideWindow();

		m_BuyTopListHandle.ShowWindow();
		m_SellTopListHandle.HideWindow();
		m_RefundTopListHandle.HideWindow();	

		m_BuyBottomListHandle.ShowWindow();
		m_SellBottomListHandle.HideWindow();
		m_RefundBottomListHandle.HideWindow();

		// SetNameText??
		m_OkButtonHandle.SetNameText(GetSystemString(1434));	// text : [����]
		m_BottomTextBoxHandle.SetText(GetSystemString(139));	// text : [���Ÿ��]
		m_PriceConstTextBoxHandle.SetText(GetSystemString(142));// text : [���ž�]	
	}
	else if(WindowOpenType == 2)
	{
		DialogShow(DIALOG_Modal, DIALOG_OK, GetSystemMessage(279));
		m_isCompleteTransaction = false;
	}
	else if(WindowOpenType == 3)
	{
		DialogShow(DIALOG_Modal, DIALOG_OK, GetSystemMessage(352));
		m_isCompleteTransaction = false;
	}
	else if(WindowOpenType == 1 && m_isCompleteTransaction)
	{
		//Debug("==========================================");
		//Debug("system message : " @ GetSystemMessage(3092)); : �ý��۸޽����� ����� �������� Ȯ�� �Ϸ�

		//DialogShow(DIALOG_Modal, DIALOG_OK, GetSystemMessage(3092));
		
		// ���Ű� �Ϸ� �Ǿ��ٴ� �޼����� �ѷ��ش�.
		AddSystemMessage(3092);		

		m_isCompleteTransaction = false;

		// ���� �����츦 �ݴ´�. 
		HideWindow(m_WindowName);	

	}
}

function setEnableWindow(bool flag)
{
	if (flag)
	{
		me.EnableWindow();
	}
	else
	{
		me.DisableWindow();
	}
}


defaultproperties
{
    
}
