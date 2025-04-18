//-----------------------------------------------------------//
//		 Premium Item alarm btn window
//					by innowind (NC Soft)
//-----------------------------------------------------------//

class PremiumItemBtnWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle AlarmWnd;
var ButtonHandle btnItemPop;

function OnRegisterEvent()
{
	RegisterEvent( EV_PremiumItemAlarm );
	RegisterEvent( EV_GoodsInventoryNoti );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	Initialize();
	Clear();
}

function Initialize()
{
	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "PremiumItemBtnWnd" );
		AlarmWnd = GetHandle( "PremiumItemAlarmWnd" );
		btnItemPop = ButtonHandle ( GetHandle( "PremiumItemBtnWnd.btnItemPop" ) );
	}
	else
	{
		Me = GetWindowHandle( "PremiumItemBtnWnd" );
		AlarmWnd = GetWindowHandle( "PremiumItemAlarmWnd" );
		btnItemPop = GetButtonHandle ("PremiumItemBtnWnd.btnItemPop" );
	}

	if( IsUseGoodsInvnentory() == false )
	{
		btnItemPop.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2313)));	// ����. �����̾� �������� �����Ͽ����ϴ�.
	}
	else
	{
		btnItemPop.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(3462)));	// ����. ���ο� ��ǰ�� �����Ͽ����ϴ�. �������� Ŭ���Ͻø� ��ǰ�� Ȯ���Ͻ� �� �ֽ��ϴ�.
	}
}

function Clear()
{

}

// ��ư�� Ŭ���ϸ� �˸�â �˾�
function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnItemPop":
		if( IsUseGoodsInvnentory() == false )
		{
			if(!AlarmWnd.isShowWindow()) AlarmWnd.showWindow();
		}
		else
		{
			HandleShowProductInventory();
		}
		Me.hideWindow();
		Me.SetWindowSize( 0 , 32 );	//�������� ũ�⸦ ���������ش�. 
		break;
	}
}

//��ǰ �κ��丮 ����
function HandleShowProductInventory()
{
	local WindowHandle win;	
	win = GetWindowHandle( "ProductInventoryWnd" );

	if( ! win.IsShowWindow() )
	{
		win.ShowWindow();
		win.SetFocus();
	}
}

// �̺�Ʈ�� �޾� �����͸� �Ľ��Ѵ�. 
function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PremiumItemAlarm:
			Me.SetWindowSize( 32 , 32);	//�������� ũ�⸦ ���������ش�. 
			ShowWindowWithFocus("PremiumItemBtnWnd");
			btnItemPop.ShowWindow();
			class'UIAPI_EFFECTBUTTON'.static.BeginEffect("PremiumItemBtnWnd.btnItemPop", 0);
			AddSystemMessage(2313);	
		break;

		case EV_GoodsInventoryNoti:
			Me.SetWindowSize( 32 , 32);	//�������� ũ�⸦ ���������ش�. 
			ShowWindowWithFocus("PremiumItemBtnWnd");
			btnItemPop.ShowWindow();
			class'UIAPI_EFFECTBUTTON'.static.BeginEffect("PremiumItemBtnWnd.btnItemPop", 0);
			break;
	}
}

//���°� ���� ��� ������ �ݾ��ش�.
function OnExitState( name a_NextStateName )
{
	Clear();
	Me.SetWindowSize( 0 , 32);	//�������� ũ�⸦ ���������ش�. 
	Me.HideWindow();	
}
defaultproperties
{
}
