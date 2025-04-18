class AuctionNextWnd extends UICommonAPI;

// ���� �ڵ� �޾ƿ���.
var WindowHandle Me;
var ButtonHandle BtnAuctionWndShowNext;
var ButtonHandle BtnClose;
var ItemWindowHandle AuctionItem;
var TextBoxHandle txtItemDesc;
var TextBoxHandle txtItemName;
var WindowHandle areaScroll;
var TextBoxHandle NextAuctionTime;


function OnRegisterEvent()
{
	// �̺�Ʈ ��� 
	RegisterEvent( EV_ITEM_AUCTION_NEXT_INFO );
}

function OnLoad()
{
	Initialize();
}

function OnShow()
{
	BtnAuctionWndShowNext.DisableWindow();
}

function Initialize()
{
	Me = GetWindowHandle( "NextAuctionDrawerWnd" );
	BtnAuctionWndShowNext = GetButtonHandle( "AuctionWnd.BtnNextAuction" );
	BtnClose = GetButtonHandle( "NextAuctionDrawerWnd.BtnClose" );
	AuctionItem = GetItemWindowHandle ( "NextAuctionDrawerWnd.NextAuctionItem" );
	txtItemDesc = GetTextBoxHandle( "NextAuctionDrawerWnd.scrollDesc.txtItemDesc" );
	txtItemName = GetTextBoxHandle( "NextAuctionDrawerWnd.txtItemName" );
	areaScroll = GetWindowHandle( "NextAuctionDrawerWnd.scrollDesc" );
	NextAuctionTime = GetTextBoxHandle( "NextAuctionDrawerWnd.NextAuctionTime" );
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
	case EV_ITEM_AUCTION_NEXT_INFO:
		HandleAuctionNextInfo(param);
		break;
	}
}

function HandleAuctionNextInfo(string param)
{
	local int startYear;
	local int startMon; 
	local int startDay; 
	local int startMin; 
	local int startHour;
	local int64 startPrice;
	local ItemInfo info;
	local ItemInfo curInfo;		//CT26P4

	//debug("HandleAuctionNextInfo param = " $ param);
	
	ParseInt(param, "startTimeYear", startYear);
	ParseInt(param, "startTimeMonth", startMon);
	ParseInt(param, "startTimeDay", startDay);
	ParseInt(param, "startTimeHour", startHour);
	ParseInt(param, "startTimeMinute", startMin);
	ParseInt64(param, "startPrice", startPrice);
	ParamToItemInfo( param, info );

	//CT26P4
	//�Ϲ� ��Ŷ�� Next ������ ���� �ͼ� ���ʸ��� �� �Լ��� �ҷ��� ���� ������ ����
	//������ ������ �ٲ� ���� �Ʒ� �۾� �����ϵ��� ���� by enyheid
	AuctionItem.GetItem(0, curInfo);

	if (info.Id.ServerID != curInfo.Id.ServerID)
	{
		//debug("====== " $ info.Id.ServerID $ "," $ curInfo.Id.ServerID );
		AuctionItem.Clear();
		AuctionItem.AddItem( info );
		AuctionItem.SetTooltipType( "Inventory");
		
		txtItemName.SetText( info.Name );
		ComputeScrollHeight( info.Description );	//���̸� ������ش�. 
		txtItemDesc.SetText( info.Description );
	}

	if (startMin >= 10)
	{
		NextAuctionTime.SetText(startYear$"/"$startMon$"/"$startDay$"  "$startHour$":"$startMin);
	}
	
	else if ( startMin < 10 || startMin >= 0)
	{
		NextAuctionTime.SetText(startYear$"/"$startMon$"/"$startDay$"  "$startHour$":"$"0"$startMin);
	}
}

function ComputeScrollHeight(string tempStr)
{
	local int nHeight;
	local int nWidth;
	
	local Rect rectWnd;
	
	rectWnd = txtItemDesc.GetRect();
	
	GetTextSizeDefault(tempStr, nWidth, nHeight);		// ����� �޾Ƽ�
	
	areaScroll.SetScrollHeight((nHeight + 1) * (nWidth / rectWnd.nWidth + 1));
	areaScroll.SetScrollPosition( 0 );
}

function OnClickButton( string Name )
{
	switch(Name)
	{
	case "BtnClose":
		Me.HideWindow();
		BtnAuctionWndShowNext.EnableWindow();
		break;
	}
}
defaultproperties
{
}
