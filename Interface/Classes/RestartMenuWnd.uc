class RestartMenuWnd extends UICommonAPI;

var bool m_bShow;
var bool m_bRestartON;

var bool m_bVillage;
var bool m_bAgit;
var bool m_bCastle;
var bool m_bBattleCamp;
var bool m_bOriginal;
var bool m_bFotress;
//branch
const MAX_NPC = 8;

var bool m_bAgathion; // �ư��ÿ� ��Ȱ ���� ����
var int m_iNpc[MAX_NPC]; // ��ȯ ������ NPC ������ ID (����� �ִ� 8�������� �����ְ� �� �̻� ���� ���� ������)
var int m_iCurNpc; // NPC ������ ID�� ����� �Դ��� ǥ��
var int m_iTotal; // �������� �� ��ư�� ����
var int m_iShowBtn; // ��ġ�� ���° ��ư������ ǥ��
//end of branch

//Handle List
var WindowHandle	m_wndTop;
var ButtonHandle	m_btnVillage;
var ButtonHandle	m_btnAgit;
var ButtonHandle	m_btnCastle;
var ButtonHandle	m_btnBattleCamp;
var ButtonHandle	m_btnOriginal;
var ButtonHandle	m_btnFortress;
//branch
var ButtonHandle	m_btnAgathion;
var ButtonHandle	m_btnNpc[MAX_NPC];
//end of branch;

function OnRegisterEvent()
{
	RegisterEvent( EV_Die );
	RegisterEvent( EV_Restart );
	RegisterEvent( EV_RestartMenuShow );
	RegisterEvent( EV_RestartMenuHide );
	//branch
	RegisterEvent( EV_BR_Die_EnableNPC );

	// TTP #42287 NPC �ڰ� ��Ȱ ������ ��ư�� Disable �ؾ� �� ���� �ֽ��ϴ�. - gorillazin 10.10.15.
	RegisterEvent( EV_BR_RestartByNPCButtonEnable );
	//

	//end of branch
}

function OnLoad()
{
	//branch 	
	local int i;
	//end of branch
	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		//Init Handle
		m_wndTop = GetHandle( "RestartMenuWnd" );
		m_btnVillage = ButtonHandle ( GetHandle( "RestartMenuWnd.btnVillage" ) );
		m_btnAgit = ButtonHandle ( GetHandle( "RestartMenuWnd.btnAgit" ) );
		m_btnCastle = ButtonHandle ( GetHandle( "RestartMenuWnd.btnCastle" ) );
		m_btnBattleCamp = ButtonHandle ( GetHandle( "RestartMenuWnd.btnBattleCamp" ) );
		m_btnOriginal = ButtonHandle ( GetHandle( "RestartMenuWnd.BtnUnPenalty" ) );
		m_btnFortress = ButtonHandle ( GetHandle( "RestartMenuWnd.btnFortress" ) );
		//branch
		m_btnAgathion = ButtonHandle ( GetHandle( "RestartMenuWnd.btnAgathion" ) );
		for( i = 0; i < MAX_NPC; ++i )
		{
			m_btnNpc[ i ] = ButtonHandle( GetHandle( "RestartMenuWnd.btnNpc1" $ i + 1 ) );
		}
		//end of branch
	}
	else
	{
		//Init Handle
		m_wndTop = GetWindowHandle( "RestartMenuWnd" );
		m_btnVillage = GetButtonHandle( "RestartMenuWnd.btnVillage" );
		m_btnAgit = GetButtonHandle( "RestartMenuWnd.btnAgit" );
		m_btnCastle = GetButtonHandle( "RestartMenuWnd.btnCastle" );
		m_btnBattleCamp = GetButtonHandle( "RestartMenuWnd.btnBattleCamp" );
		m_btnOriginal = GetButtonHandle( "RestartMenuWnd.BtnUnPenalty" );
		m_btnFortress = GetButtonHandle( "RestartMenuWnd.btnFortress" );
		//branch
		m_btnAgathion = GetButtonHandle( "RestartMenuWnd.btnAgathion" );
		for( i = 0; i < MAX_NPC; ++i )
		{
			m_btnNpc[ i ] = GetButtonHandle( "RestartMenuWnd.btnNpc" $ i + 1 );
		}			
		//end of branch
	}

	m_bShow = false;
	m_bRestartON = false;
	m_iCurNpc = -1;
}

function OnShow()
{
	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
//branch
	// TTP #42436 ��Ȱ â�� hide �Ǿ��ٰ� �ٽ� ������ �� m_ishowBtn�� �ʱ�ȭ ���� ������ �ֻ��� ���� ��ư���� �� ĭ �� �з��� ǥ�õǰ� �˴ϴ�. - gorillazin 10.11.04.
	m_ishowBtn = 0;
//end of branch
}

function OnEnterState( name a_PreStateName )
{
	if (m_bRestartON)
	{
		ShowMe();
	}
	else
	{
		HideMe();
	}
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_Die)
	{
		HandleDie(param);
	}
	else if (Event_ID == EV_Restart)
	{
		HandleRestart();
	}
	else if (Event_ID == EV_RestartMenuShow)
	{
		HandleRestartMenuShow();
	}
	else if (Event_ID == EV_RestartMenuHide)
	{
		HandleRestartMenuHide();
	}
	//branch	
	else if (Event_ID == EV_BR_Die_EnableNPC)
	{
		HandleDieEnableNPC(param);		
	}

	// TTP #42287 NPC �ڰ� ��Ȱ ������ ��ư�� Disable �ؾ� �� ���� �ֽ��ϴ�. - gorillazin 10.10.15.
	else if (Event_ID == EV_BR_RestartByNPCButtonEnable)
	{
		HandleRestartByNPCButtonEnable(param);
	}
	//

	//end of branch
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnVillage":
		OnVillageClick();
		break;
	case "btnAgit":
		OnAgitClick();
		break;
	case "btnCastle":
		OnCastleClick();
		break;
	case "btnBattleCamp":
		OnBattleCampClick();
		break;
	case "BtnUnPenalty":
		OnOriginalClick();
		break;
	case "btnFortress":
		OnFortressClick();
		break;
	//branch
	case "btnAgathion":
		OnAgathionClick();
		break;
	case "btnNpc1":
		OnNpcClick(0);
		break;
	case "btnNpc2":
		OnNpcClick(1);
		break;
	case "btnNpc3":
		OnNpcClick(2);
		break;
	case "btnNpc4":
		OnNpcClick(3);
		break;
	case "btnNpc5":
		OnNpcClick(4);
		break;
	case "btnNpc6":
		OnNpcClick(5);
		break;
	case "btnNpc7":
		OnNpcClick(6);
		break;
	case "btnNpc8":
		OnNpcClick(7);
		break;
	//end of branch
	}
}

//��ư Ŭ�� ó��
function OnVillageClick()
{
	RequestRestartPoint(RPT_VILLAGE);
	HideMe();
	
}
function OnAgitClick()
{
	RequestRestartPoint(RPT_AGIT);
	HideMe();
}
function OnCastleClick()
{
	RequestRestartPoint(RPT_CASTLE);
	HideMe();
}
function OnBattleCampClick()
{
	RequestRestartPoint(RPT_BATTLE_CAMP);
	HideMe();
}
function OnOriginalClick()
{
	RequestRestartPoint(RPT_ORIGINAL_PLACE);
	HideMe();
}
function OnFortressClick()
{
	RequestRestartPoint(RPT_FORTRESS);
	HideMe();
}
//branch
function OnAgathionClick()
{
	BR_RequestRestartPoint(RPT_AGATHION);
	HideMe();
}
function OnNpcClick(int num)
{
	BR_RequestRestartPoint(RPT_NPC, m_iNpc[num]);
	HideMe();
}
//end of branch

//����ŸƮ ����Ʈ�� �޾�����
function HandleDie(string param)
{	
	local int Village;
	local int Agit;
	local int Castle;
	local int BattleCamp;
	local int Original;
	local int Fortress;
	
	//branch
	local int Agathion;
	//end of branch	
	
	ParseInt(param, "Village" ,Village);
	ParseInt(param, "Agit" ,Agit);
	ParseInt(param, "Castle" ,Castle);
	ParseInt(param, "BattleCamp" ,BattleCamp);
	ParseInt(param, "Original" ,Original);
	ParseInt(param, "Fortress" ,Fortress);
	
	//branch	
	ParseInt(param, "Agathion" ,Agathion);
	
	debug ("------------------AGATHION " $Agathion);

	m_iTotal =  Village + Agit + Castle + BattleCamp + Original + Fortress + Agathion;
	//end of branch
	
	m_bVillage = false;
	m_bAgit = false;
	m_bCastle = false;
	m_bBattleCamp = false;
	m_bOriginal = false;
	m_bFotress = false;
	//branch
	m_bAgathion = false;	
	
	m_iCurNpc = -1; 
	m_ishowBtn = 0; 
	//end of brnach
	
	if (Village>0)
		m_bVillage = true;
	if (Agit>0)
		m_bAgit = true;
	if (Castle>0)
		m_bCastle = true;
	if (BattleCamp>0)
		m_bBattleCamp = true;
	if (Original>0)
		m_bOriginal = true;
	if (Fortress>0)
		m_bFotress = true;		
	//branch
	if (Agathion>0)
		m_bAgathion = true;	
    //end of branch
}

//branch
function HandleDieEnableNPC(string param)
{	
	local int NPC;
	local ItemID giftitem; 
	
	ParseInt(param, "Npc" ,NPC);
	
	debug ("-----------------------NPC " $NPC);
	
	if(m_iCurNpc==-1) // NPC = ��ȯ ������ NPC ����
	{
		m_iTotal =  m_iTotal + NPC;
		if(m_iTotal>6) // ��ư�� 6�������� ���� ũ��, �� �̻��̸� �ø�
		{
			m_wndTop.SetWindowSize(115,175+(26*(m_iTotal-6)));  // ������ ũ�� ����
			m_wndTop.SetAnchor( "", "CenterCenter", "", 0, 0 ); // ������ ��ġ ����
		}
		
		m_iNpc[0]=0; m_iNpc[1]=0; m_iNpc[2]=0; m_iNpc[3]=0; m_iNpc[4]=0; m_iNpc[5]=0; m_iNpc[6]=0; m_iNpc[7]=0;
	}	
	else if(m_iCurNpc>=0 && m_iCurNpc<MAX_NPC) // NPC = NPC ��ȯ ������ ID
	{
		m_iNpc[m_iCurNpc]=NPC;
		
		if(m_iNpc[m_iCurNpc]>0)
		{
			giftitem.ClassID = m_iNpc[m_iCurNpc]; 
			m_btnNpc[m_iCurNpc].SetNameText(class'UIDATA_ITEM'.static.GetItemName(giftitem)); // �����۸��� ��ư������ ���� 
		}			
	}
	
	m_iCurNpc++;
}

function HandleRestartByNPCButtonEnable(string param)
{
	local int idx;
	local int isEnable;

	ParseInt(param, "IsEnable", isEnable);

	debug("dididididdie!!!! " $ isEnable);

	if (isEnable == 0)
	{
		for (idx = 0; idx < m_iCurNpc; ++idx)
		{
			m_btnNpc[idx].DisableWindow();
		}
	}
	else
	{
		for (idx = 0; idx < m_iCurNpc; ++idx)
		{
			m_btnNpc[idx].EnableWindow();
		}
	}
}

//end of branch

function HandleRestartMenuShow()
{
	ShowMe();
}

function HandleRestartMenuHide()
{
	HideMe();
}

function HandleRestart()
{
	HideMe();
}

function ShowMe()
{
	//branch
	local int i;
	//end of branch
	
	if (!m_bVillage && !m_bAgit && !m_bCastle && !m_bBattleCamp && !m_bOriginal && !m_bFotress)
	{
	}
	else
	{
		m_bRestartON = true;
		m_wndTop.ShowWindow();
		
		if (m_bVillage)
		{
			m_btnVillage.SetAnchor( "RestartMenuWnd", "TopLeft", "TopLeft", 9, 8 ); m_ishowBtn++; //branch	
			m_btnVillage.ShowWindow();				
		}
		else
			m_btnVillage.HideWindow();
		
		if (m_bAgit)
		{
			m_btnAgit.SetAnchor( "RestartMenuWnd", "TopLeft", "TopLeft", 9, 8+(26*m_ishowBtn) ); m_ishowBtn++; //branch	
			m_btnAgit.ShowWindow();				
		}
		else
			m_btnAgit.HideWindow();
			
		if (m_bCastle)
		{
			m_btnCastle.SetAnchor( "RestartMenuWnd", "TopLeft", "TopLeft", 9, 8+(26*m_ishowBtn) ); m_ishowBtn++; //branch		
			m_btnCastle.ShowWindow();				
		}
		else
			m_btnCastle.HideWindow();
			
		if (m_bBattleCamp)
		{
			m_btnBattleCamp.SetAnchor( "RestartMenuWnd", "TopLeft", "TopLeft", 9, 8+(26*m_ishowBtn) ); m_ishowBtn++; //branch		
			m_btnBattleCamp.ShowWindow();			
		}
		else
			m_btnBattleCamp.HideWindow();
			
		if (m_bFotress)
		{
			m_btnFortress.SetAnchor( "RestartMenuWnd", "TopLeft", "TopLeft", 9, 8+(26*m_ishowBtn) ); m_ishowBtn++; //branch	
			m_btnFortress.ShowWindow();				
		}
		else
			m_btnFortress.HideWindow();
			
		if (m_bOriginal) //branch - ��ġ ����, m_bFotress���� �Ʒ� �ʿ� ��ư�� ���;� �ϹǷ� if���� m_bFotress���� ���߿� ó���Ǿ�� �մϴ�.
		{
			m_btnOriginal.SetAnchor( "RestartMenuWnd", "TopLeft", "TopLeft", 9, 8+(26*m_ishowBtn) ); m_ishowBtn++; //branch	
			m_btnOriginal.ShowWindow();				
		}
		else
			m_btnOriginal.HideWindow();
			
		//branch			
		if (m_bAgathion) // �ư��ÿ� ��Ȱ
		{
			m_btnAgathion.SetAnchor( "RestartMenuWnd", "TopLeft", "TopLeft", 9, 8+(26*m_ishowBtn) ); m_ishowBtn++; 
			m_btnAgathion.ShowWindow();					
		}			
		else
			m_btnAgathion.HideWindow();
			
		for(i=0; i<MAX_NPC; i++) // NPC ��ȯ ��Ȱ
		{
			if (m_iNpc[i]>0)
			{
				m_btnNpc[i].SetAnchor( "RestartMenuWnd", "TopLeft", "TopLeft", 9, 8+(26*m_ishowBtn) ); m_ishowBtn++;
				m_btnNpc[i].ShowWindow();		
			}
			else
				m_btnNpc[i].HideWindow();
		}
		//end of branch
		
		m_wndTop.SetFocus();
	}
	
}

function HideMe()
{
	m_bRestartON = false;
	m_wndTop.HideWindow();
}
defaultproperties
{
}
