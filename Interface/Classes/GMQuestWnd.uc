class GMQuestWnd extends QuestTreeWnd;

var bool bShow;	// GMâ���� ��ư�� �ѹ� �� ������ ������� �ϱ� ���� ����

function OnRegisterEvent()
{
	RegisterEvent( EV_GMObservingQuestListStart );
	RegisterEvent( EV_GMObservingQuestList );
	RegisterEvent( EV_GMObservingQuestListEnd );
	RegisterEvent( EV_GMObservingQuestItem );
}

function OnLoad()
{
	 m_WindowName="GMQuestWnd";
	super.OnLoad();
	bShow = false;	//�ʱ�ȭ
}

function OnShow()
{
	super.OnShow();
//	class'UIAPI_WINDOW'.static.HideWindow( m_WindowName$".btnClose" );
	checkNpcPosBox.HideWindow();
}	

function ShowQuest( String a_Param )
{
	if( a_Param == "" )
		return;

	if(bShow)	//â�� �������� �����ش�.
	{
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else
	{
		class'GMAPI'.static.RequestGMCommand( GMCOMMAND_QuestInfo, a_Param );
		bShow = true;
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_GMObservingQuestListStart:
		HandleGMObservingQuestListStart();
		break;
	case EV_GMObservingQuestList:
		HandleGMObservingQuestList( a_Param );
		break;
	case EV_GMObservingQuestListEnd:
		HandleGMObservingQuestListEnd();
		break;
	case EV_GMObservingQuestItem:
		HandleGMObservingQuestItem( a_Param );
		break;
	}
}

function HandleGMObservingQuestListStart()
{
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	HandleQuestListStart();
}

function HandleGMObservingQuestList( String a_Param )
{
	HandleQuestList( a_Param );
}

function HandleGMObservingQuestListEnd()
{
	UpdateQuestCount();
	UpdateItemCount( 0, IntToInt64(-1) );
}

function HandleGMObservingQuestItem( String a_Param )
{
	local int ClassID;
	local INT64 ItemCount;

	ParseInt( a_Param, "ClassID", ClassID );
	ParseINT64( a_Param, "ItemCount", ItemCount );

	UpdateItemCount( ClassID, ItemCount );
}

defaultproperties
{
   
}
