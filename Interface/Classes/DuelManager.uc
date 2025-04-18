

class DuelManager extends UICommonAPI;

const DIALOG_ASK_START = 1111;

const MAX_PARTY_NUM = 9;

const NDUELSTATUS_HEIGHT = 46;	//��� ����â�� ���α���.

var int					m_memberInfo[MAX_PARTY_NUM];		// �� ��Ƽ â�� ǥ�õǰ� �ִ� �÷��̾��� ���� ID�� ������ �ִ�. 0�̸� ������� �ʴ� ��Ƽ â.

// ������ �ڵ�
var WindowHandle		m_TopWnd;
var WindowHandle		m_StatusWnd[MAX_PARTY_NUM];
var NameCtrlHandle		m_PlayerName[MAX_PARTY_NUM];
var TextureHandle		m_ClassIcon[MAX_PARTY_NUM];
var BarHandle			m_BarCP[MAX_PARTY_NUM];
var BarHandle			m_BarHP[MAX_PARTY_NUM];
var BarHandle			m_BarMP[MAX_PARTY_NUM];

var bool				m_bDuelState;


function OnRegisterEvent()
{
	// �̺�Ʈ (���� Ȥ�� Ŭ���̾�Ʈ���� ����) �ڵ� ���.
	registerEvent(EV_DuelAskStart);
	registerEvent(EV_DuelReady);
	registerEvent(EV_DuelStart);
	registerEvent(EV_DuelEnd);
	registerEvent(EV_DuelUpdateUserInfo);
	registerEvent(EV_DuelEnemyRelation);
	registerEvent(EV_DialogOK);
	registerEvent(EV_DialogCancel);
	registerEvent(EV_OlympiadUserInfo);
	RegisterEvent( EV_OlympiadMatchEnd );
}


// ������ ������ �ε�Ǵ� �Լ�
function OnLoad()
{
	local int idx;

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		//Init Handle ���� �̺�Ʈ �ڵ� �ʱ�ȭ.
		m_TopWnd = GetHandle("DuelManager");
		
		for (idx=0; idx<MAX_PARTY_NUM; idx++)
		{
			m_StatusWnd[idx] = GetHandle("DuelManager.PartyStatusWnd" $ idx);
			m_PlayerName[idx] = NameCtrlHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".PlayerName" ) ); 
			m_ClassIcon[idx] = TextureHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".ClassIcon" ) );
			m_BarCP[idx] = BarHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barCP" ) );
			m_BarHP[idx] = BarHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barHP" ) );
			m_BarMP[idx] = BarHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barMP" ) );
		}
	}
	else
	{
		//Init Handle ���� �̺�Ʈ �ڵ� �ʱ�ȭ.
		m_TopWnd = GetWindowHandle("DuelManager");
		
		for (idx=0; idx<MAX_PARTY_NUM; idx++)
		{
			m_StatusWnd[idx] = GetWindowHandle("DuelManager.PartyStatusWnd" $ idx);
			m_PlayerName[idx] = GetNameCtrlHandle( "DuelManager.PartyStatusWnd" $ idx $ ".PlayerName" ); 
			m_ClassIcon[idx] = GetTextureHandle( "DuelManager.PartyStatusWnd" $ idx $ ".ClassIcon" );
			m_BarCP[idx] = GetBarHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barCP" );
			m_BarHP[idx] = GetBarHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barHP" );
			m_BarMP[idx] = GetBarHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barMP" );
		}
	}

	Clear();
	m_bDuelState = false;
}

//�̺�Ʈ ó�� �ڵ�
function OnEvent(int EventID, string param)
{
	local Color white;
	white.R = 255;
	white.G = 255;
	white.B = 255;

	//debug( "DuelManager event " $ EventID $ ", param " $ param );
	switch( EventID )
	{
	case EV_DuelAskStart:
		//debug("DuelAskStart");
		HandleDuelAskStart(param);
		break;
	case EV_DuelReady:
		//debug("DuelReady");
		m_bDuelState = true;
		break;
	case EV_DuelStart:
		//debug("DuelStart");
		break;
	case EV_DuelEnd:
		//debug("DuelEnd");
		m_bDuelState = false;
		Clear();
		m_TopWnd.HideWindow();
		break;
	case EV_DuelUpdateUserInfo:
		HandleUpdateUserInfo( param );
		break;
	case EV_DuelEnemyRelation:
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	case EV_DialogCancel:
		//debug("rejected");
		HandleDialogCancel();
		break;
	case EV_OlympiadUserInfo:
		HandleOlympiadUserInfo( param );
		break;
	case EV_OlympiadMatchEnd:
		HandleOlympiadEnd();
		break;
	default:
		break;
	};
}

//����� ��û 
function HandleDuelAskStart( string param )
{
	local string	sName;
	local int		type, messageNum;
	local bool bOption;

	bOption = GetOptionBool( "Game", "IsRejectingDuel" );
	
	ParseString( param, "userName", sName );
	ParseInt( param, "type", type );

	if (bOption == true)
	{
		// �ɼǿ��� �ź� ���¸� üũ �س����� -1�� ������
		RequestDuelAnswerStart( type, int(bOption), -1 );		
	}
	else	
	{
		// ���̾�α׿� �޼����� �����ϰ�, �����ش�.
		if( type == 0 )			// ���� ����
			messageNum = 1938;
		else if( type == 1 )		// ��Ƽ ����
			messageNum = 1939;
	
		DialogSetReservedInt( type );
		DialogSetParamInt64( IntToInt64(10*1000) );	
		DialogSetID(DIALOG_ASK_START);
		DialogShow(DIALOG_Modalless, DIALOG_Progress, MakeFullSystemMsg( GetSystemMessage(messageNum), sName ) );
	}
}

function HandleOlympiadUserInfo(string Param)
{
	local int i;
	local int playNum;

	local int IsPlayer;
	local int PlayerID;
	local int m_ClassID;
	local string m_Name;
	local int m_MaxHP;
	local int m_CurHP;
	local int m_MaxCP;
	local int m_CurCP;
	
	local string FakeEventParam;
	
	ParseInt(Param, "TotalCount", playNum); //�÷��̾� ����
	
	//~ �÷��̾��� �ο��� 0 �̻��̸� �ø��ǾƵ� �ٴ�ٷ� �����ϰ� UI ���� 
	
	if (playNum > 0 )
	{
		for(i = 0; i < playNum; i++)

		{
			ParseInt(Param, "PlayerNum_" $ string (i) , IsPlayer);  //���� �÷��̾��� ������ 1�� 2��
			ParseInt(Param, "ID_" $ string (i), PlayerID);
			ParseString(Param, "Name_" $ string (i), m_Name);
			ParseInt(Param, "ClassID_" $ string (i), m_ClassID);
			ParseInt(Param, "MaxHP_" $ string (i), m_MaxHP);
			ParseInt(Param, "CurHP_" $ string (i), m_CurHP);
			ParseInt(Param, "MaxCP_" $ string (i), m_MaxCP);
			ParseInt(Param, "CurCP_" $ string (i), m_CurCP);
		
			if (IsPlayer == 0)
			{
				FakeEventParam = "";
				ParamAdd (FakeEventParam, "userName", "m_Name");
				ParamAdd (FakeEventParam, "ID", string(PlayerID) );
				ParamAdd (FakeEventParam, "class", string(m_ClassID) );
				ParamAdd (FakeEventParam, "level", string(75) );
				ParamAdd (FakeEventParam, "currentHP", string( m_CurHP) );
				ParamAdd (FakeEventParam, "maxHP", string(m_MaxHP) );
				ParamAdd (FakeEventParam, "currentMP", string(0) );
				ParamAdd (FakeEventParam, "maxMP", string(0) );
				ParamAdd (FakeEventParam, "currentCP", string(m_CurCP) );
				ParamAdd (FakeEventParam, "maxCP", string(m_MaxCP) );
				
				ExecuteEvent(EV_DuelUpdateUserInfo, FakeEventParam);
			}
			
			
			
		}
	}
	
}

function HandleOlympiadEnd()
{
	ExecuteEvent(EV_DuelEnd);
}

function HandleDialogOK()
{
	local int dialogID;
	local bool bOption;
	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		if( dialogID == DIALOG_ASK_START )
		{
			bOption = GetOptionBool( "Game", "IsRejectingDuel" );
			RequestDuelAnswerStart( DialogGetReservedInt(), int(bOption), 1 );
		}
	}
}

function HandleDialogCancel()
{
	local int dialogID;
	local bool bOption;
	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		if( dialogID == DIALOG_ASK_START )
		{
			bOption = GetOptionBool( "Game", "IsRejectingDuel" );
			RequestDuelAnswerStart( DialogGetReservedInt(), int(bOption), 0 );
		}
	}
}



function HandleUpdateUserInfo( string param )
{
	local string sName;
	local int ID, classID, level, currentHP, maxHP, currentMP, maxMP, currentCP, maxCP;
	local int i;
	local bool bFound;

	if( !m_bDuelState )
		return;

	ParseString( param, "userName", sName );
	ParseInt( param, "ID", ID );
	ParseInt( param, "class", classID );
	ParseInt( param, "level", level );
	ParseInt( param, "currentHP", currentHP );
	ParseInt( param, "maxHP", maxHP );
	ParseInt( param, "currentMP", currentMP );
	ParseInt( param, "maxMP", maxMP );
	ParseInt( param, "currentCP", currentCP );
	ParseInt( param, "maxCP", maxCP );

	// ������ ID �� ��Ƽâ�� �˻��Ѵ�.
	bFound = false;
	for( i=0; i < MAX_PARTY_NUM ; ++i )
	{
		if( m_memberInfo[i] != 0  )
		{
			if( ID == m_memberInfo[i] )
			{
				bFound = true;
				break;
			}
		}
		else 
		{
			break;
		}
	}

	// i �� ������ ������Ʈ �� �ε����� ����Ų��.( i�� MAX_PARTY_NUM ���� �۾ƾ��Ѵ�. �ƴϸ� ����;;; )
	if( !bFound )			// ���ο� ����̴�
	{
		//debug( "match not found(i:" $ i );
		m_memberInfo[i] = ID;
		m_StatusWnd[i].ShowWindow();
		Resize(i+1);
	}

	m_TopWnd.ShowWindow();

	//Name
	m_PlayerName[i].SetName(sName, NCT_Normal,TA_Center);

	//���� ������
	m_ClassIcon[i].SetTexture(GetClassIconName(classID));
	m_ClassIcon[i].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(classID) $ " - " $ GetClassType(classID)));

	m_BarCP[i].SetValue( maxCP, currentCP );
	m_BarHP[i].SetValue( maxHP, currentHP );
	m_BarMP[i].SetValue( maxMP, currentMP );
}

//�ʱ�ȭ
function Clear()
{
	local int i;

	for( i=0 ; i < MAX_PARTY_NUM ; ++i )
	{
		m_StatusWnd[i].HideWindow();
		m_memberInfo[i] = 0;
	}
}

// ���� ���̰� �ִ� â�� ������ �µ��� frame ���� ����� �����Ѵ�( count�� â�� ī��Ʈ )
function Resize( int count )
{
	local Rect entireRect, statusWndRect;
	entireRect = m_TopWnd.GetRect();
	statusWndRect = m_StatusWnd[0].GetRect();

	m_TopWnd.SetWindowSize( entireRect.nWidth, statusWndRect.nHeight*count );
	m_TopWnd.SetResizeFrameSize( 10, statusWndRect.nHeight*count );
}

//���콺 ���ʹ�ư���� Ÿ����
function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local int idx;
	
	rectWnd = m_TopWnd.GetRect();
	
	if (X > rectWnd.nX + 13 )
	{
		//debug ("abcde" $ X $ rectWnd.nX $idx);
		idx = (Y-rectWnd.nY) / NDUELSTATUS_HEIGHT;
		RequestTargetUser(m_memberInfo[idx]);
	}
}
defaultproperties
{
}
