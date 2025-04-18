class AuctionBtnWnd extends UICommonAPI;

const LENGTH_ONE = 3;

var WindowHandle Me;
var ButtonHandle btnAuction[LENGTH_ONE];

var int ButtonOn[LENGTH_ONE];		//��Ű� 3�����̹Ƿ�
					//1�̸� �ְ����� ����
// ��°������ bool�� �迭�� ����� ���ٴ�.. 


function OnRegisterEvent()
{
	RegisterEvent(EV_SystemMessage);		// �ý��� �޼����� ��ŷ�ϱ� ���� �̺�Ʈ
	RegisterEvent( EV_ITEM_AUCTION_INFO );	// ���� �����ڰ� ������ ��� ��ư�� �����ֱ� ���� �̺�Ʈ
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

	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "AuctionBtnWnd" );
		btnAuction[0] = ButtonHandle ( GetHandle( "AuctionBtnWnd.btnAuction1" ) );
		btnAuction[1] = ButtonHandle ( GetHandle( "AuctionBtnWnd.btnAuction2" ) );
		btnAuction[2] = ButtonHandle ( GetHandle( "AuctionBtnWnd.btnAuction3" ) );	
	}
	else
	{
		Me = GetWindowHandle( "AuctionBtnWnd" );
		btnAuction[0] = GetButtonHandle( "AuctionBtnWnd.btnAuction1" );
		btnAuction[1] = GetButtonHandle( "AuctionBtnWnd.btnAuction2" );
		btnAuction[2] = GetButtonHandle( "AuctionBtnWnd.btnAuction3" );	
	}
}

function Load()
{
	clear();
}

function clear()
{
	local int idx;
	for(idx = 0; idx < LENGTH_ONE; idx++)
	{
		ButtonOn[idx] = -1;	// ��ư 3���� �ʱ�ȭ���ش�. 
		btnAuction[idx].HideWindow();
	}	
}

// �̺�Ʈ�� �޾� �����͸� �Ľ��Ѵ�. 
function OnEvent(int Event_ID, string param)
{
	//�̺�Ʈ�� �޴� ����
	local int SystemMsgIndex;
	
	switch(Event_ID)
	{
	// �ý��� �޼����� ���� �ܿ�
	case EV_SystemMessage:
		ParseInt( param, "Index", SystemMsgIndex );
		HandleAuctionSystemMessage(SystemMsgIndex);
		break;
	}
}

//���°� ���� ��� ������ �ݾ��ش�.
function OnExitState( name a_NextStateName )
{
	clear();
}


function HandleAuctionSystemMessage(int SystemMsgIndex)
{
	if(SystemMsgIndex == 2192)		//��ſ� �����Ͽ����ϴ�.
	{
		SetAuctionTooltip();
	}
	else if(SystemMsgIndex == 2080 || SystemMsgIndex == 2131)		//���� �����ڿ� ���� ��Ű� ��ҵǾ����ϴ�. or  �����Ǿ����ϴ�.
	{
		DeleteAuctionTooltip();
	}
}

//�ְ� �������̶�� ������ �������ش�. �����ִ� ���� �ý��� �޼����� ���� ���
function SetAuctionTooltip()	
{
	btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2198)));
	ButtonOn[0]  = 1;
	class'UIAPI_WINDOW'.static.SetAnchor( "SystemTutorialBtnWnd", "AuctionBtnWnd", "TopLeft", "BottomLeft", 5, 0 );		//�ý��� Ʃ�丮�� ��ư�� ��� ��ư ���� �ٿ��ش�.  ��� ��ư�� ������ margin 5
	btnAuction[0].ShowWindow();
	ComputeWidth();
	
}

//�ٸ� ����� �ְ������ϸ� �������� �����.  
function DeleteAuctionTooltip()	
{
	btnAuction[0].SetTooltipCustomType(MakeTooltipSimpleText(""));
	btnAuction[0].HideWindow();
	class'UIAPI_WINDOW'.static.SetAnchor( "SystemTutorialBtnWnd", "AuctionBtnWnd", "TopLeft", "BottomLeft", 0, 0 );		//�ý��� Ʃ�丮�� ��ư�� ��� ��ư ���� �ٿ��ش�.  ��� ��ư�� ������ margin 0
	ComputeWidth();
}

// Ȱ��ȭ�� ��ư ���� ���� ������ ���̸� ����ϰ�, ��ġ�� �������Ѵ�. 
function ComputeWidth()
{
	local int idx;	//for���� ���� ����
	local int nOpenButton;
	local int nNowX;
	
	nOpenButton = 0;
	nNowX = 0;
	for(idx=0 ; idx < LENGTH_ONE ; idx++)
	{
		//�ش� ��ư�� �������� ���
		if( ButtonOn[idx] > -1)
		{
			nOpenButton++;
			if( nOpenButton > 1)	//ó�� �߰��ϸ� 0���� �����Ѵ�.
				nNowX = nNowX + 37;
			btnAuction[0].Move(nNowX, 0);
		}		
	}

	Me.SetWindowSize( nOpenButton * 37 , 32);	//�������� ũ�⸦ ���������ش�.  // Ŭ������������
}
defaultproperties
{
}
