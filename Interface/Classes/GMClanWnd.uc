class GMClanWnd extends ClanWnd;

var bool bShow;	// GMâ���� ��ư�� �ѹ� �� ������ ������� �ϱ� ���� ����

function OnRegisterEvent()
{
	RegisterEvent( EV_GMObservingClan );
	RegisterEvent( EV_GMObservingClanMemberStart );
	RegisterEvent( EV_GMObservingClanMember );
}

function Load()
{
	bShow = false;	//�ʱ�ȭ
	
	 m_WindowName="GMClanWnd";

	// �𽺿��̺�� ���ش�. 
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanMemInfoBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanMemAuthBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanBoardBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanInfoBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanPenaltyBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanQuitBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarInfoBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarDeclareBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarCancleBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanAskJoinBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanAuthEditBtn");
	class'UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanTitleManageBtn");
}

function OnShow()
{
}

function OnHide()
{
}

function ShowClan( String a_Param )
{
	if( a_Param == "" )
		return;

	if(bShow)	//â�� �������� �����ش�.
	{
		Clear();
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else
	{
		HandleGMObservingClan("");	//�⺻������ ��â�� ��쵵��
		class'GMAPI'.static.RequestGMCommand( GMCOMMAND_ClanInfo, a_Param );
		bShow = true;
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	case EV_GMObservingClan:
		HandleGMObservingClan( a_Param );
		break;
	case EV_GMObservingClanMemberStart:
		HandleGMObservingClanMemberStart();
		break;
	case EV_GMObservingClanMember:
		HandleGMObservingClanMember( a_Param );
		break;
	}
}

function HandleGMObservingClan( String a_Param )
{
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	Clear();
	HandleClanInfo( a_Param );
}

function HandleGMObservingClanMemberStart()
{	
}

function HandleGMObservingClanMember( String a_Param )
{
	HandleAddClanMember( a_Param );
}

defaultproperties
{
   
}
