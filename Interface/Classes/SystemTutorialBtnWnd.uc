class SystemTutorialBtnWnd extends UICommonAPI;
var WindowHandle SystemTutorialBtnWnd;




function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
	{
		SystemTutorialBtnWnd = GetHandle( "SystemTutorialBtnWnd" );
	}
	else
	{
		SystemTutorialBtnWnd = GetWindowHandle( "SystemTutorialBtnWnd" );
	}
}

function OnShow()
{
	SystemTutorialBtnWnd.HideWindow();
}

function OnEnterState( name a_PrevStateName )
{
	if( a_PrevStateName == 'LoadingState' )			
	{
		//~debug ("���� �ε�");
		SystemTutorialBtnWnd.HideWindow();
	}
}

function OnClickButton(string BtnName)
{
	local SystemTutorialWnd script;
	script = SystemTutorialWnd(GetScript("SystemTutorialWnd"));
	//~ debug ("���� ������ ��ư?"@ BtnName);
	switch(btnName)
	{	
		case "btnTutorial1":
		//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(1);
		
		break;
		
		case "btnTutorial2":
		//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(2);
		
		break;
		
		case "btnTutorial3":
		//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(3);
		
		break;
		
		case "btnTutorial4":
		//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(4);
		
		break;
		
		case "btnTutorial5":
		//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(5);
		
		break;
		
		case "btnTutorial6":
		//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(6);
		
		break;
		
		case "btnTutorial7":
		//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(7);
		
		break;
		
		case "btnTutorial8":
		//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(8);
		
		break;
		
		case "btnTutorial9":
			//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(9);
		
		break;
		
		case "btnTutorial10":
			//debug ("���� ������ ��ư?"@ BtnName);
		script.BubbleData(10);
		
		break;
	}
}
defaultproperties
{
}
