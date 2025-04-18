class BR_EventHalloweenTodayWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle ServerTextBox;
var TextBoxHandle MyTextBox;
var TextBoxHandle MsgTextBox;
var TextBoxHandle TitleTextBox;

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_EventRankerNowList );	
	RegisterEvent( EV_BR_EventRankerLastList );	
}

function OnLoad()
{
	Initialize();
}

function OnShow()
{
	Me.SetTimer( 200901, 7000 );
	
	TitleTextBox.SetText( GetSystemMessage(2031) );	// [��� ��ٷ� �ּ���] - ��Ŷ�� �ʰ� ���� ��찡 �־
	ServerTextBox.SetText( "" );	
	MyTextBox.SetText( "" );
	MsgTextBox.SetText( "" );
}

function OnHide()
{
	Me.KillTimer( 200901 );
}

function OnTimer( int TimerID )
{	
	if(TimerID == 200901)
	{
		if( IsShowWindow("BR_EventHalloweenTodayWnd") ) Me.HideWindow(); // 7�� �� �ڵ����� ����
	}
}

function Initialize()
{
	if (CREATE_ON_DEMAND==0) {
		Me = GetHandle( "BR_EventHalloweenTodayWnd" );
		ServerTextBox = TextBoxHandle ( GetHandle( "BR_EventHalloweenTodayWnd.ServerTextBox" ) );		
		MyTextBox = TextBoxHandle ( GetHandle( "BR_EventHalloweenTodayWnd.MyTextBox" ) );		
		MsgTextBox = TextBoxHandle ( GetHandle( "BR_EventHalloweenTodayWnd.MsgTextBox" ) );		
		TitleTextBox = TextBoxHandle ( GetHandle( "BR_EventHalloweenTodayWnd.TitleTextBox" ) );		
	}
	else
	{
		Me = GetWindowHandle( "BR_EventHalloweenTodayWnd" );
		ServerTextBox = GetTextBoxHandle( "BR_EventHalloweenTodayWnd.ServerTextBox" );
		MyTextBox = GetTextBoxHandle( "BR_EventHalloweenTodayWnd.MyTextBox" );
		MsgTextBox = GetTextBoxHandle( "BR_EventHalloweenTodayWnd.MsgTextBox" );
		TitleTextBox = GetTextBoxHandle( "BR_EventHalloweenTodayWnd.TitleTextBox" );
	}
}

function OnEvent(int Event_ID, String a_param)
{
	local int count, bestScore, myScore;
	
	if (Event_ID == EV_BR_EventRankerNowList) // ���� ���
	{
		ParseInt(a_param, "Count", count);
		ParseInt(a_param, "BestScore", bestScore);
		ParseInt(a_param, "Myscore", myScore);
		Debug("EV_BR_EventRankerNowList Count: "$count);
		Debug("EV_BR_EventRankerNowList BestScore: "$bestScore);
		Debug("EV_BR_EventRankerNowList Myscore: "$myScore);
		SetTodayTextbox(count, bestScore, myScore);
	}
	else if (Event_ID == EV_BR_EventRankerLastList) // ���� ���
	{
		ParseInt(a_param, "Count", count); 
		ParseInt(a_param, "BestScore", bestScore);
		ParseInt(a_param, "Myscore", myScore);
		Debug("EV_BR_EventRankerLastList Count: "$count);
		Debug("EV_BR_EventRankerLastList BestScore: "$bestScore);
		Debug("EV_BR_EventRankerLastList Myscore: "$myScore);
		SetLastTextbox(count, bestScore, myScore);
	}
}

function SetTodayTextbox(int count, int bestScore, int myScore)
{
	TitleTextBox.SetText( GetSystemString(5040) );
	
	if (bestScore>=5 ) // ���� �ְ� ��� : 5�� �̻�
		ServerTextBox.SetText( MakeFullSystemMsg( GetSystemMessage(6023), string(bestScore), string(count) ) );
	else // ���� �ְ� ��� : 4�� ����
		ServerTextBox.SetText( GetSystemMessage(6025) );
		
	if( myScore>=5 ) // ���� �ְ� ��� : 5�� �̻�
		MyTextBox.SetText( MakeFullSystemMsg( GetSystemMessage(6024), string(myScore), "" ));
	else // ���� �ְ� ��� : 4�� ����
		MyTextBox.SetText( GetSystemMessage(6026) );
		
	if( bestScore==myScore && myScore>=0 ) // ���� 1�� �϶� & ���� ��� 5�� �̻�
		MsgTextBox.SetText( GetSystemString(5041) ); // [���� 1���Դϴ�!]
	else
		MsgTextBox.SetText( "" );
}

function SetLastTextbox(int count, int bestScore, int myScore)
{
	TitleTextBox.SetText( GetSystemString(5039) );	
	
	if (bestScore>=10 ) // ���� �ְ� ��� : 10�� �̻�
		ServerTextBox.SetText( MakeFullSystemMsg( GetSystemMessage(6023), string(bestScore), string(count) ) );
	else // ���� �ְ� ��� : 9�� ���� or ����� ���� ���
		ServerTextBox.SetText( GetSystemMessage(6028) );
		
	if( myScore>=5 ) // ���� �ְ� ��� : 5�� �̻�
		MyTextBox.SetText( MakeFullSystemMsg( GetSystemMessage(6024), string(myScore), "" ));
	else // ���� �ְ� ��� : 4�� ����
		MyTextBox.SetText( GetSystemMessage(6026) );
		
	if( bestScore==myScore && bestScore>=10 ) // ���� 1�� �϶� & ���� �ְ� ��� 10�� �̻�
		MsgTextBox.SetText( GetSystemString(5042) ); // [1���� �����մϴ�!]
	else
		MsgTextBox.SetText( "" );
}
defaultproperties
{
}
