//------------------------------------------------------------------------------------------------------------------------
//
// ����         : PrivateShopWnd  (���� ����) 
//
// ���� ������  : Flagoftiger, Elsacred
// �ּ� �� ���� : Dongland (From 2009.07)
//------------------------------------------------------------------------------------------------------------------------
class PrivateShopWnd extends UICommonAPI;

//------------------------------------------------------------------------------------------------------------------------
// const
//------------------------------------------------------------------------------------------------------------------------
const DIALOG_TOP_TO_BOTTOM          = 111;
const DIALOG_BOTTOM_TO_TOP          = 222;
const DIALOG_ASK_PRICE	            = 333;
const DIALOG_CONFIRM_PRICE          = 444;
const DIALOG_EDIT_SHOP_MESSAGE      = 555;		// �޽��� ����
const DIALOG_CONFIRM_PRICE_FINAL    = 666;		// Ȯ�� ��ư �������� ������ Ȯ��
const DIALOG_EDIT_BULK_SHOP_MESSAGE = 888;		// ��ũ�� �޽���. �ϰ��Ǹ� �޽���.


//const DIALOG_OVER_PRICE = 777;				// ���� ������ 20���� ������� ���� �޼���, 
												// Ư���� ���̵� �Ҵ��� �ʿ�� ����δ�. 

//------------------------------------------------------------------------------------------------------------------------
// Variables  
//------------------------------------------------------------------------------------------------------------------------
enum PrivateShopType
{
	PT_None,			// dummy
	PT_Buy,				// �ٸ� ����� ���� �������� ������ ������ ��
	PT_Sell,			// �ٸ� ����� ���� �������� ������ �Ǹ��� ��
	PT_BuyList,			// �ڽ��� ���� ���� ���� ����Ʈ
	PT_SellList,		// �ڽ��� ���� ���� �Ǹ� ����Ʈ
};

var PrivateShopType m_type;
var bool			m_bBulk;			 // �ϰ� �������� ��Ÿ��. PT_Buy�� ��쿡�� �ǹ̰� �ִ�.
var int				m_merchantID;
var int				m_buyMaxCount;
var int				m_sellMaxCount;

//------------------------------------------------------------------------------------------------------------------------
// Control Handle
//------------------------------------------------------------------------------------------------------------------------
var ItemWindowHandle	m_hPrivateShopWndTopList;
var ItemWindowHandle	m_hPrivateShopWndBottomList;

//------------------------------------------------------------------------------------------------------------------------
//
// Event Functions.
//
//------------------------------------------------------------------------------------------------------------------------
function OnRegisterEvent()
{
	registerEvent( EV_PrivateShopOpenWindow );
	registerEvent( EV_PrivateShopAddItem );
	registerEvent( EV_SetMaxCount );
	registerEvent( EV_DialogOK );
}


function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	m_hPrivateShopWndTopList=GetItemWindowHandle("PrivateShopWnd.TopList");
	m_hPrivateShopWndBottomList=GetItemWindowHandle("PrivateShopWnd.BottomList");

	m_merchantID = 0;
	m_buyMaxCount = 0;
	m_sellMaxCount = 0;
}


function OnSendPacketWhenHiding()
{
	RequestQuit();
}


function OnHide()
{
	local DialogBox DialogBox;
	DialogBox = DialogBox(GetScript("DialogBox"));
	if (class'UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
	{
		DialogBox.HandleCancel();
	}
	Clear();
}


function OnEvent(int Event_ID,string param)
{
	// debug("PrivateShopWnd OnEvent " $ param);

	switch( Event_ID )
	{
		case EV_PrivateShopOpenWindow:
			Clear();
			HandleOpenWindow(param);
			break;
		case EV_PrivateShopAddItem:
			HandleAddItem(param);
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
	//debug("OnClickButton " $ ControlName );
	if( ControlName == "UpButton" )
	{
		index = m_hPrivateShopWndBottomList.GetSelectedNum();
		MoveItemBottomToTop( index, false );
	}
	else if( ControlName == "DownButton" )
	{
		index = m_hPrivateShopWndTopList.GetSelectedNum();
		MoveItemTopToBottom( index, false );
	}
	else if( ControlName == "OKButton" )
	{
		HandleOKButton( true );
	}
	else if( ControlName == "StopButton" )
	{
		RequestQuit();
		HideWindow("PrivateShopWnd");
	}
	else if( ControlName == "MessageButton" )
	{
		DialogSetDefaultOK();	
		DialogSetEditBoxMaxLength(29);	
		DialogSetID( DIALOG_EDIT_SHOP_MESSAGE  );

		DialogShow(DIALOG_Modalless, DIALOG_OKCancelInput, GetSystemMessage( 334 ) );

		if( m_type == PT_SellList && !m_bBulk)
		{ 
			DialogSetString( GetPrivateShopMessage("sell") );
			debug ("�Ǹ� - �޽��� ����" @ GetPrivateShopMessage("sell") );
		}
		else if (m_type == PT_SellList && m_bBulk)
		{
			// Debug("GetPrivateShopMessageBulk" @ GetPrivateShopMessage("bulksell"));
			DialogSetString( GetPrivateShopMessage("bulksell") );

			debug ("�ϰ��Ǹ� - �޽��� ����" @ GetPrivateShopMessage("bulksell") );
		}
		else if( m_type == PT_BuyList )
		{
			DialogSetString( GetPrivateShopMessage("buy") );
			debug ("���� - �޽��� ����" @ GetPrivateShopMessage("buy") );
			
		}

		//branch
		//DialogSetDefaultOK();	
		//end of branch
		DialogShow(DIALOG_Modalless, DIALOG_OKCancelInput, GetSystemMessage( 334 ) );
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


function OnClickItem( string ControlName, int index )
{
	local WindowHandle m_dialogWnd;

	if(CREATE_ON_DEMAND==0)
		m_dialogWnd = GetHandle( "DialogBox" );
	else
		m_dialogWnd = GetWindowHandle( "DialogBox" );

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

	// debug("OnDropItem strID " $ strID $ ", src=" $ info.DragSrcName);
	
	index = -1;
	if( strID == "TopList" && info.DragSrcName == "BottomList" )
	{
		if( m_type == PT_Buy || m_type == PT_SellList  )
			index = m_hPrivateShopWndBottomList.FindItem( info.ID );        	// Find With ServerID
		else if( m_type == PT_Sell || m_type == PT_BuyList )
			index = m_hPrivateShopWndBottomList.FindItemWithAllProperty(info);	// Find With ClassID
		if( index >= 0 )
			MoveItemBottomToTop( index, info.AllItemCount > IntToInt64(0) );
	}
	else if( strID == "BottomList" && info.DragSrcName == "TopList" )
	{
		if( m_type == PT_Buy || m_type == PT_SellList  )
			index = m_hPrivateShopWndTopList.FindItem(info.ID );	        	//Find With ServerID
		else if( m_type == PT_Sell || m_type == PT_BuyList )
			index = m_hPrivateShopWndTopList.FindItemWithAllProperty( info);	//Find With ClassID
		if( index >= 0 )
			MoveItemTopToBottom( index, info.AllItemCount > IntToInt64(0) );
	}

	
}

//------------------------------------------------------------------------------------------------------------------------
//
// General Functions.
//
//------------------------------------------------------------------------------------------------------------------------


function Clear()
{
	m_type = PT_None;
	m_merchantID = -1;
	m_bBulk = false;

	m_hPrivateShopWndTopList.Clear();
	m_hPrivateShopWndBottomList.Clear();

	class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.PriceText", "");

	class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.AdenaText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.AdenaText", "");
}

function RequestQuit()
{
	if( m_type == PT_BuyList )
	{
		RequestQuitPrivateShop("buy");
	}
	else if( m_type == PT_SellList && !m_bBulk)
	{
		RequestQuitPrivateShop("sell");
	}
	else if( m_type == PT_SellList && m_bBulk)
	{
		RequestQuitPrivateShop("bulksell");
	}
}

function MoveItemTopToBottom( int index, bool bAllItem )
{
	local ItemInfo info, bottomInfo;
	local int		num, i, bottomIndex;

	if( m_hPrivateShopWndTopList.GetItem(index, info) )
	{
		if( m_type == PT_SellList )
		{
			// Ask price
			DialogSetID( DIALOG_ASK_PRICE );
			DialogSetReservedItemID( info.ID );				// ServerID
			DialogSetReservedInt3( int(bAllItem) );			// ��ü�̵��̸� ���� ���� �ܰ踦 �����Ѵ�
			DialogSetEditType("number");
			DialogSetParamInt64( IntToInt64(-1) );
			DialogSetDefaultOK();
			DialogShow(DIALOG_Modalless, DIALOG_NumberPad, GetSystemMessage(322) );
		}
		else if( m_type == PT_BuyList )
		{
			// Ask price
			DialogSetID( DIALOG_ASK_PRICE );
			// DialogSetReservedItemID( info.ID );				// ClassID delete by elsacred
			// DialogSetReservedInt( info.Enchanted );			// Enchant �� ���� delete by elsacred
			DialogSetReservedItemInfo(info);			    	// info ��ü�� �Ѱ��� edit by elsacre
			DialogSetEditType("number");
			DialogSetParamInt64( IntToInt64(-1) );
			DialogSetDefaultOK();	
			DialogShow(DIALOG_Modalless, DIALOG_NumberPad, GetSystemMessage(585) );
		}
		else if( m_type == PT_Sell || m_type == PT_Buy )
		{
			if( m_type == PT_Sell && info.bDisabled )			// ������ ���� �����̰� �� ������ ���� �� �׳� ����
				return;

			if( m_type == PT_Buy && m_bBulk )					// ������ �ϰ� ���� �� ���. ��� �������� �̵����Ѿ� �Ѵ�.
			{
				num = m_hPrivateShopWndTopList.GetItemNum();
				for( i=0 ; i<num ; ++i )
				{
					m_hPrivateShopWndTopList.GetItem(i, info); 
					m_hPrivateShopWndBottomList.AddItem(info);
				}
				m_hPrivateShopWndTopList.Clear();
		
				AdjustPrice();
				AdjustCount();
			}
			else
			{
				if( !bAllItem && IsStackableItem( info.ConsumeType ) && info.ItemNum > IntToInt64(1) )		// ���� �����
				{
					DialogSetID( DIALOG_TOP_TO_BOTTOM );
					if( m_type == PT_Sell )
					{
						//	DialogSetReservedItemID( info.ID );	// ClassID
						//	DialogSetReservedInt(Info.Enchanted); // Enchant �� ����
						// ItemInfo
						DialogSetReservedItemInfo( info );	
					}
					else if( m_type == PT_Buy )
					{
						// ServerID
						DialogSetReservedItemID( info.ID );	
					}

					DialogSetParamInt64( info.ItemNum );
					DialogSetDefaultOK();	
					DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ) );
				}
				else
				{
					if( m_type == PT_Buy )
					{
						// ServerID
						bottomIndex = m_hPrivateShopWndBottomList.FindItem(info.ID );		
					}
					else if( m_type == PT_Sell )
					{
						// ClassID
						bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( info );		
					}

					// �Ʒ��ʿ� �̹� �ִ� �������̰� ������ �������̶�� ������ �����ش�.
					if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
					{
						m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );
						bottomInfo.ItemNum += info.ItemNum;
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					}
					else
					{
						m_hPrivateShopWndBottomList.AddItem( info );
					}

					m_hPrivateShopWndTopList.DeleteItem( index );

					AdjustPrice();
					AdjustCount();
				}
			}

			if( m_type == PT_Buy || m_type == PT_BuyList )
			{
				AdjustWeight();
			}
		}
	}
}

function MoveItemBottomToTop( int index, bool bAllItem )
{
	local ItemInfo info, topInfo;
	local int		stringIndex, num, i, topIndex;
	if( m_hPrivateShopWndBottomList.GetItem( index, info) )
	{
		// ������ �ϰ� ���� �� ���. ��� �������� �̵����Ѿ� �Ѵ�.
		if( m_type == PT_Buy && m_bBulk )		
		{
			num = m_hPrivateShopWndBottomList.GetItemNum();
			for( i=0 ; i<num ; ++i )
			{
				m_hPrivateShopWndBottomList.GetItem(i, info); 
				m_hPrivateShopWndTopList.AddItem( info );
			}
			m_hPrivateShopWndBottomList.Clear();

			AdjustPrice();
			AdjustCount();
		}
		// ���� ���Ÿ� ���� ����� ��� �ٸ� ó���� �ʿ��� �� �Ͽ�
		else	
		{
			// � �ű���� �����
			if( !bAllItem && IsStackableItem( info.ConsumeType ) && info.ItemNum > IntToInt64(1) )		
			{
				DialogSetID( DIALOG_BOTTOM_TO_TOP );
				if( m_type == PT_Buy || m_type == PT_SellList )
				{
					// ServerID
					DialogSetReservedItemID( info.ID );			
				}
				else if( m_type == PT_Sell || m_type == PT_BuyList )
				{
					// DialogSetReservedItemID( info.ID );			// ClassID
					// DialogSetReservedInt( info.Enchanted );		// Enchant �ѹ�
					DialogSetReservedItemInfo( info );		     	// info
				}

				DialogSetParamInt64( info.ItemNum );

				switch( m_type )
				{
				case PT_SellList:
					stringIndex = 72;
					break;
				case PT_BuyList:
					stringIndex = 571;
					break;
				case PT_Sell:
					stringIndex = 72;
					break;
				case PT_Buy:
					stringIndex = 72;
					break;
				default:
					break;
				}

				DialogSetDefaultOK();	
				DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(stringIndex), info.Name, "" ) );
			}
			else
			{
				m_hPrivateShopWndBottomList.DeleteItem( index );

				if( m_type != PT_BuyList )
				{
					if( m_type == PT_Buy || m_type == PT_SellList )
						topindex = m_hPrivateShopWndTopList.FindItem(info.ID );		                // ServerID
					else if( m_type == PT_Sell )
						topindex = m_hPrivateShopWndTopList.FindItemWithAllProperty( info );		// ClassID

					if( topIndex >=0 && IsStackableItem( info.ConsumeType ) )	                	// ������ �������̸� ������ ������Ʈ
					{
						m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
						topInfo.ItemNum += info.ItemNum;
						m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
					}
					else
					{
						m_hPrivateShopWndTopList.AddItem( info );
					}
				}

				AdjustPrice();
				AdjustCount();
			}
		}
		// Debug("m_type ==>" $ m_type);
		if( m_type == PT_Buy || m_type == PT_BuyList )
		{
			AdjustWeight();
		}
	}
}

function HandleDialogOK()
{
	local int id, bottomIndex, topIndex, i, allItem;
	local ItemInfo bottomInfo, topInfo;
	local ItemID scID;
	local ItemInfo scInfo;
	local INT64 inputNum;

	local int currentItemNum;
	local bool enableAddCurrentItemFlag;

	currentItemNum = 0;

	if( DialogIsMine() )
	{
		id = DialogGetID();
	
		inputNum = StringToInt64( DialogGetString() );
		scID = DialogGetReservedItemID();
		DialogGetReservedItemInfo(scInfo);
		
		// ���̾�α״� ���ʴ�� ���� ����(DIALOG_ASK_PRICE)-> 
		// ������ �⺻ ���ݰ� ���̰� �� ��� ���� Ȯ��(DIALOG_CONFIRM_PRICE)->
		// �������̵�(DIALOG_TOP_TO_BOTTOM)�� ������� ���ȴ�
		
		// PT_SellList�� PT_BuyList�� �⺻������ �����ϴ�.
		if( m_type == PT_SellList )
		{
			// ������� �������� �ű��.
			if( id == DIALOG_TOP_TO_BOTTOM && inputNum > IntToInt64(0) )			         
			{
				// <- ServerID ->
				topIndex = m_hPrivateShopWndTopList.FindItem( scID );        	 
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					// <- ServerID ->
					bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );
					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );
					
					// �Ʒ��ʿ� �̹� �ִ� �������̰� ������ �������̶�� ������ ����� ������ �����ش�.
					if( bottomIndex >= 0 && IsStackableItem( bottomInfo.ConsumeType ) )			
					{
						bottomInfo.Price = DialogGetReservedInt2();
						bottomInfo.ItemNum += Min64( inputNum, topInfo.ItemNum );
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					}
					// ���ο� �������� �ִ´�
					else					
					{
						bottomInfo = topInfo;
						bottomInfo.ItemNum = Min64( inputNum, topInfo.ItemNum );
						bottomInfo.Price = DialogGetReservedInt2();
						m_hPrivateShopWndBottomList.AddItem( bottomInfo );
					}

					// ���� �������� ó��
					topInfo.ItemNum -= inputNum;
					if( topInfo.ItemNum <= IntToInt64(0) )
						m_hPrivateShopWndTopList.DeleteItem( topIndex );
					else
						m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
				}
				AdjustPrice();
				AdjustCount();
			}
			// �Ʒ��� ���� ���� ���� �Ű��ش�.
			else if( id == DIALOG_BOTTOM_TO_TOP && inputNum > IntToInt64(0) )		
			{

				// <- ServerID ->
				bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );
				if( bottomIndex >= 0 )
				{
					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );

					// <- ServerID ->
					topIndex = m_hPrivateShopWndTopList.FindItem( scID );

					if( topIndex >=0 && IsStackableItem( bottomInfo.ConsumeType ) )
					{
						m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
						topInfo.ItemNum += Min64( inputNum, bottomInfo.ItemNum );
						m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
					}
					else
					{
						topInfo = bottomInfo;
						topInfo.ItemNum = Min64( inputNum, bottomInfo.ItemNum );
						m_hPrivateShopWndTopList.AddItem( topInfo );
					}

					bottomInfo.ItemNum -= inputNum;
					if( bottomInfo.ItemNum > IntToInt64(0) )
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					else 
						m_hPrivateShopWndBottomList.DeleteItem( bottomIndex );
				}
				AdjustPrice();
				AdjustCount();
			}
			else if( ID == DIALOG_CONFIRM_PRICE )
			{
				// <- ServerID ->
				topIndex = m_hPrivateShopWndTopList.FindItem( scID );;
				if( topIndex >= 0 )
				{
					allItem = DialogGetReservedInt3();
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );

					// stackable?	1���϶��� ������ ���� �ʽ��ϴ�. -innowind
					if( allItem == 0 && IsStackableItem( topInfo.ConsumeType ) && topInfo.ItemNum != IntToInt64(1))		
					{
						DialogSetID( DIALOG_TOP_TO_BOTTOM );
						//������ �Է����� �ʾҴٸ� 1�� �������ش�. 
						if(topInfo.ItemNum  == IntToInt64(0)) topInfo.ItemNum  = IntToInt64(1);	
						DialogSetParamInt64( topInfo.ItemNum );
						DialogSetDefaultOK();	
						DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), topInfo.Name, "" ) );
					}
					else
					{
						if( allItem == 0 )
							topInfo.ItemNum = IntToInt64(1);
						topInfo.Price = DialogGetReservedInt2();
						// <- ServerID ->
						bottomIndex = m_hPrivateShopWndBottomList.FindItem( topInfo.ID );
						if( bottomIndex >= 0 && IsStackableItem( topInfo.ConsumeType ) )
						{
							// ��ü!
							m_hPrivateShopWndBottomList.GetItem(  bottomIndex, bottomInfo );		
							topInfo.ItemNum += bottomInfo.ItemNum;
							m_hPrivateShopWndBottomList.SetItem(  bottomIndex, topInfo );
						}
						else
						{
							m_hPrivateShopWndBottomList.AddItem( topInfo );
						}
						m_hPrivateShopWndTopList.DeleteItem( topIndex );

						AdjustPrice();
						AdjustCount();
					}
				}
			}
			else if( id == DIALOG_ASK_PRICE && inputNum > IntToInt64(0) )
			{
				// <- ServerID ->
				topIndex = m_hPrivateShopWndTopList.FindItem( scID );
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					
					//debug("DIALOG_ASK_PRICE defaultPrice : " $ topInfo.DefaultPrice $ ", entered price: " $ inputNum );
					// if specified price is unconventional, ask confirm

					//1000�ﰡ ������ ���� �ʰ� ������ �ѷ��ش�. �׳� 10000000000�� �ν��������ϹǷ� ��Ʈ���� Ÿ��ĳ�����ϴ¹�����
					if( inputNum >= StringToInt64("100000000000") )	
					{
						//DialogSetID( DIALOG_OVER_PRICE );
						DialogShow(DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(1369) );					
					}
					else if( !IsProperPrice( topInfo, inputNum ) )
					{
						//debug("strange price warning");
						DialogSetID( DIALOG_CONFIRM_PRICE );
						// <- ServerID ->
						DialogSetReservedItemID( topInfo.ID );
						// price
						DialogSetReservedInt2( inputNum );				
						DialogSetDefaultOK();	
						DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(569) );
					}
					else
					{
						allItem = DialogGetReservedInt3();

						// stackable?
						if( allItem == 0 && IsStackableItem( topInfo.ConsumeType ) )		
						{
							//debug("stackable item");
							DialogSetID( DIALOG_TOP_TO_BOTTOM );
							// <- ServerID ->
							DialogSetReservedItemID( topInfo.ID );
							// price
							DialogSetReservedInt2( inputNum );				
							DialogSetReservedInt3( allItem );
							DialogSetParamInt64( topInfo.ItemNum );
							DialogSetDefaultOK();	
							DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), topInfo.Name, "" ) );
						}
						else
						{
							//debug("nonstackable item");
							if( allItem == 0 )
								topInfo.ItemNum = IntToInt64(1);
							topInfo.Price = inputNum;
							bottomIndex = m_hPrivateShopWndBottomList.FindItem( topInfo.ID );	// ServerID
							if( bottomIndex >= 0 && IsStackableItem( topInfo.ConsumeType ) )
							{
								m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );		// ��ü!-_-
								topInfo.ItemNum += bottomInfo.ItemNum;
								m_hPrivateShopWndBottomList.SetItem( bottomIndex, topInfo );
							}
							else
							{
								m_hPrivateShopWndBottomList.AddItem( topInfo );
							}
							m_hPrivateShopWndTopList.DeleteItem( topIndex );

							AdjustPrice();
							AdjustCount();
						}
					}
				}
			}
			else if( id == DIALOG_EDIT_SHOP_MESSAGE )
			{
				if (!m_bBulk)
				{
					SetPrivateShopMessage( "sell", DialogGetString() );
				}
				else
				{					
					//~ debug ("�޽��� ����- �ϰ��Ǹ�");
					SetPrivateShopMessage( "bulksell", DialogGetString() );
				}
			}
		}
		// PT_BuyList
		else if( m_type == PT_BuyList )
		{
			// ������� �������� �ű��.
			if( id == DIALOG_TOP_TO_BOTTOM && inputNum > IntToInt64(0) )					
			{
				
				// ClassID
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );	
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					// ClassID
					bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );	

					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );
					// �Ʒ��ʿ� �̹� �ִ� �������̰� ������ �������̶�� ������ ����� ������ �����ش�.
					if( bottomIndex >= 0 && IsStackableItem( bottomInfo.ConsumeType ) )			
					{
						//debug("BuyList StackableItem addnum:" $ inputNum $ ", set price to : " $ DialogGetReservedInt2());
						bottomInfo.Price = DialogGetReservedInt2();
						bottomInfo.ItemNum += inputNum;
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
							
						AdjustPrice();

						// �̰ɷ� ��.
						return;		
					}
					i = m_hPrivateShopWndBottomList.GetItemNum();

					if( bottomIndex >= 0 )					
					{	
						// �ߺ��Ǵ� �������� ��� �����.
						i = m_hPrivateShopWndBottomList.GetItemNum();
						//debug("BuyList Removing Items");
						while( i >= 0 )
						{
							m_hPrivateShopWndBottomList.GetItem( i, bottomInfo );
							if( IsSameClassID(bottomInfo.ID, scID) )
								m_hPrivateShopWndBottomList.DeleteItem( i );
							--i;
						};
					}
					currentItemNum = i;
					enableAddCurrentItemFlag = false;

					// ���� ������ (��: ����ź)
					if( IsStackableItem( topInfo.ConsumeType ) )
					{
						if (currentItemNum + 1 <= m_buyMaxCount)
						{
							//debug("BuyList Add stackable Item");
							bottomInfo = topInfo;
							bottomInfo.ItemNum = inputNum;
							bottomInfo.Price = DialogGetReservedInt2();
							m_hPrivateShopWndBottomList.AddItem( bottomInfo );
							enableAddCurrentItemFlag = true;
						}
					}
					// ���� ������ (��: ��)
					else
					{
						// Debug("currentItemNum : " $ currentItemNum);
						// Debug("inputNum       : " $ inputNum);
						// Debug("m_buyMaxCount  : " $ m_buyMaxCount);

						// currentItemNum �� -1�� ������ ��찡 �ִ�.
						if (currentItemNum < 0)
						{
							currentItemNum = m_hPrivateShopWndBottomList.GetItemNum();
						}
						if ((currentItemNum + Int64ToInt(inputNum)) <= m_buyMaxCount)
						{														
							//debug("BuyList Add non-stackable Item");
							// ���ο� �������� ������ŭ �ִ´�
							// ���� ������ �ִ� ���� �ʰ� �Ѵٸ� ���� ��� ��Ͽ� ���� �ʴ´�.
								bottomInfo = topInfo;
								bottomInfo.ItemNum = IntToInt64(1);
								bottomInfo.Price = DialogGetReservedInt2();
								for( i=0 ; i < Int64ToInt(inputNum) ; ++i )
								{
									if (m_hPrivateShopWndBottomList.GetItemNum() < m_buyMaxCount)
									{

										m_hPrivateShopWndBottomList.AddItem( bottomInfo );
										enableAddCurrentItemFlag = true;
									}
								}
						}
					}

					// ���� �߰� �Ǵ� ������ ������ �ʰ� �Ǿ� �߰� �ȵǴ� ��� �˶� �޼��� ���
					// "�����Ϸ��� ������ ������ �߸��Ǿ����ϴ�."
					if (enableAddCurrentItemFlag == false)
					{
						DialogShow( DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(351) );
					}

					// Debug("====> ������ ���� ��� ��Ͽ� �ִ� ������ �� : " $ m_hPrivateShopWndBottomList.GetItemNum());
					// Debug("====> ���� �Է��� �� : " $ inputNum);
					
				}
				// ����. ���ϴ� �������� ���� ���� ǥ�ñ� ����
				AdjustWeight();

				AdjustPrice();
				AdjustCount();
			}
			else if( id == DIALOG_BOTTOM_TO_TOP && inputNum > IntToInt64(0) )		// �Ʒ��� ���� ��������.
			{
				bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );	// ClassID
				if( bottomIndex >= 0 )
				{
					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );
					bottomInfo.ItemNum -= inputNum;
					if( bottomInfo.ItemNum > IntToInt64(0) )
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					else 
						m_hPrivateShopWndBottomList.DeleteItem( bottomIndex );
				}
			}
			else if( ID == DIALOG_CONFIRM_PRICE )			// � ������ ������ ���´�.
			{
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );	// ClassID
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );

					DialogSetID( DIALOG_TOP_TO_BOTTOM );
					DialogSetReservedItemID( topInfo.ID );
					//branch
					//DialogSetParamInt64( topInfo.ItemNum );
					DialogSetParamInt64( IntToInt64(-1));
					//end of branch
					DialogSetDefaultOK();	
					DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(570), topInfo.Name, "" ) );
				}
				// ����. ���ϴ� �������� ���� ���� ǥ�ñ� ����
				// AdjustWeight();

				AdjustPrice();
				AdjustCount();
			}
			else if( id == DIALOG_ASK_PRICE && inputNum > IntToInt64(0) )
			{
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );	// ClassID
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					// if specified price is unconventional, ask confirm
					if( inputNum >= StringToInt64("100000000000") )	//1000���� ������ ���� �ʰ� ������ �ѷ��ش�. 
					{
						//DialogSetID( DIALOG_OVER_PRICE );
						DialogShow(DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(1369) );					
					}
					else if( !IsProperPrice( topInfo, inputNum ) )
					{
						DialogSetID( DIALOG_CONFIRM_PRICE );
						DialogSetReservedItemID( topInfo.ID );
						DialogSetReservedInt2( inputNum );				// price
						DialogSetDefaultOK();	
						DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(569) );
					}
					else
					{
						DialogSetID( DIALOG_TOP_TO_BOTTOM );
						DialogSetReservedItemID( topInfo.ID );
						DialogSetReservedInt2( inputNum );				// price
						//branch
						//DialogSetParamInt64( topInfo.ItemNum );
						DialogSetParamInt64( IntToInt64(-1) );
						//end of branch
						DialogSetDefaultOK();	
						DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(570), topInfo.Name, "" ) );
					}
				}
			}
			else if( id == DIALOG_EDIT_SHOP_MESSAGE )
			{
				SetPrivateShopMessage( "buy", DialogGetString() );
			}
		}
		// PT_Buy and PT_Buy
		else if( m_type == PT_Buy || m_type == PT_Sell )
		{
			// �� ���̾�αװ� �ҷȴٴ� ���� ������ �������̶�� ���� �ǹ��Ѵ�.(�ƴϾ����� 
			// MoveItemTopToBottom() �Լ����� �̹� ������ �̵��� ó������ ���̴�)
			if( id == DIALOG_TOP_TO_BOTTOM && inputNum > IntToInt64(0) )		
			{
				topIndex = -1;
				if( m_type == PT_Buy )
					topIndex = m_hPrivateShopWndTopList.FindItem( scID );	                              // ServerID
				else if( m_type == PT_Sell )
					topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );                // ClassID

				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					
					//����� �纸�� �Է��� ���� ���ٸ� �˾��� ���� ����. 
					if(m_type == PT_Sell  && topInfo.Reserved64 < inputNum)	
					{
						DialogShow(DIALOG_Modalless, DIALOG_Notice, GetSystemMessage(1036) );
					}
					else
					{
						if( m_type == PT_Buy )
							bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );	                  // ServerID
						else if( m_type == PT_Sell )
							bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );  // ClassID	

						m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );

						// ������ ������ �ߺ�
						if( bottomIndex >= 0  )			
						{
							// ������ �����ش�
							bottomInfo.ItemNum += Min64( inputNum, topInfo.ItemNum );		
							m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
						}
						// ���ο� �������� �ִ´�
						else					
						{
							bottomInfo = topInfo;
							bottomInfo.ItemNum = Min64( inputNum, topInfo.ItemNum );
							m_hPrivateShopWndBottomList.AddItem( bottomInfo );
						}
	
						// ���� �������� ó��
						topInfo.ItemNum -= inputNum;

						if( topInfo.ItemNum <= IntToInt64(0) )
							m_hPrivateShopWndTopList.DeleteItem( topIndex );
						else
							m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
					}
				}
				AdjustPrice();
				AdjustCount();
			}
			// �Ʒ��� ���� ���� ���� �Ű��ش�. ���������� �� ���̾�αװ� �ҷȴٴ� ���� ������ ���������� �ǹ�.
			else if( id == DIALOG_BOTTOM_TO_TOP && inputNum > IntToInt64(0) )
			{
				bottomIndex = -1;
				if( m_type == PT_Buy )
					bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );                  	// ServerID
				else if( m_type == PT_Sell )
					bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );	// ClassID

				if( bottomIndex >= 0 )
				{
					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );

					topIndex = -1;

					// ���ʿ� �������� ����
					if( m_type == PT_Buy )
						topIndex = m_hPrivateShopWndTopList.FindItem( scID );	                    // ServerID
					else if( m_type == PT_Sell )
						topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );	    // ClassID

					if( topIndex >=0 )
					{
						m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
						topInfo.ItemNum += Min64( inputNum, bottomInfo.ItemNum );
						m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
					}
					else
					{
						topInfo = bottomInfo;
						topInfo.ItemNum = Min64( inputNum, bottomInfo.ItemNum );
						m_hPrivateShopWndTopList.AddItem( topInfo );
					}

					// �Ʒ����� ������ ������ �ش�.
					bottomInfo.ItemNum -= inputNum;
					if( bottomInfo.ItemNum > IntToInt64(0) )
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					else 
						m_hPrivateShopWndBottomList.DeleteItem( bottomIndex );
				}
				AdjustPrice();
				AdjustCount();
			}
			else if( id == DIALOG_CONFIRM_PRICE_FINAL)
			{
				HandleOKButton( false );
			}

		}

		if( m_type == PT_Buy || m_type == PT_BuyList )
		{
			AdjustWeight(); 			
			AdjustPrice();  //  2009.08.27 �� ������ �������� �Ʒ����� ���� �ø��� �������� ��� ���� ������ ���ϴ� �� ����.
		}
	}
} 


function HandleOpenWindow( string param )
{
	local string type;
	local int bulk;
	local string adenaString;
	local UserInfo	user;
	local WindowHandle m_inventoryWnd;
	local INT64 adena;
	
	if(CREATE_ON_DEMAND==0)
		m_inventoryWnd = GetHandle( "InventoryWnd" );	    //�κ��丮�� ������ �ڵ��� ���´�.
	else
		m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//�κ��丮�� ������ �ڵ��� ���´�.

	Clear();

	ParseString( param, "type", type );
	ParseInt64( param, "adena", adena );
	ParseInt( param, "userID", m_merchantID );
	ParseInt( param, "bulk", bulk );		 	            // �ϰ� �Ǹ�(����)?
	if( bulk > 0 )
	{
		m_bBulk = true;
		SwithBulkOnlyShop();
	}
	else
	{
		m_bBulk = false;
		ResetBulkOnlyShop();
		
	}

	switch( type )
	{
	case "buy":
		m_type = PT_Buy;
		//class'UIAPI_WINDOW'.static.SetWindowTitle("PrivateShopWnd", 1216);
		break;
	case "sell":
		m_type = PT_Sell;
		//class'UIAPI_WINDOW'.static.SetWindowTitle("PrivateShopWnd", 1217);
		break;
	case "buyList":
		m_type = PT_BuyList;
		//class'UIAPI_WINDOW'.static.SetWindowTitle("PrivateShopWnd", 1218);
		break;
	case "sellList":
		m_type = PT_SellList;
		//class'UIAPI_WINDOW'.static.SetWindowTitle("PrivateShopWnd", 131);
		break;
	default:
		break;
	};

	adenaString = MakeCostStringINT64( adena );
	class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.AdenaText", adenaString);
	class'UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.AdenaText", ConvertNumToText(Int64ToString(adena)) );

	if( m_inventoryWnd.IsShowWindow() && m_type == PT_Sell )			//�κ��丮 â�� ���������� �ݾ��ش�. 
	{
		m_inventoryWnd.HideWindow();
	}
	//branch - NPC ��ȭâ�� ��� �ݴ´�.
	ExecuteEvent(EV_NPCDialogWndHide);
	//end of branch
	if (param!="")
	{
		ShowWindow( "PrivateShopWnd" );
		class'UIAPI_WINDOW'.static.SetFocus("PrivateShopWnd");
	}

	if( m_type == PT_BuyList )
	{
		// set tooltip
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.TopList", "Inventory" );
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.BottomList","InventoryPrice1" );

		// Set strings
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.TopText", GetSystemString(1) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.BottomText", GetSystemString(502) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.PriceConstText", GetSystemString(142) );
		class'UIAPI_BUTTON'.static.SetButtonName( "PrivateShopWnd.OKButton", 428 );

		ShowWindow( "PrivateShopWnd.BottomCountText" );
		ShowWindow( "PrivateShopWnd.StopButton" );
		Showwindow( "PrivateShopWnd.MessageButton" );
		ShowWindow( "PrivateShopWnd.OKButton" );
		HideWindow( "PrivateShopWnd.CheckBulk" );

		class'UIAPI_WINDOW'.static.SetWindowTitleByText( "PrivateShopWnd", GetSystemString(498) $ "(" $ GetSystemString(1434) $ ")" );
	}
	else if( m_type == PT_SellList )
	{
		// set tooltip
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.TopList", "Inventory" );
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.BottomList","InventoryPrice1" );

		if( bulk > 0 )
			class'UIAPI_CHECKBOX'.static.SetCheck( "PrivateShopWnd.CheckBulk", true );
		else
			class'UIAPI_CHECKBOX'.static.SetCheck( "PrivateShopWnd.CheckBulk", false );

		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.TopText", GetSystemString(1) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.BottomText", GetSystemString(137) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.PriceConstText", GetSystemString(143) );
		class'UIAPI_BUTTON'.static.SetButtonName( "PrivateShopWnd.OKButton", 428 );

		ShowWindow( "PrivateShopWnd.BottomCountText" );
		ShowWindow( "PrivateShopWnd.StopButton" );
		Showwindow( "PrivateShopWnd.MessageButton" );
		ShowWindow( "PrivateShopWnd.OKButton" );
		ShowWindow( "PrivateShopWnd.CheckBulk" );

		class'UIAPI_WINDOW'.static.SetWindowTitleByText( "PrivateShopWnd", GetSystemString(498) $ "(" $ GetSystemString(1157) $ ")" );
	}
	else if( m_type == PT_Buy )
	{
		// set tooltip
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.TopList", "InventoryPrice1" );
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.BottomList","Inventory" );

		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.TopText", GetSystemString(137) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.BottomText", GetSystemString(139) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.PriceConstText", GetSystemString(142) );
		class'UIAPI_BUTTON'.static.SetButtonName( "PrivateShopWnd.OKButton", 140 );

		HideWindow( "PrivateShopWnd.BottomCountText" );
		HideWindow( "PrivateShopWnd.StopButton" );
		HideWindow( "PrivateShopWnd.MessageButton" );
		ShowWindow( "PrivateShopWnd.OKButton" );
		HideWindow( "PrivateShopWnd.CheckBulk" );

		GetUserInfo( m_merchantID, user );
		if( bulk > 0 )
			class'UIAPI_WINDOW'.static.SetWindowTitleByText( "PrivateShopWnd", GetSystemString(498) $ "(" $ GetSystemString(1198) $ ") - " $ user.Name );
		else
			class'UIAPI_WINDOW'.static.SetWindowTitleByText( "PrivateShopWnd", GetSystemString(498) $ "(" $ GetSystemString(1157) $ ") - " $ user.Name );
	}
	else if( m_type == PT_Sell )
	{
		// set tooltip
		// TTS_INVENTORY|TTS_PRIVATE_BUY(2050), TTES_SHOW_PRICE2(8)
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.TopList", "InventoryPrice2PrivateShop" );
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.BottomList","Inventory" );

		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.TopText", GetSystemString(503) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.BottomText", GetSystemString(137) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.PriceConstText", GetSystemString(143) );
		class'UIAPI_BUTTON'.static.SetButtonName( "PrivateShopWnd.OKButton", 140 );

		HideWindow( "PrivateShopWnd.BottomCountText" );
		HideWindow( "PrivateShopWnd.StopButton" );
		HideWindow( "PrivateShopWnd.MessageButton" );
		ShowWindow( "PrivateShopWnd.OKButton" );
		HideWindow( "PrivateShopWnd.CheckBulk" );

		GetUserInfo( m_merchantID, user );
		class'UIAPI_WINDOW'.static.SetWindowTitleByText( "PrivateShopWnd", GetSystemString(498) $ "(" $ GetSystemString(1434) $ ") - " $ user.Name );
	}
	if( m_bBulk )
	{
		SwithBulkOnlyShop();
	}
	else
	{
		ResetBulkOnlyShop();	
	}
}


function HandleAddItem( string param )
{
	local ItemInfo info;
	local string target;
	ParseString( param, "target", target );
	ParamToItemInfo( param, info );
	if( target == "topList" )
	{
		if( m_type == PT_Sell && info.ItemNum == IntToInt64(0) )
			info.bDisabled = true;
		m_hPrivateShopWndTopList.AddItem( info );
	}
	else if( target == "bottomList" )
	{
		m_hPrivateShopWndBottomList.AddItem( info );
	}
	AdjustPrice();
	AdjustCount();

	// �����찡 ���� �ɶ� ���԰� ���Ӱ� ����, �� ���Žÿ��� �����ϸ� �ȴ�.
	if( m_type == PT_BuyList || m_type == PT_Buy)
	{
		AdjustWeight();
	}

}


function AdjustPrice()
{
	local string adena;
	local int count;
	//local int addPrice;
	local int64 price;		//�����÷ο�� �������� �����ֱ� ���� �����Ͽ����ϴ�. - innowind
	local int64 addPrice64;		
	local ItemInfo info;

	count = m_hPrivateShopWndBottomList.GetItemNum();
	
	while( count > 0 )
	{		
		// �Ʒ��ʿ� �ִ� ���ǵ��� ������ �� �����ش�.
		m_hPrivateShopWndBottomList.GetItem( count - 1, info );
		//addPrice = info.Price * info.ItemNum;	//���⼭ �����÷ο찡 ���� ����������. ���ϴ� �Լ� ��
		addPrice64 = info.Price * info.ItemNum;
		price = price + addPrice64;	// Int64Add( price ,  Int64Add( price , addPrice64 ));  �ٷ� ��������� �ɰ��� ������ ;;
		//price += info.Price * info.ItemNum;

		--count;
	}

	adena = MakeCostStringInt64( price );
	class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceText", adena);
	class'UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.PriceText", ConvertNumToText( Int64ToString( price ) ) );
}


function AdjustCount()
{
	local int num, maxNum;

	if( m_type == PT_SellList )
	{
		maxNum = m_sellMaxCount;
		num = m_hPrivateShopWndBottomList.GetItemNum();
		class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", "(" $ string(num) $ "/" $ string(maxNum) $ ")");
		//debug("AdjustCount SellList num " $ num $ ", maxCount " $ maxNum );
	}
	else if( m_type == PT_BuyList )
	{
		maxNum = m_buyMaxCount;
		num = m_hPrivateShopWndBottomList.GetItemNum();
		class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", "(" $ string(num) $ "/" $ string(maxNum) $ ")");
		//debug("AdjustCount BuyList num " $ num $ ", maxCount " $ maxNum );
	}
}


function AdjustWeight()
{
	local int count;
	local INT64 weight;
	local ItemInfo info;
	class'UIAPI_INVENWEIGHT'.static.ZeroWeight( "PrivateShopWnd.InvenWeight" );

	count = m_hPrivateShopWndBottomList.GetItemNum();

	weight = IntToInt64(0);

	while( count > 0 )
	{		// �Ʒ��ʿ� �ִ� ���ǵ��� ���Ը� �� �����ش�.

		m_hPrivateShopWndBottomList.GetItem( count - 1, info );
		// Debug("===> info.Weight  " @ info.Weight);
		// Debug("===> info.ItemNum " @ info.ItemNum);

		weight += (IntToInt64(info.Weight) * info.ItemNum);

		--count;
	}

	class'UIAPI_INVENWEIGHT'.static.AddWeight( "PrivateShopWnd.InvenWeight", weight );
	
	// Debug("======>" $ String(weight));
}

function HandleOKButton( bool bPriceCheck )		
{
	local string	param;
	local int		itemCount, itemIndex;
	local ItemInfo	itemInfo;

	//debug("HandleOKButton m_type : " $ m_type );
	itemCount = m_hPrivateShopWndBottomList.GetItemNum();
	// Debug("Ȯ�� ��ư üũ " $ String(m_type));	
	// Debug("itemCount" $ String(itemCount));

	if( m_type == PT_SellList )
	{
		// push bulk mode
		if( class'UIAPI_CHECKBOX'.static.IsChecked( "PrivateShopWnd.CheckBulk" ) )
			ParamAdd( param, "bulk", "1" );
		else 
			ParamAdd( param, "bulk", "0" );

		// pack every item in BottomList
		ParamAdd( param, "num", string(itemCount) );
		for( itemIndex=0 ; itemIndex < itemCount; ++itemIndex )
		{
			m_hPrivateShopWndBottomList.GetItem( itemIndex, itemInfo );
			ParamAddItemIDWithIndex( param, itemInfo.ID, itemIndex);
			ParamAddINT64( param, "Count_" $ itemIndex, itemInfo.ItemNum );
			ParamAddINT64( param, "Price_" $ itemIndex, itemInfo.Price );
		}

		// Send packet
		SendPrivateShopList("sellList", param);
	}
	else if( m_type == PT_Buy )
	{
		// Debug("üũ: PT_BUY");

		// push merchantID(other user)
		ParamAdd( param, "merchantID", string(m_merchantID) );

		// pack every item in BottomList
		ParamAdd( param, "num", string(itemCount) );
		for( itemIndex=0 ; itemIndex < itemCount; ++itemIndex )
		{
			m_hPrivateShopWndBottomList.GetItem( itemIndex, itemInfo );
			if( bPriceCheck && !IsProperPrice( itemInfo, itemInfo.Price ) )
				break;
			ParamAddItemIDWithIndex( param, itemInfo.ID, itemIndex);
			ParamAddINT64( param, "Count_" $ itemIndex, itemInfo.ItemNum );
			ParamAddINT64( param, "Price_" $ itemIndex, itemInfo.Price );
		}

		// there's some problem about price...
		if( bPriceCheck && ( itemIndex < itemCount ) )		
		{
			DialogSetID( DIALOG_CONFIRM_PRICE_FINAL );
			DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(569) );
			return;
		}
		// send packet
		else					
		{
			SendPrivateShopList("buy", param);
		}
	}
	else if( m_type == PT_BuyList )
	{
		// ���� ���� �������� 
		// "���� ������ �κ��丮 �ִ���� ���� ��� ������ ���� ���� �ʰ� "������ ������ �߸��Ǿ����ϴ�" �� ����ϰ� ������.
		// pack every item in BottomList

		ParamAdd( param, "num", string(itemCount) );
		
		for( itemIndex=0 ; itemIndex < itemCount; ++itemIndex )
		{
			m_hPrivateShopWndBottomList.GetItem( itemIndex, itemInfo );
			ParamAddItemIDWithIndex( param, itemInfo.ID, itemIndex);
			ParamAdd( param, "Enchanted_" $ itemIndex, string(itemInfo.Enchanted) );
			ParamAdd( param, "Damaged_" $ itemIndex, string(itemInfo.Damaged) );
			ParamAddINT64( param, "Count_" $ itemIndex, itemInfo.ItemNum );
			ParamAddINT64( param, "Price_" $ itemIndex, itemInfo.Price );
			
			ParamAdd( param, "AttrAttackType_" $ itemIndex, string(itemInfo.AttackAttributeType) );
			ParamAdd( param, "AttrAttackValue_" $ itemIndex, string(itemInfo.AttackAttributeValue) );
			ParamAdd( param, "AttrDefenseValueFire_" $ itemIndex, string(itemInfo.DefenseAttributeValueFire) );
			ParamAdd( param, "AttrDefenseValueWater_" $ itemIndex, string(itemInfo.DefenseAttributeValueWater) );
			ParamAdd( param, "AttrDefenseValueWind_" $ itemIndex, string(itemInfo.DefenseAttributeValueWind) );
			ParamAdd( param, "AttrDefenseValueEarth_" $ itemIndex, string(itemInfo.DefenseAttributeValueEarth) );
			ParamAdd( param, "AttrDefenseValueHoly_" $ itemIndex, string(itemInfo.DefenseAttributeValueHoly) );
			ParamAdd( param, "AttrDefenseValueUnholy_" $ itemIndex, string(itemInfo.DefenseAttributeValueUnholy) );
		}

		// Send packet
		SendPrivateShopList("buyList", param);
	}
	else if( m_type == PT_Sell )
	{
		// pack every item in BottomList
		ParamAdd( param, "merchantID", string(m_merchantID) );
		ParamAdd( param, "num", string(itemCount) );
		for( itemIndex=0 ; itemIndex < itemCount; ++itemIndex )
		{
			m_hPrivateShopWndBottomList.GetItem( itemIndex, itemInfo );
			if( bPriceCheck && !IsProperPrice( itemInfo, itemInfo.Price ) )
				break;
			ParamAddItemIDWithIndex( param, itemInfo.ID, itemIndex);
			ParamAdd( param, "Enchanted_" $ itemIndex, string(itemInfo.Enchanted) );
			ParamAdd( param, "Damaged_" $ itemIndex, string(itemInfo.Damaged) );
			ParamAddINT64( param, "Count_" $ itemIndex, itemInfo.ItemNum );
			ParamAddINT64( param, "Price_" $ itemIndex, itemInfo.Price );
		}

		if( bPriceCheck && ( itemIndex < itemCount ) )		// there's some problem about price...
		{
			DialogSetID( DIALOG_CONFIRM_PRICE_FINAL );
			DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(569) );
			return;
		}
		else					// send packet
		{
			SendPrivateShopList("sell", param);
		}
	}

	HideWindow("PrivateShopWnd");
	Clear();
}


function HandleSetMaxCount( string param )
{
	ParseInt( param, "privateShopSell", m_sellMaxCount );
	ParseInt( param, "privateShopBuy", m_buyMaxCount );
}


function bool IsProperPrice( out ItemInfo info, INT64 price )
{
	if( info.DefaultPrice > IntToInt64(0) && ( price <= info.DefaultPrice / IntToInt64(5) || price >= info.DefaultPrice * IntToInt64(5) )  )
		return false;

	return true;
}


function SwithBulkOnlyShop()
{
	//~ local WindowHandle Me;
	//~ local CheckBoxHandle CheckBulk;
	
	//~ debug("BulkSale");
	
	//~ Me = GetHandle("PrivateShopWnd");
	//~ CheckBulk = CheckBoxHandle(GetHandle("CheckBulk"));
	//~ Me.SetWindowTitle(GetSystemString(596) $ "(" $ GetSystemString(1198) $ ")");
	class'UIAPI_WINDOW'.static.SetWindowTitleByText("PrivateShopWnd", GetSystemString(596) $ "(" $ GetSystemString(1198) $ ")" );
	//~ CheckBulk.HideWindow();
	HideWindow( "PrivateShopWnd.CheckBulk" );
}


function ResetBulkOnlyShop()
{
	//~ local CheckBoxHandle CheckBulk;
	
	//~ debug("BulkSale Over");
	//~ CheckBulk = CheckBoxHandle(GetHandle("CheckBulk"));
	//~ CheckBulk.ShowWindow();
	HideWindow( "PrivateShopWnd.CheckBulk" );
}

defaultproperties
{
}
