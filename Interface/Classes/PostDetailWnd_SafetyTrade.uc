class PostDetailWnd_SafetyTrade extends UICommonAPI;


var WindowHandle Me;
var WindowHandle General;

var TextboxHandle Title_SenderID;
var TextboxHandle SenderID;
var TextboxHandle PostType;
var TextboxHandle PostTitle;
var TextListBoxHandle PostContents;
var TextboxHandle WeightText;
var TextboxHandle SafetyTradeAdenaText;
var	INT64		  ReceivedTradeAdena;

//var ButtonHandle ReceiveBtn; �� �� ������ ...
var ButtonHandle ReceiveBtn;
var ButtonHandle ReturnBtn;
var ButtonHandle SendCancelBtn;
var ButtonHandle ReplyBtn;
//���� ����(10.03.19)
var ButtonHandle AddBtn;



var ItemWindowHandle AccompanyItem;

var int trade;		//�����ŷ�, �Ϲݿ���
var int returnd;	//�ݼ۵ȸ��Ͽ���
var int mailID;
var int totalWeight;//��  ����
var int returnable, sentbysystem;

//var int IsPeaceZone;

var Color impactcolor;
const DIALOG_RECEIVE_TRADE_POST = 1111;
const DIALOG_RETURN_POST = 2222;
function OnRegisterEvent()
{
	registerEvent( EV_ReplyReceivedPostStart ); 
	registerEvent( EV_ReplyReceivedPostAddItem );
	registerEvent( EV_ReplyReceivedPostEnd );

	registerEvent( EV_ReplySentPostStart ); 
	registerEvent( EV_ReplySentPostAddItem );
	registerEvent( EV_ReplySentPostEnd );
	registerEvent( EV_DialogOK );

	registerEvent( EV_SetRadarZoneCode );
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

	totalWeight = 0;
	impactcolor.R = 255;
	impactcolor.G = 114;
	impactcolor.B = 0;
//	ResetUI();
	
}

function OnShow()
{
	if (General.IsShowWindow())
		General.HideWindow();
}


function Initialize()
{
	Me = GetHandle("PostDetailWnd_SafetyTrade");
	General = GetHandle("PostDetailWnd_General");

	Title_SenderID=TextboxHandle(GetHandle("PostDetailWnd_SafetyTrade.Title_SenderID"));
	SenderID=TextboxHandle(GetHandle("PostDetailWnd_SafetyTrade.SenderID"));
	PostType=TextboxHandle(GetHandle("PostDetailWnd_SafetyTrade.PostType"));
	PostTitle=TextboxHandle(GetHandle("PostDetailWnd_SafetyTrade.PostTitle"));
	PostContents=TextListBoxHandle(GetHandle("PostDetailWnd_SafetyTrade.PostContents"));
	WeightText=TextboxHandle(GetHandle("PostDetailWnd_SafetyTrade.WeightText"));
	SafetyTradeAdenaText=TextboxHandle(GetHandle("PostDetailWnd_SafetyTrade.SafetyTradeAdenaText"));
	

	ReceiveBtn=ButtonHandle (GetHandle("PostDetailWnd_SafetyTrade.ReceiveBtn"));
	ReturnBtn=ButtonHandle (GetHandle("PostDetailWnd_SafetyTrade.ReternBtn"));
	SendCancelBtn=ButtonHandle (GetHandle("PostDetailWnd_SafetyTrade.SendCancelBtn"));
	ReplyBtn=ButtonHandle (GetHandle("PostDetailWnd_SafetyTrade.ReplyBtn"));
	//���� ����(10.03.19)
	AddBtn=ButtonHandle (GetHandle("PostDetailWnd_SafetyTrade.AddBtn"));

	AccompanyItem = ItemWindowHandle(GetHandle("PostDetailWnd_SafetyTrade.AccompanyItem"));

}

function InitializeCOD()
{

	Me = GetWindowHandle("PostDetailWnd_SafetyTrade");
	General = GetWindowHandle("PostDetailWnd_General");

	Title_SenderID=GetTextBoxHandle("PostDetailWnd_SafetyTrade.Title_SenderID");
	SenderID=GetTextBoxHandle("PostDetailWnd_SafetyTrade.SenderID");
	PostType=GetTextBoxHandle("PostDetailWnd_SafetyTrade.PostType");
	PostTitle=GetTextBoxHandle("PostDetailWnd_SafetyTrade.PostTitle");
	PostContents=GetTextListBoxHandle("PostDetailWnd_SafetyTrade.PostContents");
	WeightText=GetTextBoxHandle("PostDetailWnd_SafetyTrade.WeightText");
	SafetyTradeAdenaText=GetTextBoxHandle("PostDetailWnd_SafetyTrade.SafetyTradeAdenaText");
		
	
	ReceiveBtn=GetButtonHandle("PostDetailWnd_SafetyTrade.ReceiveBtn");
	ReturnBtn=GetButtonHandle("PostDetailWnd_SafetyTrade.ReternBtn");
	SendCancelBtn=GetButtonHandle("PostDetailWnd_SafetyTrade.SendCancelBtn");
	ReplyBtn=GetButtonHandle("PostDetailWnd_SafetyTrade.ReplyBtn");
	//���� ����(10.03.19)
	AddBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.AddBtn");

	AccompanyItem = GetItemWindowHandle("PostDetailWnd_SafetyTrade.AccompanyItem");
}

function OnEvent( int Event_ID, String Param )
{
	//debug ("Event Receivedss" @ Event_ID @ Param);
	local int zonetype;
	switch(Event_ID)
	{
	case EV_ReplyReceivedPostStart:		
		OnEVReplyReceivedPostStart(Param);
		break;
	case EV_ReplyReceivedPostAddItem:
		OnEVReplyReceivedPostAddItem(Param);
		break;
	case EV_ReplyReceivedPostEnd:
		OnEVReplyReceivedPostEnd(Param);
		break;

	case EV_ReplySentPostStart:
		OnEVReplySentPostStart(Param);
		break;
	case EV_ReplySentPostAddItem:
		OnEVReplySentPostAddItem(Param);
		break;
	case EV_ReplySentPostEnd:
		OnEVReplySentPostEnd(Param);
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;	
	case EV_SetRadarZoneCode:
		ParseInt( Param, "ZoneCode", zonetype );		
		if (zonetype == 12)
		{
			SendCancelBtn.EnableWindow();
			ReceiveBtn.EnableWindow();
			ReturnBtn.EnableWindow();
			ReplyBtn.EnableWindow();
		}
		else
		{
			if (Me.IsShowWindow())
				AddSystemMessage(3066);

			SendCancelBtn.DisableWindow();
			ReceiveBtn.DisableWindow();
			ReturnBtn.DisableWindow();
			ReplyBtn.DisableWindow();
		}
		break;
	}
}


function OnEVReplyReceivedPostStart(String Param)
{
	ClearAll();
	ParseInt(param, "trade", trade);
	ParseInt(param, "Returnd", returnd);  // �ݼ۵� �����ΰ�(1), �ƴѰ�(0)
	if (returnd == 0 && trade == 1 ) //�ݼ۵� ������ �ƴϰ�, �����ŷ��ΰ��
	{		
		Me.SetWindowTitle(GetSystemString(2075));
		ReceiveBtn.Hidewindow();
		ReturnBtn.HideWindow();
		SendCancelBtn.HideWindow();

		Me.ShowWindow();
		Me.Setfocus();
		
	}
	totalWeight = 0;
}

function OnEVReplyReceivedPostAddItem(String Param)
{
	local ItemInfo info;
	if (returnd == 0 && trade == 1 ) //�ݼ۵� ������ �ƴϰ�, �����ŷ��ΰ��
	{
		ParamToItemInfo( param, info );
		AccompanyItem.AddItem(info);	

		totalWeight += info.Weight * Int64ToInt(info.ItemNum);

		if (!ReceiveBtn.IsShowwindow())
			ReceiveBtn.Showwindow();
	}
}

function OnEVReplyReceivedPostEnd(String Param)
{
	local string SenderName, title, contents;
//	local INT64 tradeMoney;	
	local string fixedtitle;

	if (returnd == 0 && trade == 1) //�ݼ۵� ������ �ƴϰ�, �����ŷ��ΰ��
	{
		ParseInt(param, "MailID", mailID);  
		ParseString(param, "SenderName", SenderName);	// ���� ���
		ParseString(param, "Title", title);				// ����
		ParseString(param, "Content", contents);		// ����
		ParseINT64(param, "TradeMoney", ReceivedTradeAdena);	// û�����
		ParseInt(param, "ReturnAble", returnable);  // ����Ҽ��ֳ�(1), ����(0)
		ParseInt(param, "Sentbysystem", sentbysystem);// �ý����� ���������ΰ�(1), �ƴѰ�(0)
		

		PostType.SetTextColor(impactcolor);
		PostType.SetText(GetSystemString(2072));
		fixedtitle = DivideStringWithWidth(title, 380);
		if (fixedtitle != title)
		{
			fixedtitle =  fixedtitle $ "...";
		}
		PostTitle.SetText(fixedtitle);

		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		Title_SenderID.SetText(GetSystemString(2078));

		SafetyTradeAdenaText.SetTextColor(impactcolor);
		SafetyTradeAdenaText.SetText(MakeCostStringInt64(ReceivedTradeAdena));

		if (AccompanyItem.GetItemNum() != 0 )
		{
			if (!ReceiveBtn.IsShowwindow())
				ReceiveBtn.Showwindow();
		}

		if (returnable == 1)
		{
			if (ReceiveBtn.IsShowwindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_SafetyTrade", "BottomCenter", "BottomRight", -1, -4);
			}
			ReturnBtn.ShowWindow();
//			ReturnBtn.EnableWindow();

		}
		else
		{
			if (ReceiveBtn.IsShowwindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_SafetyTrade", "BottomCenter", "BottomCenter", 0, -4);
			}
			ReturnBtn.HideWindow();
		}
		if (sentbysystem == 1) //�ý����� ���������̸�
		{
			if (returnd == 1)
				SenderID.SetText(GetSystemString(2073));
			else
				SenderID.SetText(GetSystemString(2211));
			if (ReceiveBtn.IsShowwindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_SafetyTrade", "BottomCenter", "BottomCenter", 0, -4);
			}
			ReturnBtn.HideWindow();
		}
		else
		{
			SenderID.SetText(SenderName);
		}

		if (sentbysystem == 1)
		{
			ReplyBtn.HideWindow();
		}
		else
		{
			ReplyBtn.ShowWindow();
		}

		if (AccompanyItem.GetItemNum() == 0 )
		{
			if (ReceiveBtn.IsShowwindow())
			{
				ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
			}
			ReturnBtn.HideWindow();
		}

		WeightText.SetText(string(totalWeight));
	}

}

function OnEVReplySentPostStart(String Param)
{
	ClearAll();
	ParseInt(param, "trade", trade);

	if (trade == 1)
	{		
		Me.SetWindowTitle(GetSystemString(2076));
		ReceiveBtn.Hidewindow();
		ReturnBtn.HideWindow();
		SendCancelBtn.HideWindow();

		Me.ShowWindow();
		Me.Setfocus();
	}

}

function OnEVReplySentPostAddItem(String Param)
{
	local ItemInfo info;
	if (trade == 1 ) //�����ŷ��̸�
	{
		ParamToItemInfo( param, info );
		AccompanyItem.AddItem(info);	
	}
}

function OnEVReplySentPostEnd(String Param)
{
	local string ReceiverName, title, contents;
	local INT64 tradeMoney;
	local int notOpend;
	local string fixedtitle;

	if (trade == 1)
	{
		ParseInt(param, "MailID", mailID);				// ���� ���̵�
		ParseString(param, "ReceiverName", ReceiverName);	// ���� ���
		ParseString(param, "Title", title);				// ����
		ParseString(param, "Content", contents);		// ����
		ParseINT64(param, "TradeMoney", tradeMoney);	// û�����
		ParseInt(param, "NotOpend", notOpend);  // ����Ҽ��ֳ�(1), ����(0)
		
		PostType.SetTextColor(impactcolor);
		PostType.SetText(GetSystemString(2072));
		fixedtitle = DivideStringWithWidth(title, 380);
		if (fixedtitle != title)
		{
			fixedtitle =  fixedtitle $ "...";
		}
		PostTitle.SetText(fixedtitle);
		Title_SenderID.SetText(GetSystemString(2087));
		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		SenderID.SetText(ReceiverName);
		
		ReceiveBtn.HideWindow();
		ReturnBtn.HideWindow();
		ReplyBtn.HideWindow();
		
		SafetyTradeAdenaText.SetTextColor(impactcolor);
		SafetyTradeAdenaText.SetText(MakeCostStringInt64(tradeMoney));

		if (AccompanyItem.GetItemNum() != 0)
		{
			SendCancelBtn.ShowWindow();
//			SendCancelBtn.EnableWindow();
	
		}
		else
		{
		//	AddSystemMessage(3030);
			SendCancelBtn.HideWindow();
		}



	}
}

function ClearAll()
{

	SenderID.SetText("");
	PostType.SetTextColor(impactcolor);
	PostType.SetText(GetSystemString(2072));
	PostTitle.SetText("");

	PostContents.Clear();
	WeightText.SetText("0");
	SafetyTradeAdenaText.SetTextColor(impactcolor);
	SafetyTradeAdenaText.SetText("0");

	ReceiveBtn.HideWindow();
	ReturnBtn.HideWindow();
	SendCancelBtn.HideWindow();
	AccompanyItem.Clear();

}

function OnClickButton( String a_ButtonID )
{

	switch( a_ButtonID )
	{
	case "ReceiveBtn":		
		if (returnd == 0 && trade == 1)
		{
			DialogHide();
			DialogShow(DIALOG_Modalless,DIALOG_OKCancel, MakeFullSystemMsg( GetSystemMessage(3086), SenderID.GetText(), ConvertNumToText(Int64ToString(ReceivedTradeAdena))));
			DialogSetID(DIALOG_RECEIVE_TRADE_POST);
		}
		else
		{
			RequestReceivePost(mailID);
			Me.HideWindow();
		}	
		break;
	case "ReternBtn":
		if (returnd == 0 && trade == 1 && returnable == 1)
		{
			DialogHide();
			DialogShow(DIALOG_Modalless,DIALOG_OKCancel, GetSystemMessage(3069));
			DialogSetID(DIALOG_RETURN_POST);			
		}
		break;
	case "SendCancelBtn":
		RequestCancelSentPost(mailID);
		Me.HideWindow();
		break;
	case "ReplyBtn":
		HandleReplyBtn();
		break;
	//���� ����(10.03.19)
	case "AddBtn":
		HandleAddBtn();
		break;
	}
}
function HandleDialogOK()
{
	local int id;
	if (DialogIsMine() )
	{
		id = DialogGetID();

		if (id == DIALOG_RECEIVE_TRADE_POST)
		{
			RequestReceivePost(mailID);
			Me.HideWindow();
		}
		else if (id == DIALOG_RETURN_POST )
		{
			RequestRejectPost(mailID);
			Me.HideWindow();
		}
	}
}
function HandleReplyBtn()
{
	local PostWriteWnd script;
	local string title;
	if (returnd != 1)
	{
		RequestPostItemList();
		script = PostWriteWnd(GetScript("PostWriteWnd"));
		Me.HideWindow();
		title = "[Re]"$ PostTitle.GetText();
		script.SetPostWriteWnd(SenderID.GetText(), title, "");
	}
}
//���� ����(10.03.19)
function HandleAddBtn()
{
	class'PostWndAPI'.static.RequestAddingPostFriend( SenderID.GetText() );
}
defaultproperties
{
}
