class PostWriteWnd extends UICommonAPI;


var WindowHandle Me;
//var UIScript myScript;
var WindowHandle PostBoxWnd;
var WindowHandle PostDetailWnd_General;
var WindowHandle PostDetailWnd_SafetyTrade;

var TextureHandle PostTitleDivider;
var TextureHandle PostContentsBg;
var TextureHandle groupbox1;
var TextureHandle AccompanyItemSlotBg01;
var TextureHandle AccompanyItemSlotBg02;
var TextureHandle AccompanyItemSlotBg03;
var TextureHandle AdenaIcon;
var TextureHandle WeightBg;
var TextureHandle WeightDivider;
var TextureHandle InventoryItemSlot01;
var TextureHandle InventoryItemSlot02;
var TextureHandle InventoryDivider;
var TextureHandle ChargeAdenaIcon;
var TextureHandle Chargeadenabg;
var TextureHandle groupbox2;
var TextureHandle SafetyTradeAdenaIcon;
var TextureHandle groupbox3;
var TextureHandle SafetyTradeAdenaTextBoxBg;
var TextureHandle SafetyReceiveAdenaIcon;

var TextboxHandle Title_ReceiverID;
var TextboxHandle Title_PostType;
var TextboxHandle Title_PostTitle;
var TextboxHandle PostTitleByte;
var TextboxHandle Title_PostContents;
var TextboxHandle PostContentsByte;
var TextboxHandle Title_AccompanyItem;
var TextboxHandle Title_Weight;
var TextboxHandle WeightText;
var TextboxHandle Title_Inventory;
var TextboxHandle InventoryItemNumber;
var TextboxHandle InventoryPageNumber;
var TextboxHandle Title_Charge;
var TextboxHandle ChargeAdenaText;
var TextboxHandle Title_SafetyTradeAdena;


var EditBoxHandle ReceiverID;
var EditBoxHandle PostTitle;
//var TextboxHandle AdenaTextBox;
var TextboxHandle SafetyTradeAdenaTextBox;

var ButtonHandle SafetyReceiveAdena;


//XML�� MultiEdit�� ������ �ڵ鷯������ ã�ƺ��� ����...
var MultiEditBoxHandle Contents;

var ComboBoxHandle PostTypeComboBox;


var ButtonHandle SendBtn;


var ItemWindowHandle AccompanyItem;
var ItemWindowHandle InventoryItem;
var ButtonHandle PrevButton;
var ButtonHandle NextButton;


var InventoryWnd script;


//���� ����(2010.03.08)
var WindowHandle    PostReceiverListWnd;
var bool            bOpenPostReceiverList;

var string          strSendID;

var array<RequestItem> itemIDList;
//var array<INT64> itemAmountList;

var ItemInfo adenaInfo;		// �Ƶ��� ���� ������ �ֱ�..
var INT64 SafetyTradeAdena;	// �����ŷ��� ���� �ݾ�
var INT64 FeeAdena;			// ��۷�
var	int		TotalWeight;	// �ѹ���
var int	 curTradeType;
var int  ZoneType;
//var int IsPeaceZone;

var Color disableColor;
var Color enableColor;

const FEEMUITIPLIER = 2;	//���Դ� ��۷� ����
const FEE_PER_SLOT = 1000;

const TRADE_NORMAL	= 0;	// �Ϲ� �ŷ�
const TRADE_SAFE = 1;		// ���� �ŷ�

const MAX_APPEND_ITEM_NUM = 8; //�ִ� ÷�μ�

const DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN = 1111;		//ACCOMPANY ���� INVEN���� �ű涧 ����Ŀ���Ѱ� ���� �����
const DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY = 2222;		//INVEN ���� ACCOMPANY���� �ű涧 ����Ŀ���Ѱ� ���� �����
const DIALOG_RECEIVE_ADENA = 3333;							//���� �ݾ� ����
const DIALOG_NOTIFY_SEND_POST = 4444;						//������ ������ ������ ����� ���̾�α�
const DIALOG_ONLY_NOTICE = 5555;							//�ƹ����۵� ���ϴ� �˷��ִ� ����
//���� �ݾ� ����
const MAX_CHAR_LENGTH = 24;
const MAX_TITLE_LENGTH = 60;
const MAX_CONTENTS_LENGTH = 1000;

const BASE_FEE_ADENA = 100;									//���� �⺻���
const ADENA_OVER_FLOW = "100000000000";	

const MAX_PAGE_ITEM_NUM = 24;


function OnRegisterEvent()
{
	registerEvent( EV_ReceiveFriendList );
	registerEvent( EV_ConfirmAddingPostFriend );
	registerEvent( EV_ReceivePostFriendList );
	registerEvent( EV_ReceivePledgeMemberList );
	registerEvent( EV_PostWriteOpen );
	registerEvent( EV_PostWriteAddItem );
	registerEvent( EV_PostWriteEnd );
	registerEvent( EV_DialogOK );
	registerEvent( EV_ReplyWritePost );
	registerEvent( EV_SetRadarZoneCode );
	registerEvent( EV_GamingStateExit );
}

function OnLoad()
{
	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();

	Me.HideWindow();

	enableColor.R = 220;
	enableColor.G = 220;
	enableColor.B = 220;
	disableColor.R = 130;
	disableColor.G = 130;
	disableColor.B = 130;
	ClearAll();

	bOpenPostReceiverList = false;
//	ResetUI();
	
}

function OnKeyUp(WindowHandle a_WindowHandle, EInputKey Key)
{

	if(key == EInputKey.IK_Tab)
	{
		if (ReceiverID.IsFocused())
		{
			PostTitle.Setfocus();
		}
		else if (PostTitle.IsFocused())
		{
			Contents.Setfocus();
		}
	}	
}
function OnShow()
{
	if( PostBoxWnd.IsShowwindow())
		PostBoxWnd.HideWindow();
	if (PostDetailWnd_General.IsShowWindow())
		PostDetailWnd_General.HideWindow();
	if (PostDetailWnd_SafetyTrade.IsShowWindow())
		PostDetailWnd_SafetyTrade.HideWindow();
	if ( ZoneType != 12 )
		SendBtn.EnableWindow();

	ReceiverID.Setfocus();

}


function Initialize()
{
	Me = GetHandle("PostWriteWnd");
	PostBoxWnd = GetHandle("PostBoxWnd");
	PostDetailWnd_General = GetHandle("PostDetailWnd_General");
	PostDetailWnd_SafetyTrade = GetHandle("PostDetailWnd_SafetyTrade");

	Title_ReceiverID=TextboxHandle(GetHandle("PostWriteWnd.Title_ReceiverID"));
	Title_PostType=TextboxHandle(GetHandle("PostWriteWnd.Title_PostType"));
	Title_PostTitle=TextboxHandle(GetHandle("PostWriteWnd.Title_PostTitle"));
	PostTitleByte=TextboxHandle(GetHandle("PostWriteWnd.PostTitleByte"));
	Title_PostContents=TextboxHandle(GetHandle("PostWriteWnd.Title_PostContents"));
	PostContentsByte=TextboxHandle(GetHandle("PostWriteWnd.PostContentsByte"));
	Title_AccompanyItem=TextboxHandle(GetHandle("PostWriteWnd.Title_AccompanyItem"));
	Title_Weight=TextboxHandle(GetHandle("PostWriteWnd.Title_Weight"));
	WeightText=TextboxHandle(GetHandle("PostWriteWnd.WeightText"));
	Title_Inventory=TextboxHandle(GetHandle("PostWriteWnd.Title_Inventory"));
	InventoryItemNumber=TextboxHandle(GetHandle("PostWriteWnd.InventoryItemNumber"));
	InventoryPageNumber=TextboxHandle(GetHandle("PostWriteWnd.InventoryPageNumber"));
	Title_Charge=TextboxHandle(GetHandle("PostWriteWnd.Title_Charge"));
	ChargeAdenaText=TextboxHandle(GetHandle("PostWriteWnd.ChargeAdenaText"));
	Title_SafetyTradeAdena=TextboxHandle(GetHandle("PostWriteWnd.Title_SafetyTradeAdena"));
	
	
	
	PostTitleDivider=TextureHandle(GetHandle("PostWriteWnd.PostTitleDivider"));
	PostContentsBg=TextureHandle(GetHandle("PostWriteWnd.PostContentsBg"));
	groupbox1=TextureHandle(GetHandle("PostWriteWnd.groupbox1"));
	AccompanyItemSlotBg01=TextureHandle(GetHandle("PostWriteWnd.AccompanyItemSlotBg01"));
	AccompanyItemSlotBg02=TextureHandle(GetHandle("PostWriteWnd.AccompanyItemSlotBg02"));
	AccompanyItemSlotBg03=TextureHandle(GetHandle("PostWriteWnd.AccompanyItemSlotBg03"));
	AdenaIcon=TextureHandle(GetHandle("PostWriteWnd.AdenaIcon"));
	WeightBg=TextureHandle(GetHandle("PostWriteWnd.WeightBg"));
	WeightDivider=TextureHandle(GetHandle("PostWriteWnd.WeightDivider"));
	InventoryItemSlot01=TextureHandle(GetHandle("PostWriteWnd.InventoryItemSlot01"));
	InventoryItemSlot02=TextureHandle(GetHandle("PostWriteWnd.InventoryItemSlot02"));
	InventoryDivider=TextureHandle(GetHandle("PostWriteWnd.InventoryDivider"));
	ChargeAdenaIcon=TextureHandle(GetHandle("PostWriteWnd.ChargeAdenaIcon"));
	Chargeadenabg=TextureHandle(GetHandle("PostWriteWnd.Chargeadenabg"));
	groupbox2=TextureHandle(GetHandle("PostWriteWnd.groupbox2"));
	SafetyTradeAdenaIcon=TextureHandle(GetHandle("PostWriteWnd.SafetyTradeAdenaIcon"));
	groupbox3=TextureHandle(GetHandle("PostWriteWnd.groupbox3"));

	SafetyTradeAdenaTextBoxBg=TextureHandle(GetHandle("PostWriteWnd.SafetyTradeAdenaTextBoxBg"));
	SafetyReceiveAdenaIcon=TextureHandle(GetHandle("PostWriteWnd.SafetyReceiveAdenaIcon"));
	
	ReceiverID=EditBoxHandle(GetHandle("PostWriteWnd.ReceiverID"));
	PostTitle=EditBoxHandle(GetHandle("PostWriteWnd.PostTitle"));
	//	AdenaTextBox=TextBoxHandle(GetHandle("PostWriteWnd.AdenaTextBox"));
	SafetyTradeAdenaTextBox=TextBoxHandle(GetHandle("PostWriteWnd.SafetyTradeAdenaTextBox"));
	Contents = MultiEditBoxHandle(GetHandle("PostWriteWnd.PostContents"));	

	PostTypeComboBox=ComboBoxHandle(GetHandle("PostWriteWnd.PostTypeComboBox"));

	AccompanyItem=ItemWindowHandle(GetHandle("PostWriteWnd.AccompanyItem"));
	InventoryItem=ItemWindowHandle(GetHandle("PostWriteWnd.InventoryItem"));
	PrevButton=ButtonHandle (GetHandle("PostWriteWnd.PrevButton"));
	NextButton=ButtonHandle (GetHandle("PostWriteWnd.NextButton"));
	

	SendBtn=ButtonHandle (GetHandle("PostWriteWnd.SendBtn"));
	SafetyReceiveAdena =ButtonHandle (GetHandle("PostWriteWnd.SafetyReceiveAdena"));
	
	script = InventoryWnd( GetScript("InventoryWnd") );

	//���� ����(2010.03.08)
	PostReceiverListWnd = GetWindowHandle( "PostReceiverListWnd" );
}

function InitializeCOD()
{

	Me = GetWindowHandle("PostWriteWnd");
	PostBoxWnd = GetWindowHandle("PostBoxWnd");
	PostDetailWnd_General = GetWindowHandle("PostDetailWnd_General");
	PostDetailWnd_SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");

	Title_ReceiverID=GetTextBoxHandle("PostWriteWnd.Title_ReceiverID");
	Title_PostType=GetTextBoxHandle("PostWriteWnd.Title_PostType");
	Title_PostTitle=GetTextBoxHandle("PostWriteWnd.Title_PostTitle");
	PostTitleByte=GetTextBoxHandle("PostWriteWnd.PostTitleByte");
	Title_PostContents=GetTextBoxHandle("PostWriteWnd.Title_PostContents");
	PostContentsByte=GetTextBoxHandle("PostWriteWnd.PostContentsByte");
	Title_AccompanyItem=GetTextBoxHandle("PostWriteWnd.Title_AccompanyItem");
	Title_Weight=GetTextBoxHandle("PostWriteWnd.Title_Weight");
	WeightText=GetTextBoxHandle("PostWriteWnd.WeightText");
	Title_Inventory=GetTextBoxHandle("PostWriteWnd.Title_Inventory");
	InventoryItemNumber=GetTextBoxHandle("PostWriteWnd.InventoryItemNumber");
	InventoryPageNumber=GetTextBoxHandle("PostWriteWnd.InventoryPageNumber");
	Title_Charge=GetTextBoxHandle("PostWriteWnd.Title_Charge");
	ChargeAdenaText=GetTextBoxHandle("PostWriteWnd.ChargeAdenaText");
	Title_SafetyTradeAdena=GetTextBoxHandle("PostWriteWnd.Title_SafetyTradeAdena");
	
	
	
	PostTitleDivider=GetTextureHandle("PostWriteWnd.PostTitleDivider");
	PostContentsBg=GetTextureHandle("PostWriteWnd.PostContentsBg");
	groupbox1=GetTextureHandle("PostWriteWnd.groupbox1");
	AccompanyItemSlotBg01=GetTextureHandle("PostWriteWnd.AccompanyItemSlotBg01");
	AccompanyItemSlotBg02=GetTextureHandle("PostWriteWnd.AccompanyItemSlotBg02");
	AccompanyItemSlotBg03=GetTextureHandle("PostWriteWnd.AccompanyItemSlotBg03");
	AdenaIcon=GetTextureHandle("PostWriteWnd.AdenaIcon");
	WeightBg=GetTextureHandle("PostWriteWnd.WeightBg");
	WeightDivider=GetTextureHandle("PostWriteWnd.WeightDivider");
	InventoryItemSlot01=GetTextureHandle("PostWriteWnd.InventoryItemSlot01");
	InventoryItemSlot02=GetTextureHandle("PostWriteWnd.InventoryItemSlot02");
	InventoryDivider=GetTextureHandle("PostWriteWnd.InventoryDivider");
	ChargeAdenaIcon=GetTextureHandle("PostWriteWnd.ChargeAdenaIcon");
	Chargeadenabg=GetTextureHandle("PostWriteWnd.Chargeadenabg");
	groupbox2=GetTextureHandle("PostWriteWnd.groupbox2");
	SafetyTradeAdenaIcon=GetTextureHandle("PostWriteWnd.SafetyTradeAdenaIcon");
	groupbox3=GetTextureHandle("PostWriteWnd.groupbox3");

	SafetyTradeAdenaTextBoxBg=GetTextureHandle("PostWriteWnd.SafetyTradeAdenaTextBoxBg");
	SafetyReceiveAdenaIcon=GetTextureHandle("PostWriteWnd.SafetyReceiveAdenaIcon");
	
	ReceiverID=GetEditBoxHandle("PostWriteWnd.ReceiverID");
	PostTitle=GetEditBoxHandle("PostWriteWnd.PostTitle");
	//AdenaTextBox=GetTextBoxHandle("PostWriteWnd.AdenaTextBox");
	SafetyTradeAdenaTextBox=GetTextBoxHandle("PostWriteWnd.SafetyTradeAdenaTextBox");
	Contents = GetMultiEditBoxHandle("PostWriteWnd.PostContents");	
	
	PostTypeComboBox=GetComboBoxHandle("PostWriteWnd.PostTypeComboBox");

	AccompanyItem=GetItemWindowHandle("PostWriteWnd.AccompanyItem");
	InventoryItem=GetItemWindowHandle("PostWriteWnd.InventoryItem");
	PrevButton=GetButtonHandle("PostWriteWnd.PrevButton");
	NextButton=GetButtonHandle("PostWriteWnd.NextButton");

	SendBtn=GetButtonHandle("PostWriteWnd.SendBtn");
	SafetyReceiveAdena = GetButtonHandle("PostWriteWnd.SafetyReceiveAdena");

	script = InventoryWnd( GetScript("InventoryWnd") );
//	myScript = GetScript("PostWriteWnd");

	//���� ����(2010.03.08)
	PostReceiverListWnd = GetWindowHandle( "PostReceiverListWnd" );
}

function PostListUpdate()
{
	class'PostWndAPI'.static.RequestFriendList();
	class'PostWndAPI'.static.RequestPledgeMemberList();
	class'PostWndAPI'.static.RequestPostFriendList();
}

function OnClickButton( String a_ButtonID )
{
	switch(a_ButtonID)
	{
	case "SendBtn":
		HandleSendBtn();
		break;
	case "SafetyReceiveAdena":
		HandleSafetyReceiveAdena();
		break;
	case "PrevButton":
		InventoryItem.PushSideTypePrevBtn();
		SetInventoryPageNumber();
		break;
	case "NextButton":
		InventoryItem.PushSideTypeNextBtn();
		SetInventoryPageNumber();
		break;

	//���� ����(2010.03.08)
	case "ReceiverListBtn":		
		OnReceiverListButton();
		break;
	}
}

function SetBoolPostReceiverList( bool b )
{
	//debug("SetBoolPostReceiverList" $ string(b) );
	bOpenPostReceiverList = b;
}

function OnReceiverListButton()
{	
	local PostReceiverListWnd Script;
	
	Script = PostReceiverListWnd( GetScript( "PostReceiverListWnd" ) );	

	bOpenPostReceiverList = !bOpenPostReceiverList;	
	
	if (bOpenPostReceiverList)
	{	
		PostReceiverListWnd.ShowWindow();
		PostListUpdate();
	}
	else 
	{	
		Script.selectedInit();
		PostReceiverListWnd.HideWindow();		
	}		
}

function OnEvent( int Event_ID, String Param )
{
//	local int zonetype;
	switch(Event_ID)
	{
	case EV_PostWriteOpen:
		HandlePostWriteOpen();
		break;

	case EV_PostWriteAddItem:
		HandleSentEnableAddItem(Param);
		break;
	
	case EV_PostWriteEnd:
		HandlePostWriteEnd();
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;

	case EV_ReplyWritePost:
		HandleReplyWritePost(Param);
		break;
	case EV_SetRadarZoneCode:
//		ParseInt( Param, "ZoneCode", zonetype );		
		ParseInt( Param, "ZoneCode", ZoneType );
		if (ZoneType == 12 )
			SendBtn.EnableWindow();
		else if ( AccompanyItem.GetItemNum() > 0 )
			SendBtn.DisableWindow();
			
//		if (zonetype == 12)
//			SendBtn.EnableWindow();
//		else
//		{
//			if (Me.IsShowWindow())
//				AddSystemMessage(3066);

//			SendBtn.DisableWindow();
//		}

		break;
	case EV_GamingStateExit:
		ReceiverID.ClearHistory();
		break;
	//	case EV_CleftListStart :
//			HandleCleftListStart();
	//		break;
	case EV_ReceiveFriendList:
	case EV_ConfirmAddingPostFriend:
	case EV_ReceivePostFriendList:
	case EV_ReceivePledgeMemberList:
		break;
	}
}

//////////////////////////////////////////////////////////////////////////////////

function UseInvenToAccompany(ItemInfo infItem)
{
	local int AccompanyItemID, invenItemID;
	local ItemInfo AccompanyInfo;
	invenItemID = InventoryItem.FindItem( infItem.id );	// ServerID
	AccompanyItemID = AccompanyItem.FindItem(infItem.id);

	if ( AccompanyItem.GetItemNum() < MAX_APPEND_ITEM_NUM)
	{		
		
		if (IsStackableItem( infItem.ConsumeType) && infItem.ItemNum != IntToInt64(1))
		{
			if ( infItem.AllItemCount > IntToInt64(0) )
			{
				
				

				// ���� ACCOMPANY�� �������� �ִٸ� ������� �Ѵ�.
				if (AccompanyItemID >= 0)
				{
					AccompanyItem.GetItem(AccompanyItemID, AccompanyInfo);
					// Accompany�� ��������� ������ Inven���� �Ѿ���� ������ �����ش�.
					AccompanyInfo.ItemNum += infItem.AllItemCount;
					AccompanyItem.SetItem(AccompanyItemID, AccompanyInfo);
				}
				else // ���� Accompany�� �������� ���ٸ� �������� �ʾƵ� �ȴ�.
				{
					// Accompany�� �����Ƿ� �� �����ش�.
					AccompanyItem.AddItem(infItem);
				}				
			
				InventoryItem.DeleteItem(InvenItemID);

				// ���Կ� ��۷Ḧ ����Ѵ�.
				TotalWeight += infItem.Weight * Int64ToInt(infItem.ItemNum);
				SetWeight();				
			}
			else
			{
				DialogSetID(DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY);
				DialogSetReservedItemInfo(infItem);
				DialogSetParamInt64(infItem.ItemNum);
				DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), infItem.Name, "" ) );
			}
		}
		else
		{
			TotalWeight += infItem.Weight;

			InventoryItem.DeleteItem(invenItemID);


			if (IsStackableItem(infItem.ConsumeType))
			{
				if (AccompanyItemID >= 0)
				{
					AccompanyItem.GetItem(AccompanyItemID, AccompanyInfo);
					AccompanyInfo.ItemNum += IntToInt64(1);
					AccompanyItem.SetItem(AccompanyItemID, AccompanyInfo);
				}
				else
				{
					AccompanyItem.AddItem(infItem);
				}
			}
			else
			{
				AccompanyItem.AddItem(infItem);
			}
			FeeAdena = CalculateFeeAdena();			
			SetWeight();
			SetFeeAdena();
		}
	}
	else if (AccompanyItem.GetItemNum() == MAX_APPEND_ITEM_NUM && IsStackableItem( infItem.ConsumeType) && AccompanyItemID >= 0 )	//8�� �ϰ��� ����Ŀ���ѰŸ� �̵��� ����
	{		
		if ((infItem.ItemNum != IntToInt64(1) && infItem.AllItemCount > IntToInt64(0)) || infItem.ItemNum == IntToInt64(1) )
		{
			AccompanyItem.GetItem(AccompanyItemID, AccompanyInfo);
			// Accompany�� ��������� ������ Inven���� �Ѿ���� ������ �����ش�.
			AccompanyInfo.ItemNum += infItem.ItemNum;
			AccompanyItem.SetItem(AccompanyItemID, AccompanyInfo);

			InventoryItem.DeleteItem(InvenItemID);

			// ���Կ� ��۷Ḧ ����Ѵ�.
			TotalWeight += infItem.Weight * Int64ToInt(infItem.ItemNum);
			FeeAdena = CalculateFeeAdena();
			SetWeight();
			SetFeeAdena();
		}
		else
		{
			DialogSetID(DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY);
			DialogSetReservedItemInfo(infItem);
			DialogSetParamInt64(infItem.ItemNum);
			DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), infItem.Name, "" ) );
		}
	}
	else
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3016));
		DialogSetID(DIALOG_ONLY_NOTICE);
	}

	// "������ �����ۿ� ���ؼ� alt ������ �̵��� ����� ����� �ȵȴ�." ��� ����
	// All , ��� ������ �̵��� ���ؼ� ����� ������� , alt , �׳� drag&drop  , 2009. 9.17 �߰� 
	FeeAdena = CalculateFeeAdena();
	SetWeight();
	SetFeeAdena();
}
function UseAccompanyToInven(ItemInfo infItem)
{
	
	local int AccompanyItemID, InvenItemID;;
	local ItemInfo invenInfo;
	AccompanyItemID = AccompanyItem.FindItem( infItem.id);
	if (IsStackableItem( infItem.ConsumeType) && infItem.ItemNum != IntToInt64(1))
	{
		if (infItem.AllItemCount > IntToInt64(0))
		{
			invenItemID = InventoryItem.FindItem(infItem.id);
			// ���� INVEN�� ���������ִٸ� ��������Ѵ�.
			if (invenItemID >= 0)
			{
				InventoryItem.GetItem(invenItemID, invenInfo);
				// �κ��� ���� ������ ������ Accompany���� �Ѿ���� ������ �����ش�.
				invenInfo.ItemNum += infItem.AllItemCount;	
				InventoryItem.SetItem(invenItemID, invenInfo);
			}
			else //���� INVEN�� �������� ���ٸ� �������� �ʾƵ� �ȴ�. 
			{
				// Inven�� �����Ƿ� �� �����ش�.
				InventoryItem.AddItem(infItem);
			}
			
			
		
			AccompanyItem.DeleteItem(AccompanyItemID);
		

			// ���Կ� ��۷Ḧ ����Ѵ�.
			TotalWeight -= infItem.Weight * Int64ToInt(infItem.AllItemCount);
			FeeAdena = CalculateFeeAdena();
			SetWeight();
			SetFeeAdena();
		}
		else
		{
			DialogSetID(DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN);
			DialogSetReservedItemInfo(infItem);
			DialogSetParamInt64(infItem.ItemNum);
			DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), infItem.Name, "" ) );
		}
		
	}
	else
	{
		TotalWeight -= infItem.Weight;

		AccompanyItem.DeleteItem(AccompanyItemID);
		if (IsStackableItem( infItem.ConsumeType))
		{
			InvenItemID = InventoryItem.FindItem( infItem.id);
			if (InvenItemID >= 0)
			{
				InventoryItem.GetItem(InvenItemID, invenInfo);
				invenInfo.ItemNum += IntToInt64(1);
				inventoryItem.SetItem(invenItemID, invenInfo);
			}
			else
			{
				InventoryItem.AddItem(infItem);
			}
		}
		else
		{
			InventoryItem.AddItem(infItem);
		}
		FeeAdena = CalculateFeeAdena();
		SetWeight();
		SetFeeAdena();
	}
	if ( AccompanyItem.GetItemNum() == 0 && ZoneType != 12 )
		SendBtn.EnableWindow();
}
function OnDropItem( String strID, ItemInfo infItem, int x, int y )
{
	
	if (strID == "AccompanyItem" && infItem.DragSrcName == "InventoryItem")
	{
		if ( ZoneType == 12 )
			UseInvenToAccompany(infItem);
	}	
	else if (strID == "InventoryItem" && infItem.DragSrcName == "AccompanyItem")
	{
		UseAccompanyToInven(infItem);	
	}
}

function OnDBClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	local ItemInfo info;
	if (a_hItemWindow.GetItem(index, info))
	{
		if (a_hItemWindow.GetWindowName() == "AccompanyItem")
		{
			UseAccompanyToInven(info);
		}
		else if (a_hItemWindow.GetWindowName() == "InventoryItem")
		{
			if ( ZoneType == 12 )
				UseInvenToAccompany(info);
		}
	}	
}
function OnRClickItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	local ItemInfo info;
	if (a_hItemWindow.GetItem(index, info))
	{
		if (a_hItemWindow.GetWindowName() == "AccompanyItem")
		{
			UseAccompanyToInven(info);
		}
		else if (a_hItemWindow.GetWindowName() == "InventoryItem")
		{
			if ( ZoneType == 12 )
				UseInvenToAccompany(info);
		}
	}
}

function OnComboBoxItemSelected( String strID, int index )
{
	switch(strID)
	{
	case "PostTypeComboBox":
		if (index ==  TRADE_NORMAL )
		{			
			DisableSafetyAdena();
		}
		else if (index == TRADE_SAFE)
		{
			EnableSafetyAdena();	
		}

		break;
	}
}
function DisableSafetyAdena()
{
	Title_SafetyTradeAdena.DisableWindow();
	SafetyReceiveAdena.DisableWindow();
	SafetyTradeAdenaTextBox.DisableWindow();
	SafetyTradeAdenaTextBoxBg.DisableWindow();
	SafetyReceiveAdenaIcon.DisableWindow();
		

	Title_SafetyTradeAdena.SetTextColor(disableColor);
	SafetyTradeAdenaTextBox.SetTextColor(disableColor);
	SafetyReceiveAdenaIcon.SetTexture("L2UI_ct1.Icon.Icon_DF_Common_Adena_disable");

	SafetyTradeAdenaTextBox.SetText("0");
	SafetyTradeAdena = IntToInt64(0);
}
function EnableSafetyAdena()
{
	Title_SafetyTradeAdena.EnableWindow();
	SafetyReceiveAdena.EnableWindow();
	SafetyTradeAdenaTextBox.EnableWindow();
	SafetyTradeAdenaTextBoxBg.EnableWindow();
	SafetyReceiveAdenaIcon.EnableWindow();
	Title_SafetyTradeAdena.SetTextColor(enableColor);
	SafetyTradeAdenaTextBox.SetTextColor(enableColor);
	SafetyReceiveAdenaIcon.SetTexture("L2UI_ct1.Icon.Icon_DF_Common_Adena");
}
function SetWeight()
{
	WeightText.SetText(string(TotalWeight));
}
function SetFeeAdena()
{
	ChargeAdenaText.SetText(MakeCostStringInt64(FeeAdena));
}

function HandleDialogOK()
{
	local ItemInfo scInfo;
	local INT64 inputNum;
	local INT64 adena;
	local int invenItemID, AccompanyItemID;
	local ItemInfo invenInfo, AccompanyInfo;
	local bool allItemMove; // ��� �������� �ű�� ���ΰ�? ����Ŀ���� ��� ��� �������� a���� b�� �ű�� ���̶�� a���� �����־���Ѵ�.
	local int id;
 
	if (DialogIsMine() )
	{
		id = DialogGetID();


		if (id == DIALOG_NOTIFY_SEND_POST)
		{
			SendPostMsg();
		}
		else if (id == DIALOG_RECEIVE_ADENA) // ������
		{
			adena = StringToInt64(DialogGetString());
			if (adena > StringToInt64(ADENA_OVER_FLOW) || adena < IntToInt64(0))
			{
				DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
				DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(1369));		
			}
			else
			{
				SafetyTradeAdenaTextBox.SetText(MakeCostString(DialogGetString()));
				SafetyTradeAdena = adena;
			}
		}
		else if (id == DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN || id == DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY)
		{

			DialogGetReservedItemInfo( scInfo );
			inputNum =  StringToInt64(DialogGetString() );
			// ��û�� ������ 0���� Ŀ���Ѵ�.
			if (inputNum > IntToInt64(0) )
			{
				// ��û�� ������ ������ �ִ� ������ ũ�ٸ�
				if (inputNum >= scInfo.ItemNum )
				{
					inputNum = scInfo.ItemNum; // ���簡���� �ִ� ���� �������ش�. Maximum��..
					allItemMove = true; // Maixmum���¸� �����Ѵ�.
				}

				// ACCOMPANY ���� INVEN����
				if ( id == DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN)
				{			
					invenItemID = InventoryItem.FindItem(scInfo.id);
					AccompanyItemID = AccompanyItem.FindItem(scInfo.id);
					// ���� INVEN�� ���������ִٸ� ��������Ѵ�.
					if (invenItemID >= 0)
					{
						InventoryItem.GetItem(invenItemID, invenInfo);
						// �κ��� ���� ������ ������ Accompany���� �Ѿ���� ������ �����ش�.
						invenInfo.ItemNum += inputNum;	
						InventoryItem.SetItem(invenItemID, invenInfo);
					}
					else //���� INVEN�� �������� ���ٸ� �������� �ʾƵ� �ȴ�. 
					{
						// Inven�� �����Ƿ� �� �����ش�.
						AccompanyItem.GetItem(accompanyItemID, AccompanyInfo);
						AccompanyInfo.ItemNum = inputNum;
						InventoryItem.AddItem(AccompanyInfo);
					}
					
					
					if (allItemMove) // ���� �ű�� ���̹Ƿ� �����ش�.
					{
						AccompanyItem.DeleteItem(AccompanyItemID);
					}
					else	// �Ϻθ� �Ű��ֹǷ� ������ �����Ѵ�.
					{
						scInfo.ItemNum -= inputNum;
						AccompanyItem.SetItem(AccompanyItemID, scInfo);
					}

					// ���Կ� ��۷Ḧ ����Ѵ�.
					TotalWeight -= scInfo.Weight * Int64ToInt(inputNum);
					FeeAdena = CalculateFeeAdena();
					SetWeight();
					SetFeeAdena();
				}
				// INVEN ���� ACCOMPANY��
				else if (id == DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY )
				{
					AccompanyItemID = AccompanyItem.FindItem(scInfo.id);
					InvenItemID = InventoryItem.FindItem(scInfo.id);

					// ���� ACCOMPANY�� �������� �ִٸ� ������� �Ѵ�.
					if (AccompanyItemID >= 0)
					{
						AccompanyItem.GetItem(AccompanyItemID, AccompanyInfo);
						// Accompany�� ��������� ������ Inven���� �Ѿ���� ������ �����ش�.
						AccompanyInfo.ItemNum += inputNum;
						AccompanyItem.SetItem(AccompanyItemID, AccompanyInfo);
					}
					else // ���� Accompany�� �������� ���ٸ� �������� �ʾƵ� �ȴ�.
					{
						// Accompany�� �����Ƿ� �� �����ش�.
						InventoryItem.GetItem(InvenItemID, InvenInfo);
						InvenInfo.ItemNum = inputNum;
						AccompanyItem.AddItem(InvenInfo);
					}
					
					if (allItemMove) // ���� �ű�� ���̹Ƿ� �����ش�.
					{
						InventoryItem.DeleteItem(InvenItemID);
					}
					else	// �Ϻθ� �Ű��ֹǷ� ������ �����Ѵ�.
					{
						scInfo.ItemNum -= inputNum;
						InventoryItem.SetItem(InvenItemID, scInfo);
					}

					// ���Կ� ��۷Ḧ ����Ѵ�.
					TotalWeight += scInfo.Weight * Int64ToInt(inputNum);
					FeeAdena = CalculateFeeAdena();
					SetWeight();
					SetFeeAdena();
				}
			}
		}
	}
}
function HandlePostWriteOpen()
{

	if (PostBoxWnd.IsShowwindow())
	{
		PostBoxWnd.HideWindow();
	}
}

function HandleSentEnableAddItem( string param)
{
	local ItemInfo info;

	ParamToItemInfo( param, info );
	
	InventoryItem.AddItem(info);
	if (info.id.classid == 57)	
	{
		adenaInfo = info;
		InventoryItem.SwapItems(0, InventoryItem.GetItemNum() - 1);
	}
}

function HandlePostWriteEnd()
{
	SetInventoryPageNumber();
}
function HandleReplyWritePost(string param)
{
	local int isuccess;
	ParseInt(param, "Success", isuccess);

	if (isuccess == 1)
	{
		ReceiverID.AddItemToAutoCompleteHistory( strSendID );
		Me.hidewindow();
		ClearAll();
	}

}
function HandleSendBtn()
{
	if (PostTypeComboBox.GetSelectedNum() == 1 && AccompanyItem.GetItemNum() <= 0) //�����ŷ��ε� ÷���� �������� ���ٸ�
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(2966));		
		DialogSetID(DIALOG_ONLY_NOTICE);

	}
	else if (PostTitle.GetString() == "" )
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(328));	
		DialogSetID(DIALOG_ONLY_NOTICE);
	}
	else if(PostTypeComboBox.GetSelectedNum() == 1 && SafetyTradeAdena == IntToInt64(0) )
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3020));		
		DialogSetID(DIALOG_ONLY_NOTICE);
	}
	else if (Len(ReceiverID.GetString()) > MAX_CHAR_LENGTH)
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3074));		
		DialogSetID(DIALOG_ONLY_NOTICE);
	}
	else if (Len(PostTitle.GetString()) > MAX_TITLE_LENGTH)
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3075));		
		DialogSetID(DIALOG_ONLY_NOTICE);
	}
	else if (Len(Contents.GetString()) > MAX_CONTENTS_LENGTH)
	{
		DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
		DialogShow(DIALOG_Modalless,DIALOG_Notice, GetSystemMessage(3076));		
		DialogSetID(DIALOG_ONLY_NOTICE);
	}
	else
	{
		DialogHide();
		if (PostTypeComboBox.GetSelectedNum() == 0 )	//�Ϲݿ����̸�
		{
			DialogShow(DIALOG_Modal,DIALOG_OKCancel, GetSystemMessage(2967));
		}
		else											//���û���̸�
		{
			DialogShow(DIALOG_Modal,DIALOG_OKCancel, GetSystemMessage(3078));
		}		
		DialogSetID(DIALOG_NOTIFY_SEND_POST);
//		DialogSetHostWndScript(myScript);
	}
}

function HandleSafetyReceiveAdena()
{
	DialogSetID(DIALOG_RECEIVE_ADENA);
	DialogSetParamInt64(IntToInt64(0));
	DialogShow(DIALOG_Modal, DIALOG_NumberPad, GetSystemMessage(2987));
	
}


function SendPostMsg()
{
	local int i;
	local ItemInfo iteminfo;
	local RequestItem item;
	itemIDList.Remove(0, itemIDList.Length);
//	itemAmountList.Remove(0, itemAmountList.Length);

	for (i = 0; i < AccompanyItem.GetItemNum(); i++)
	{		
		AccompanyItem.GetItem(i, iteminfo);
		item.id = iteminfo.id.serverid;
		item.amount = iteminfo.ItemNum;
		itemIDList.Insert(itemIDList.Length,1); itemIDList[itemIDList.Length - 1] = item;
	}
	if (PostTypeComboBox.GetSelectedNum() == 0)
		SafetyTradeAdena = IntToInt64(0);
	strSendID = ReceiverID.GetString();
	RequestSendPost(ReceiverID.GetString(), PostTypeComboBox.GetSelectedNum(), PostTitle.GetString(), Contents.GetString(), itemIDList, SafetyTradeAdena);


}

function ClearAll()
{
	PostTypeComboBox.clear();
	PostTypeComboBox.AddStringWithReserved(GetSystemString(2071),0);
	PostTypeComboBox.AddStringWithReserved(GetSystemString(2072),1);
	PostTypeComboBox.SetSelectedNum(0);

	FeeAdena = IntToInt64(0);
	TotalWeight = 0;
	SafetyTradeAdena = IntToInt64(0);

	ReceiverID.SetString("");
	ReceiverID.SetMaxLength(MAX_CHAR_LENGTH);
	PostTypeComboBox.SetSelectedNum(0);
	PostTitle.SetString("");
	PostTitle.SetMaxLength(MAX_TITLE_LENGTH);
	Contents.SetString("");
	itemIDList.Remove(0, itemIDList.Length);
	SafetyTradeAdena = IntToInt64(0);
	//AdenaTextBox.SetText("0");
	SafetyTradeAdenaTextBox.SetText("0");
	WeightText.SetText("0");
	ChargeAdenaText.SetText("0");
	AccompanyItem.clear();
	InventoryItem.clear();

	FeeAdena = CalculateFeeAdena();
	SetWeight();
	SetFeeAdena();

	DisableSafetyAdena();

}

function SetPostWriteWnd(string senderName, string title, string context)
{
	ClearAll();
	ReceiverID.SetString(senderName);
	PostTitle.SetString(title);
	Contents.SetString(context);
	Me.ShowWindow();
	Me.Setfocus();
}
function INT64 CalculateFeeAdena()
{
	local int Fee;
//	Fee = BASE_FEE_ADENA + allweight * FEEMUITIPLIER;
	FEE = BASE_FEE_ADENA + FEE_PER_SLOT * AccompanyItem.GetItemNum();
	return IntToInt64(Fee);
}
function SetInventoryPageNumber()
{
	if (InventoryItem.GetSideTypePageNum() == 0 )
	{
		InventoryPageNumber.SetText("0/0");
	}
	else
	{
		InventoryPageNumber.SetText(string(InventoryItem.GetSideTypeCurPage() + 1)$"/"$string(InventoryItem.GetSideTypePageNum()));
	}
}
defaultproperties
{
}
