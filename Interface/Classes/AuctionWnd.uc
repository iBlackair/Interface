class AuctionWnd extends UICommonAPI;

// Sets Timer Value
const TIMER_ID=777; 
const TIMER_DELAY=1000; 

const DIALOG_ASK_AUCTION_PRICE	= 321;	// ���� ���� ���� �Է� ���̾�α� ID
const DIALOG_CONFIRM_PRICE		= 432;	// ���� ������ Ȯ���ϴ� ���̾�α� ID

const ADENA_OVER_FLOW = "100000000000";		//���� �����÷ο�

// ���� �ڵ� �޾ƿ���.
var WindowHandle Me;
var TextBoxHandle txtRemainStr;
var TextBoxHandle txtTimeHour;
var TextBoxHandle txtTimeMin;
var TextBoxHandle txtTimeSec;
var TextBoxHandle txtHighBid;
var TextBoxHandle txtMyAdenaStr;
var TextBoxHandle txtMyAdena;
var TextBoxHandle txtItemInfoStr;
var ButtonHandle BtnBid1;
var ButtonHandle BtnBid2;
var ButtonHandle BtnBid3;
var ButtonHandle BtnBid4;
var ButtonHandle BtnBidInput;
var TextBoxHandle txtHighBidStr;
//var TextBoxHandle txtInfo;
var TextureHandle txtRemainTimeBg;
var TextureHandle ItemInfoBg;
var TextureHandle txtHighBidBg;
var TextureHandle txtMyAdenaBg;
var ButtonHandle BtnClose;
var ButtonHandle BtnNext;
var ItemWindowHandle AuctionItem;
var TextBoxHandle txtItemDesc;
var TextBoxHandle txtItemName;
var WindowHandle areaScroll;
var WindowHandle NextAuctionWnd;

// ������
var INT64 m_myLastBidPrice;		// ���������� �ڽ��� �����ߴ� ������ �����صд�. 
var INT64 m_myBidPrice;		// ������ �õ��ϴ� ����
var INT64 m_currentPrice;		// ���� �ְ� ������
var int m_auctionID;		// ���� ���� �ִ� �������� ���� ���̵�
var ItemInfo m_auctionItem;	// ��ſ� �ö��ִ� �������� ����

var int bShowUI;
var int iAuctionID;
var INT64 iCurrentPrice;
var int iRemainSecond;

function OnRegisterEvent()
{
	// �̺�Ʈ ��� 
	RegisterEvent( EV_ITEM_AUCTION_INFO );
	RegisterEvent( EV_DialogOK );
}

function OnLoad()
{
	Initialize();
	Load();
	
}

function Initialize()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	// ���� �ڵ� �ޱ�
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "AuctionWnd" );
		txtRemainStr = TextBoxHandle ( GetHandle( "AuctionWnd.txtRemainStr" ) );
		txtTimeHour = TextBoxHandle ( GetHandle( "AuctionWnd.txtTimeHour" ) );
		txtTimeMin = TextBoxHandle ( GetHandle( "AuctionWnd.txtTimeMin" ) );
		txtTimeSec = TextBoxHandle ( GetHandle( "AuctionWnd.txtTimeSec" ) );
		txtHighBid = TextBoxHandle ( GetHandle( "AuctionWnd.txtHighBid" ) );
		txtMyAdenaStr = TextBoxHandle ( GetHandle( "AuctionWnd.txtMyAdenaStr" ) );
		txtMyAdena = TextBoxHandle ( GetHandle( "AuctionWnd.txtMyAdena" ) );
		txtItemInfoStr = TextBoxHandle ( GetHandle( "AuctionWnd.txtItemInfoStr" ) );
		BtnBid1 = ButtonHandle ( GetHandle( "AuctionWnd.BtnBid1" ) );
		BtnBid2 = ButtonHandle ( GetHandle( "AuctionWnd.BtnBid2" ) );
		BtnBid3 = ButtonHandle ( GetHandle( "AuctionWnd.BtnBid3" ) );
		BtnBid4 = ButtonHandle ( GetHandle( "AuctionWnd.BtnBid4" ) );	
		BtnBidInput = ButtonHandle ( GetHandle( "AuctionWnd.BtnBidInput" ) );
		txtHighBidStr = TextBoxHandle ( GetHandle( "AuctionWnd.txtHighBidStr" ) );
		//txtInfo = TextBoxHandle ( GetHandle( "AuctionWnd.txtInfo" ) );
		txtRemainTimeBg = TextureHandle ( GetHandle( "AuctionWnd.txtRemainTimeBg" ) );
		ItemInfoBg = TextureHandle ( GetHandle( "AuctionWnd.ItemInfoBg" ) );
		txtHighBidBg = TextureHandle ( GetHandle( "AuctionWnd.txtHighBidBg" ) );
		txtMyAdenaBg = TextureHandle ( GetHandle( "AuctionWnd.txtMyAdenaBg" ) );
		BtnClose = ButtonHandle ( GetHandle( "AuctionWnd.BtnClose" ) );
		AuctionItem = ItemWindowHandle ( GetHandle( "AuctionWnd.AuctionItem" ) );
		txtItemDesc = TextBoxHandle ( GetHandle( "AuctionWnd.scrollDesc.txtItemDesc" ) );
		txtItemName = TextBoxHandle ( GetHandle( "AuctionWnd.txtItemName" ) );
		areaScroll = GetHandle( "AuctionWnd.scrollDesc" );
		NextAuctionWnd = GetHandle( "NextAuctionDrawerWnd" );
	}
	else
	{
		Me = GetWindowHandle( "AuctionWnd" );
		txtRemainStr = GetTextBoxHandle( "AuctionWnd.txtRemainStr" );
		txtTimeHour = GetTextBoxHandle( "AuctionWnd.txtTimeHour" );
		txtTimeMin = GetTextBoxHandle( "AuctionWnd.txtTimeMin" );
		txtTimeSec = GetTextBoxHandle( "AuctionWnd.txtTimeSec" );
		txtHighBid = GetTextBoxHandle( "AuctionWnd.txtHighBid" );
		txtMyAdenaStr = GetTextBoxHandle( "AuctionWnd.txtMyAdenaStr" );
		txtMyAdena = GetTextBoxHandle( "AuctionWnd.txtMyAdena" );
		txtItemInfoStr = GetTextBoxHandle( "AuctionWnd.txtItemInfoStr" );
		BtnBid1 = GetButtonHandle( "AuctionWnd.BtnBid1" );
		BtnBid2 = GetButtonHandle( "AuctionWnd.BtnBid2" );
		BtnBid3 = GetButtonHandle( "AuctionWnd.BtnBid3" );
		BtnBid4 = GetButtonHandle( "AuctionWnd.BtnBid4" );	
		BtnBidInput = GetButtonHandle( "AuctionWnd.BtnBidInput" );
		txtHighBidStr = GetTextBoxHandle( "AuctionWnd.txtHighBidStr" );
		//txtInfo = GetTextBoxHandle( "AuctionWnd.txtInfo" );
		txtRemainTimeBg = GetTextureHandle( "AuctionWnd.txtRemainTimeBg" );
		ItemInfoBg = GetTextureHandle( "AuctionWnd.ItemInfoBg" );
		txtHighBidBg = GetTextureHandle( "AuctionWnd.txtHighBidBg" );
		txtMyAdenaBg = GetTextureHandle( "AuctionWnd.txtMyAdenaBg" );
		BtnClose = GetButtonHandle( "AuctionWnd.BtnClose" );
		AuctionItem = GetItemWindowHandle ( "AuctionWnd.AuctionItem" );
		txtItemDesc = GetTextBoxHandle( "AuctionWnd.scrollDesc.txtItemDesc" );
		txtItemName = GetTextBoxHandle( "AuctionWnd.txtItemName" );
		areaScroll = GetWindowHandle( "AuctionWnd.scrollDesc" );
		BtnNext = GetButtonHandle( "AuctionWnd.BtnNextAuction" );
		NextAuctionWnd = GetWindowHandle( "NextAuctionDrawerWnd" );
	}
}

function Load()
{
}

// �̺�Ʈ�� �޾� �����͸� �Ľ��Ѵ�. 
function OnEvent(int Event_ID, string param)
{
	//�̺�Ʈ�� �޴� ����
	local ItemInfo 	info;
	
	switch(Event_ID)
	{
	//�⺻ ��� �̺�Ʈ
	case EV_ITEM_AUCTION_INFO:
	//case 0:
		ParseInt(param, "ShowUI", bShowUI);
		ParseInt(param, "AuctionID", iAuctionID);
		ParseINT64(param, "CurrentPrice", iCurrentPrice);
		ParseInt(param, "RemainSecond", iRemainSecond);		
		ParamToItemInfo( param, info );
	
		//���� ������ �������ش�. 
		m_currentPrice = iCurrentPrice;	
		m_auctionID = iAuctionID;
		m_auctionItem = info;
	
		if( bShowUI == 1)
		{
			// ������ ���� �߰� 
			InsertAuctionItem();
			
			// â�� ó�� ������ Ÿ�̸Ӹ� �Ҵ�.
			m_hOwnerWnd.SetTimer( TIMER_ID, TIMER_DELAY );	
			Me.ShowWindow();	
			Me.SetFocus();
		}
		
		//debug("bShowUI : " $ bShowUI $ "iAuctionID : " $ iAuctionID $ " iCurrentPrice : " $ iCurrentPrice $ "iRemainSecond : " $ iRemainSecond);
			
		// ������ �������ִ� �Լ� ȣ��
		UpdateAuctionWnd();
		break;
		
	// ���� ���� �Է� Ȯ�ν�

	case EV_DialogOK:	
		HandleDialogOK();
		break;
	}
}

function OnTimer(int TimerID)
{
	// Sending packet in Timer may be very dangerous and unhealthy.
	// Be aware of its influence over performance. If you are uncertain always contact client team member.
	if(TimerID == TIMER_ID)
	{
		class'AuctionAPI'.static.RequestInfoItemAuction( m_auctionID  );	// ���� ���� ��û
	}
}

function InsertAuctionItem()
{
	AuctionItem.Clear();
	AuctionItem.AddItem( m_auctionItem );
	AuctionItem.SetTooltipType( "Inventory");
	
	
	//class'UIDATA_ITEM'.static.GetItemInfo( info.Id , tempInfo);
	txtItemName.SetText( m_auctionItem.Name );
	//txtItemDesc.SetText( info.Name $ ": ����¯���� ������. õ�� �Ƶ����� �Ʊ��� ��Ÿ" );
	ComputeScrollHeight( m_auctionItem.Description );	//���̸� ������ش�. 
	txtItemDesc.SetText( m_auctionItem.Description );
}

function ComputeScrollHeight(string tempStr)
{
	local int nHeight;
	local int nWidth;
	
	local Rect rectWnd;
	
	rectWnd = txtItemDesc.GetRect();
	
	GetTextSizeDefault(tempStr, nWidth, nHeight);		// ����� �޾Ƽ�
	
	areaScroll.SetScrollHeight((nHeight + 1) * (nWidth / rectWnd.nWidth + 1));
	//debug("nHeight : " $ nHeight $ " nWidth : " $ nWidth $ "nWidth / rectWnd.nWidth : " $ (nWidth / rectWnd.nWidth));
	areaScroll.SetScrollPosition( 0 );
}

function OnShow()
{
	BtnNext.EnableWindow();
	BtnBid1.EnableWindow();
	BtnBid2.EnableWindow();
	BtnBid3.EnableWindow();
	BtnBid4.EnableWindow();
	BtnBidInput.EnableWindow();
}

function OnHide()
{
	// â�� ���� ��� Ÿ�̸Ӹ� ����� �Ѵ�. 
	class'UIAPI_WINDOW'.static.KillUITimer("AuctionWnd",TIMER_ID);  	// Ÿ�̸� ����
	class'UIAPI_ITEMWINDOW'.static.Clear("AuctionWnd.AuctionItem");	// ������ ������ Ŭ����
	NextAuctionWnd.HideWindow();
}

function OnClickButton( string Name )
{
	m_myBidPrice = IntToInt64(-1);
	switch( Name )
	{
	case "BtnBid1":	// 2��
		m_myBidPrice = m_currentPrice * 2;
		if (m_myBidPrice > StringToInt64(ADENA_OVER_FLOW) || m_myBidPrice < IntToInt64(0) )	//���� Ȥ�� 21���� ������ ���� ����
		{			
			BtnBid1.DisableWindow();
			BtnBid1.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
		}
		else
		{
			DialogSetID( DIALOG_CONFIRM_PRICE );
			DialogShow(DIALOG_Modalless, DIALOG_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(Int64ToString(m_myBidPrice) )) );
		}
		//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
		break;
	case "BtnBid2":	// 50%
		m_myBidPrice = m_currentPrice * 0.5f + m_currentPrice;
		if (m_myBidPrice > StringToInt64(ADENA_OVER_FLOW) || m_myBidPrice < IntToInt64(0) )	//���� Ȥ�� 21���� ������ ���� ����
		{
			BtnBid2.DisableWindow();
			BtnBid2.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
		}
		else
		{
			DialogSetID( DIALOG_CONFIRM_PRICE );
			DialogShow(DIALOG_Modalless, DIALOG_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(Int64ToString(m_myBidPrice) ) ));
		}
		//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
		break;
	case "BtnBid3":
		m_myBidPrice = m_currentPrice * 0.1f + m_currentPrice;;	
		if (m_myBidPrice > StringToInt64(ADENA_OVER_FLOW) || m_myBidPrice < IntToInt64(0) )	//���� Ȥ�� 21���� ������ ���� ����
		{
			BtnBid3.DisableWindow();
			BtnBid3.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
		}
		else
		{
			DialogSetID( DIALOG_CONFIRM_PRICE );
			DialogShow(DIALOG_Modalless, DIALOG_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(Int64ToString(m_myBidPrice) )) );
		}
		//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
		break;
	case "BtnBid4":
		m_myBidPrice = m_currentPrice  * 0.05f + m_currentPrice;;	
		if (m_myBidPrice > StringToInt64(ADENA_OVER_FLOW) || m_myBidPrice < IntToInt64(0) )	//���� Ȥ�� 21���� ������ ���� ����
		{
			BtnBid4.DisableWindow();
			BtnBid4.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2157)));
		}
		else
		{
			DialogSetID( DIALOG_CONFIRM_PRICE );
			DialogShow(DIALOG_Modalless, DIALOG_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(Int64ToString(m_myBidPrice) )) );
		}
		//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
		break;		
	case "BtnBidInput":
		OnBtnBidInputClick();
		break;
	case "BtnClose":
		if( IsShowWindow("AuctionWnd"))
			HideWindow("AuctionWnd");
		NextAuctionWnd.HideWindow();
		break;
	case "BtnNextAuction":
		NextAuctionWnd.ShowWindow();
		break;
	}
}

function UpdateAuctionWnd()
{
	local int temp1;
	local int m_timeHour;
	local int m_timeMin;
	local int m_timeSec;
	
	local string tempStr;
	//local int myAdena;

	local INT64 tempPrice;
	
	// ���� �ְ��� �������ش�.  
	//txtHighBid.SetText( MakeCostString( string(m_currentPrice) ) $ " adena");
	txtHighBid.SetText( MakeCostString( Int64ToString(m_currentPrice) ) $ " " $ GetSystemString(469));
	// �� ������ ����.
	//txtMyAdena.SetText(MakeCostString( string(GetAdena()) ) $ " " $ GetSystemString(469));
	txtMyAdena.SetText(MakeCostString( Int64ToString(GetAdena()) ) );
	
	// �ð� ����. 
	m_timeSec = iRemainSecond % 60;	// ��
	temp1 = iRemainSecond / 60;
	m_timeHour = temp1 / 60;			// ��
	m_timeMin = temp1 % 60;			// ��?
	
	//debug(" m_timeHour : " $ m_timeHour $ "m_timeMin : "  $ m_timeMin$ "m_timeSec : "  $ m_timeSec);
	
	// �ø� �׷��ش�.
	if(m_timeHour > 0)
	{
		if (m_timeHour < 10 ) txtTimeHour.SetText( "0" $ string( m_timeHour ));
		else txtTimeHour.SetText( string( m_timeHour ));
	}
	else
	{
		txtTimeHour.SetText( "00");
	}
	
	// ���� �׷��ش�.
	if( m_timeMin > 0)
	{
		if (m_timeMin < 10 ) txtTimeMin.SetText( "0" $ string( m_timeMin ));
		else txtTimeMin.SetText( string( m_timeMin ));
	}
	else
	{
		txtTimeMin.SetText( "00");
	}
		
	// �ʸ� �׷��ش�. 
	if(m_timeSec > 0)
	{
		if (m_timeSec < 10 ) txtTimeSec.SetText( "0" $ string( m_timeSec ));
		else txtTimeSec.SetText( string( m_timeSec ));
	}
	else
	{
		txtTimeSec.SetText( "00");
	}
	//txtRemainTime.SetText( string( m_timeHour ) $ " : " $ string( m_timeMin ) $ " : " $ string( m_timeSec ) );
	
	//��ư�� ������ ������ �����ش�. 
	tempPrice = m_currentPrice * 2;
	if(tempPrice > StringToInt64(ADENA_OVER_FLOW) || tempPrice < IntToInt64(0) )
	{
		BtnBid1.DisableWindow();
		BtnBid1.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid1.IsEnableWindow()) BtnBid1.EnableWindow();
		tempStr = MakeFullSystemMsg( GetSystemMessage(2157), MakeCostString(Int64ToString(m_currentPrice * 2) ) );
		BtnBid1.SetTooltipCustomType( MakeTooltipSimpleText(tempStr));
	}
	
	//temp1 = m_currentPrice * 15 / 10;
	tempPrice = m_currentPrice * 0.5 + m_currentPrice;
	if(tempPrice > StringToInt64(ADENA_OVER_FLOW) || tempPrice < IntToInt64(0) )
	{
		BtnBid2.DisableWindow();
		BtnBid2.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid2.IsEnableWindow()) BtnBid2.EnableWindow();
		tempStr = MakeFullSystemMsg( GetSystemMessage(2157), MakeCostString(Int64ToString(m_currentPrice * 0.5 + m_currentPrice) ));
		BtnBid2.SetTooltipCustomType( MakeTooltipSimpleText(tempStr));
	}
	
	//temp1 = m_currentPrice * 11 /10;
	tempPrice = m_currentPrice * 0.1 + m_currentPrice;
	if(tempPrice > StringToInt64(ADENA_OVER_FLOW) || tempPrice < IntToInt64(0) )
	{
		BtnBid3.DisableWindow();
		BtnBid3.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid3.IsEnableWindow()) BtnBid3.EnableWindow();
		tempStr = MakeFullSystemMsg( GetSystemMessage(2157), MakeCostString(Int64ToString(m_currentPrice * 0.1 + m_currentPrice) ) );
		BtnBid3.SetTooltipCustomType( MakeTooltipSimpleText(tempStr));
	}
	
	//temp1 = m_currentPrice * 105 / 100;		//ũ��
	tempPrice = m_currentPrice  * 0.05 + m_currentPrice;
	//debug("temp 1 : " $ m_currentPrice  * 0.05 + m_currentPrice);
	if(tempPrice > StringToInt64(ADENA_OVER_FLOW) || tempPrice < IntToInt64(0) )
	{
		BtnBid4.DisableWindow();
		BtnBid4.SetTooltipCustomType( MakeTooltipSimpleText( GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid4.IsEnableWindow()) BtnBid4.EnableWindow();
		tempStr = MakeFullSystemMsg( GetSystemMessage(2157), MakeCostString(Int64ToString(m_currentPrice  * 0.05 + m_currentPrice) ) );
		BtnBid4.SetTooltipCustomType( MakeTooltipSimpleText(tempStr));
	}
	
	if(m_timeHour == 0 && m_timeMin == 0 && m_timeSec == 0)	//��Ű� ������ Ÿ�̸Ӹ� ���δ�.
	{
		m_hOwnerWnd.KillTimer( TIMER_ID );
	}
	
	if(iRemainSecond == 0)
	{
		// iRemainSecond�� 0�̸� �̹� ��Ŵ� ����� ����. ���� ��� ���� â�� �����ش�.
		BtnBid1.DisableWindow();
		BtnBid2.DisableWindow();
		BtnBid3.DisableWindow();
		BtnBid4.DisableWindow();
		BtnBidInput.DisableWindow();
		
		NextAuctionWnd.ShowWindow();
		BtnClose.EnableWindow();
	}
}

function OnBtnBidInputClick()
{
	DialogSetID( DIALOG_ASK_AUCTION_PRICE );
	//DialogSetReservedItemID( info.ID );				// ClassID
	DialogSetEditType("number");
	DialogSetParamInt64( IntToInt64(-1) );
	DialogSetDefaultOK();	
	DialogShow(DIALOG_Modalless, DIALOG_NumberPad, GetSystemMessage(2138) );
}

function HandleDialogOK()
{
	local int id;				//���̾�α� ���̵� �޾ƿ´�. 
	if( DialogIsMine() )
	{
		id = DialogGetID();
		if( id == DIALOG_ASK_AUCTION_PRICE)
		{
			// �����÷ο� üũ �ؾ���.
			m_myBidPrice = StringToInt64( DialogGetString() );
			DialogSetID( DIALOG_CONFIRM_PRICE );
			DialogShow(DIALOG_Modalless, DIALOG_Warning, MakeFullSystemMsg( GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(Int64ToString(m_myBidPrice) ) ));
			
			//class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
		}
		else if( id == DIALOG_CONFIRM_PRICE)
		{
			class'AuctionAPI'.static.RequestBidItemAuction( m_auctionID ,  m_myBidPrice);	// ������ �õ��մϴ�.
		}
	}
	
}
defaultproperties
{
}
