
class PartyWndCompact extends UICommonAPI;
	
struct VnameData
{
	var int ID;
	var int UseVName;
	var int DominionIDForVName;
	var string VName;
	var string SummonVName;
};


// ��� ����.
const NSTATUSICON_MAXCOL = 12;		//status icon�� �ִ� ����.
const NPARTYSTATUS_HEIGHT = 26;		//status ����â�� ���α���.	// Ȯ��â�� 46
const NPARTYPETSTATUS_HEIGHT = 18;		//status ����â�� ���α���.	// Ȯ��â�� 32
const NPARTYSTATUS_MAXCOUNT = 9;		//�� ��Ƽâ�� ���� �ִ� �ִ� ��Ƽ���� ��.
const FIRSTWND_ADD_HEIGHT = 4;		//ù��°â�� �߰������� �÷��� ����

var bool	m_bCompact;
var bool	m_bBuff;
var bool	m_partyleader;
var int	m_arrID[NPARTYSTATUS_MAXCOUNT];	// �ε����� �ش��ϴ� ��Ƽ���� ���� ID.
var int	m_arrPetID[NPARTYSTATUS_MAXCOUNT];	// �ε����� �ش��ϴ� ��Ƽ���� ���Ǽ��� ID.
var int	m_arrPetIDOpen[NPARTYSTATUS_MAXCOUNT];	// �ε����� �ش��ϴ� ��Ƽ���� ���� â�� �����ִ��� Ȯ��. 1�̸� ����, 2�̸� ����. -1�̸� ����
var int	m_CurCount;
var int 	m_CurBf;
var int m_MasterID;

var VnameData m_Vname[8];

//Handle	����
var WindowHandle	m_wndTop;			// ���� ������
var WindowHandle	m_PartyOption;		// �ɼ� ������
var WindowHandle	m_PartyStatus[NPARTYSTATUS_MAXCOUNT];	// ĳ���ͺ� ������ (ĳ���� ����ŭ �������ش�)
//var NameCtrlHandle		m_PlayerName[NPARTYSTATUS_MAXCOUNT];
var TextureHandle	m_ClassIcon[NPARTYSTATUS_MAXCOUNT];		//Ŭ���� ������ �ؽ���.
var StatusIconHandle	m_StatusIconBuff[NPARTYSTATUS_MAXCOUNT];	//���������� �ڵ�
var StatusIconHandle	m_StatusIconDeBuff[NPARTYSTATUS_MAXCOUNT];	//����������� �ڵ�
var BarHandle		m_BarCP[NPARTYSTATUS_MAXCOUNT];
var BarHandle		m_BarHP[NPARTYSTATUS_MAXCOUNT];
var BarHandle		m_BarMP[NPARTYSTATUS_MAXCOUNT];
var ButtonHandle	btnBuff;

var ButtonHandle			m_petButton[NPARTYSTATUS_MAXCOUNT];
var ButtonHandle			m_petButtonTrash[NPARTYSTATUS_MAXCOUNT];

var WindowHandle		m_PetPartyStatus[NPARTYSTATUS_MAXCOUNT];
//var NameCtrlHandle		m_PetName[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconBuff[NPARTYSTATUS_MAXCOUNT];
var StatusIconHandle		m_PetStatusIconDeBuff[NPARTYSTATUS_MAXCOUNT];
var TextureHandle		m_PetClassIcon[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_PetBarHP[NPARTYSTATUS_MAXCOUNT];
var BarHandle			m_PetBarMP[NPARTYSTATUS_MAXCOUNT];

function OnRegisterEvent()
{
	// �̺�Ʈ (���� Ȥ�� Ŭ���̾�Ʈ���� ����) �ڵ� ���.
	RegisterEvent( EV_ShowBuffIcon );
	
	RegisterEvent( EV_PartyAddParty);
	RegisterEvent( EV_PartyUpdateParty );
	RegisterEvent( EV_PartyDeleteParty );
	RegisterEvent( EV_PartyDeleteAllParty );
	RegisterEvent( EV_PartySpelledList );
	RegisterEvent( EV_PartyRenameMember );

	RegisterEvent( EV_PartySummonAdd );
	RegisterEvent( EV_PartySummonUpdate );
	RegisterEvent( EV_PartySummonDelete );
	
	RegisterEvent( EV_PetStatusSpelledList );		// �� ������ ������� �̺�Ʈ
	RegisterEvent( EV_SummonedStatusSpelledList );	// ��ȯ��  ������ ������� �̺�Ʈ
	
	RegisterEvent( EV_Restart );
}

// �����찡 �����ɶ� �Ҹ��� �Լ�.
function OnLoad()
{
	local int idx;

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();

	m_bCompact = false;
	m_bBuff = false;
	m_CurBf = 0;
	m_MasterID = 0;
	
	//Reset Anchor	// ������ ������� PartyWndCompact�� anchor point�� �����Ѵ�.
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		m_StatusIconBuff[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 1, 3);
		m_StatusIconDeBuff[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ idx, "TopRight", "TopLeft", 1, 3);
		m_PetStatusIconBuff[idx].SetAnchor("PartyWndCompact.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 3);
		m_PetStatusIconDeBuff[idx].SetAnchor("PartyWndCompact.PartyStatusSummonWnd" $ idx, "TopRight", "TopLeft", 1, 3);
	}
	
	//Set ClassIcon0 Position
	m_ClassIcon[0].Move(0, 7);
	
	
	m_PartyOption.HideWindow();
	
	//Init VirtualDrag
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		//m_PartyStatus[idx].SetVirtualDrag( true );
		m_PartyStatus[idx].SetDragOverTexture( "L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight" );
	}
	ResetVName();

}


function OnHide()
{
	ResetVName();

}


function InitHandle()
{
	local int idx;
	local Rect rectWnd;

	//Init Handle
	m_wndTop = GetHandle( "PartyWndCompact" );
	m_PartyOption = GetHandle("PartyWndOption");		// �ɼ�â�� �ڵ� �ʱ�ȭ.
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)		// �ִ���Ƽ�� �� ��ŭ �� �����͸� �ʱ�ȭ����.
	{
		m_PartyStatus[idx] = GetHandle( "PartyWndCompact.PartyStatusWnd" $ idx );
		//m_PlayerName[idx] = NameCtrlHandle( GetHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".PlayerName" ) ); 
		m_ClassIcon[idx] = TextureHandle( GetHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".ClassIcon" ) );
		m_StatusIconBuff[idx] = StatusIconHandle( GetHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".StatusIconBuff" ) );
		m_StatusIconDeBuff[idx] = StatusIconHandle( GetHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".StatusIconDebuff" ) );
		m_BarCP[idx] = BarHandle( GetHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".barCP" ) );
		m_BarHP[idx] = BarHandle( GetHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".barHP" ) );
		m_BarMP[idx] = BarHandle( GetHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".barMP" ) );
		
		m_petButton[idx] = ButtonHandle( GetHandle( "PartyWndCompact.btnSummon" $ idx) );	
		m_petButton[idx].HideWindow();
		
		m_PetPartyStatus[idx] = GetHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx );
		//m_PetName[idx] = NameCtrlHandle( GetHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".SummonName" ) ); 
		m_PetClassIcon[idx] = TextureHandle( GetHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".ClassIcon" ) );
		m_PetStatusIconBuff[idx] = StatusIconHandle( GetHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".StatusIconBuff" ) );
		m_PetStatusIconDeBuff[idx] = StatusIconHandle( GetHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".StatusIconDebuff" ) );
		m_PetBarHP[idx] = BarHandle( GetHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".barHP" ) );
		m_PetBarMP[idx] = BarHandle( GetHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".barMP" ) );		
				
		m_arrPetIDOpen[idx] = -1;
		m_arrID[idx] = 0;
		
		// ������ ���� �����һ�, ������ �ʴ´�. 
		//m_PlayerName[idx].HideWindow();
		//m_PetName[idx].HideWindow();
		
		if(idx == 0) //ù��° â�� ���̾ƿ��� �ٸ���. 
		{
			rectWnd = m_PartyStatus[idx].GetRect();
			m_PartyStatus[idx].SetWindowSize(rectWnd.nWidth, rectWnd.nHeight + FIRSTWND_ADD_HEIGHT);
			
			m_petButton[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 15);			
		}
		else
			m_petButton[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 2);
	}
	btnBuff = ButtonHandle( GetHandle( "PartyWndCompact.btnBuff" ) );
}

function InitHandleCOD()
{
	local int idx;
	local Rect rectWnd;

	//Init Handle
	m_wndTop = GetWindowHandle( "PartyWndCompact" );
	m_PartyOption = GetWindowHandle("PartyWndOption");		// �ɼ�â�� �ڵ� �ʱ�ȭ.
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)		// �ִ���Ƽ�� �� ��ŭ �� �����͸� �ʱ�ȭ����.
	{
		m_PartyStatus[idx] = GetWindowHandle( "PartyWndCompact.PartyStatusWnd" $ idx );
		m_ClassIcon[idx] = GetTextureHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".ClassIcon" );
		m_StatusIconBuff[idx] = GetStatusIconHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".StatusIconBuff" );
		m_StatusIconDeBuff[idx] = GetStatusIconHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".StatusIconDebuff" );
		m_BarCP[idx] = GetBarHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".barCP" );
		m_BarHP[idx] = GetBarHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".barHP" );
		m_BarMP[idx] = GetBarHandle( "PartyWndCompact.PartyStatusWnd" $ idx $ ".barMP" );
		
		m_petButton[idx] = GetButtonHandle( "PartyWndCompact.btnSummon" $ idx);	
		m_petButton[idx].HideWindow();
		
		m_PetPartyStatus[idx] = GetWindowHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx );

		m_PetClassIcon[idx] = GetTextureHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".ClassIcon" );
		m_PetStatusIconBuff[idx] = GetStatusIconHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".StatusIconBuff" );
		m_PetStatusIconDeBuff[idx] = GetStatusIconHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".StatusIconDebuff" );
		m_PetBarHP[idx] = GetBarHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".barHP" );
		m_PetBarMP[idx] = GetBarHandle( "PartyWndCompact.PartyStatusSummonWnd" $ idx $ ".barMP" );		
				
		m_arrPetIDOpen[idx] = -1;
		m_arrID[idx] = 0;
		
		if(idx == 0) //ù��° â�� ���̾ƿ��� �ٸ���. 
		{
			rectWnd = m_PartyStatus[idx].GetRect();
			m_PartyStatus[idx].SetWindowSize(rectWnd.nWidth, rectWnd.nHeight + FIRSTWND_ADD_HEIGHT);
			
			m_petButton[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 15);			
		}
		else
			m_petButton[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ idx, "TopLeft", "TopRight", 0, 2);
	}
	btnBuff = GetButtonHandle( "PartyWndCompact.btnBuff" );
}

function OnShow()
{
	SetBuffButtonTooltip();
}

function OnEnterState( name a_PreStateName )
{
	m_bCompact = false;
	m_bBuff = false;
	m_CurBf = 0;
	ResizeWnd();
}

// �̺�Ʈ �ڵ� ó��.
function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_PartyAddParty)	//��Ƽ���� �߰��ϴ� �̺�Ʈ.
	{
		HandlePartyAddParty(param);
	}
	else if (Event_ID == EV_PartyUpdateParty)	//��Ƽ ������Ʈ. ���� HP �� ���¸� ó���ϱ� ����.
	{
		HandlePartyUpdateParty(param);
	}
	else if (Event_ID == EV_PartyDeleteParty)	//��Ƽ�� ����.
	{
		HandlePartyDeleteParty(param);
	}
	else if (Event_ID == EV_PartyDeleteAllParty)	//��� ��Ƽ�� ����. ��Ƽ�� �����ų� �ǰ���.
	{
		HandlePartyDeleteAllParty();
	}
	else if (Event_ID == EV_PartySpelledList || Event_ID == EV_PetStatusSpelledList || Event_ID == EV_SummonedStatusSpelledList)	// ���� Ȥ�� ����� ó��.
	{
		HandlePartySpelledList(param);
	}
	else if (Event_ID == EV_ShowBuffIcon)		// ����, �����, ����/����� ���̱� ��带 ��ȯ.
	{
		HandleShowBuffIcon(param);
	}
	else if (Event_ID == EV_PartySummonAdd)	//��Ƽ���� ��ȯ���� ���
	{
		HandlePartySummonAdd(param);
	}
	else if (Event_ID == EV_PartySummonUpdate)	//��ȯ�� ������Ʈ HP�� �� �׷���..
	{
		HandlePartySummonUpdate(param);
	}
	else if (Event_ID == EV_PartySummonDelete)	//��ȯ ����
	{
		HandlePartySummonDelete(param);
	}
	else if (Event_ID == EV_Restart)
	{
		HandleRestart();
	}
	else if (Event_ID == EV_PartyRenameMember)
	{
		HandlePartyRenameMember(param);
	}
}

function HandlePartyRenameMember(string Param)
{
	local int idx;
	local int ID;
	local int UseVName;
	local int DominionIDForVName;
	local string VName;
	local string SummonVName;
	
	ParseInt(Param, "ID", ID);
	ParseInt(Param, "UseVName",UseVName);
	ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	ParseString(Param, "VName", VName);
	ParseString(Param, "SummonVName", SummonVName);
	
	idx = GetVNameIndexByID( ID );
	if( idx > -1 )
	{
		m_Vname[idx].ID = ID;
		m_Vname[idx].UseVName = UseVName;
		m_Vname[idx].DominionIDForVName = DominionIDForVName;
		m_Vname[idx].VName = VName;
		m_Vname[idx].SummonVName = SummonVName;
	}	
}


//����ŸƮ�� �ϸ� ��Ŭ����
function HandleRestart()
{
	Clear();
}

//�ʱ�ȭ
function Clear()
{
	local int idx;
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		ClearStatus(idx);
		ClearPetStatus(idx);
	}
	m_CurCount = 0;
	ResizeWnd();
}

//����â�� �ʱ�ȭ
function ClearStatus(int idx)
{
	m_StatusIconBuff[idx].Clear();
	m_StatusIconDeBuff[idx].Clear();
	//m_PlayerName[idx].SetName("", NCT_Normal,TA_Center);
	m_ClassIcon[idx].SetTexture("");
	UpdateCPBar(idx, 0, 0);
	UpdateHPBar(idx, 0, 0);
	UpdateMPBar(idx, 0, 0);
	m_arrID[idx] = 0;
}

// �� ����â�� �ʱ�ȭ
function ClearPetStatus(int idx)
{
	m_PetStatusIconBuff[idx].Clear();
	m_PetStatusIconDeBuff[idx].Clear();
	//m_PetName[idx].SetName("", NCT_Normal,TA_Center);
	m_PetClassIcon[idx].SetTexture("");
	UpdateHPBar(idx + 100, 0, 0);
	UpdateMPBar(idx + 100, 0, 0);
	
	m_petButton[idx].HideWindow();
	m_PetPartyStatus[idx].HideWindow();	// ��â ���ֱ�
	m_arrPetID[idx] = 0;
	m_arrPetIDOpen[idx] = -1;
}

//��Ƽâ�� ���� (������ �Ǵ� ��Ƽâ�� �ε���, ������ ��Ƽâ�� �ε���)
function CopyStatus(int DesIndex, int SrcIndex)
{
	local int		MaxValue;
	local int		CurValue;
	
	local int		Row;
	local int		Col;
	local int		MaxRow;
	local int		MaxCol;
	
	local StatusIconInfo info;
	
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
	local CustomTooltip TooltipInfo2;
	
	//ServerID
	m_arrID[DesIndex] = m_arrID[SrcIndex];
	
	//Name
	//m_PlayerName[DesIndex].SetName(m_PlayerName[SrcIndex].GetName(), NCT_Normal,TA_Center);
	
	//Window Tooltip
	m_PartyStatus[SrcIndex].GetTooltipCustomType(TooltipInfo);
	m_PartyStatus[DesIndex].SetTooltipCustomType(TooltipInfo);
	
	//Class Texture
	m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
	//Class Tooltip
	m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);	
	m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
	
	//CP,HP,MP
	m_BarCP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarCP[DesIndex].SetValue(MaxValue, CurValue);
	m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarHP[DesIndex].SetValue(MaxValue, CurValue);
	m_BarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarMP[DesIndex].SetValue(MaxValue, CurValue);
	
	//BuffStatus
	m_StatusIconBuff[DesIndex].Clear();
	MaxRow = m_StatusIconBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_StatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_StatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_StatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			m_StatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	// -------------------------------------------�굵 �Ű��ش�. 
	//ServerID
	m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];
	
	m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];	
	m_arrPetIDOpen[DesIndex] = m_arrPetIDOpen[SrcIndex];;	
	
	//Name
	//m_PetName[DesIndex].SetName(m_PetName[SrcIndex].GetName(), NCT_Normal,TA_Center);

	
	//Class Texture
	m_PetClassIcon[DesIndex].SetTexture(m_PetClassIcon[SrcIndex].GetTextureName());
	//Class Tooltip
	m_PetClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
	m_PetClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
	
	//CP,HP,MP
	m_PetBarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarHP[DesIndex].SetValue(MaxValue, CurValue);
	m_PetBarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarMP[DesIndex].SetValue(MaxValue, CurValue);
	
	//BuffStatus
	m_PetStatusIconBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconBuff[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconBuff[DesIndex].AddCol(Row, info);
		}
	}
	
	//DeBuffStatus
	m_PetStatusIconDeBuff[DesIndex].Clear();
	MaxRow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
	for (Row=0; Row<MaxRow; Row++)
	{
		m_PetStatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(Row);
		for (Col=0; Col<MaxCol; Col++)
		{
			m_PetStatusIconDeBuff[SrcIndex].GetItem(Row, Col, info);
			m_PetStatusIconDeBuff[DesIndex].AddCol(Row, info);
		}
	}
}

//�������� ������ ����
function ResizeWnd()
{
	local int idx;
	local Rect rectWnd;
	local bool bOption;
	local int i;
	local int OpenPetCount;
	
	// SetOptionBool�� ���. �� ������ PartyWndOption ���� �����
	bOption = GetOptionBool( "Game", "SmallPartyWnd" );
	
	if (m_CurCount>0)
	{
		OpenPetCount=0;
		for(i=0; i<NPARTYSTATUS_MAXCOUNT; i++)
		{
			if(m_arrPetIDOpen[i] == 1) OpenPetCount++;
			else 	// �����ִ� ���°� �ƴѵ�..
			{
				 if(m_PetPartyStatus[i].IsShowWindow()) m_PetPartyStatus[i].HideWindow();
			}
		}		
		
		//������ ������ ����
		rectWnd = m_wndTop.GetRect();
		
		m_wndTop.SetWindowSize(rectWnd.nWidth, NPARTYSTATUS_HEIGHT*m_CurCount  + OpenPetCount * NPARTYPETSTATUS_HEIGHT + FIRSTWND_ADD_HEIGHT);
		// ��â�� ������ ��ŭ ������ ������� �����ش�. 
		m_wndTop.SetResizeFrameSize(10, NPARTYSTATUS_HEIGHT*m_CurCount  + OpenPetCount * NPARTYPETSTATUS_HEIGHT + FIRSTWND_ADD_HEIGHT);
		if (bOption)	// �ɼ�â�� üũ�� �Ǿ������� ���� (Compact) �����츦 Ȱ��ȭ
			m_wndTop.ShowWindow();
		else
			m_wndTop.HideWindow();
				
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			if (idx<=m_CurCount-1)
			{
				if(idx >0 )	 //1 �̻��϶��� anchor�� ó�����ش�.
				{
					if(m_arrPetIDOpen[idx-1] == 1) // �� ��Ƽ���� ��ȯ���� �����ִٸ�
					{
						m_PartyStatus[idx].SetAnchor("PartyWndCompact.PartyStatusSummonWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// �� ������ ������ ��Ŀ
					}
					else// �� ��Ƽ���� ��ȯ���� �����ְų� ��ȯ���� ������
					{
						m_PartyStatus[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ idx-1, "BottomLeft", "TopLeft", 0, -4);	// ��Ƽ�� ������ ��Ŀ
					}
				}
				if(m_arrID[idx]!= 0 )
				{
					if (m_arrPetIDOpen[idx] > -1)  m_petButton[idx].showWindow();
					else	m_petButton[idx].HideWindow();
					m_PartyStatus[idx].SetVirtualDrag( true );
					m_PartyStatus[idx].ShowWindow();
				}
				if(m_arrPetIDOpen[idx] == 1) m_PetPartyStatus[idx].ShowWindow();
			}
			else
			{
				m_petButton[idx].HideWindow();
				m_PartyStatus[idx].SetVirtualDrag( false );
				m_PartyStatus[idx].HideWindow();
				m_PetPartyStatus[idx].HideWindow();
			}
		}
	}
	else	// ��Ƽ���� �������� ������ �� ������� ������ �ʴ´�.
	{
		m_wndTop.HideWindow();
		m_PetPartyStatus[idx].HideWindow();
	}
}

//ID�� ���° ǥ�õǴ� ��Ƽ������ ���Ѵ�
function int FindPartyID(int ID)
{
	local int idx;
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		if (m_arrID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ID�� ���° ǥ�õǴ� ������ ���Ѵ�
function int FindPetID(int ID)
{
	local int idx;
	for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
	{
		if (m_arrPetID[idx] == ID)
		{
			return idx;
		}
	}
	return -1;
}

//ADD	��Ƽ�� �߰�
function HandlePartyAddParty(string param)
{
	local int		ID;
	local int		SummonID;
	
	local int		UseVName;
	local int		DominionIDForVName;
	local string	VName;
	local string	SummonVName;
		
	ParseInt(param, "ID", ID);	// ID�� �Ľ��Ѵ�.
	ParseInt(param, "SummonID", SummonID);
	ParseInt(Param, "UseVName",UseVName);
	ParseInt(Param, "DominionIDForVName", DominionIDForVName);
	ParseString(Param, "VName", VName);
	ParseString(Param, "SummonVName", SummonVName);
	
	if (ID>0)
	{
		m_Vname[m_CurCount].ID = ID;
		m_Vname[m_CurCount].UseVName = UseVName;
		m_Vname[m_CurCount].DominionIDForVName = DominionIDForVName;
		m_Vname[m_CurCount].VName = VName;
		m_Vname[m_CurCount].SummonVName = SummonVName;
		
		m_CurCount++;
				
		m_arrID[m_CurCount-1] = ID;
		UpdateStatus(m_CurCount-1, param);
		
		if(SummonID > 0)	// ��ȯ���� ������ ��ȯ���� ������
		{
			m_arrPetID[m_CurCount-1] = SummonID;
			m_arrPetIDOpen[m_CurCount-1] = 1;
			UpdatePetStatus(m_CurCount-1, param $"SummonMasterID = "$ID );
			m_petButton[m_CurCount-1].showWindow();
			if( !m_PetPartyStatus[m_CurCount-1].isShowwindow())
			{
				m_PetPartyStatus[m_CurCount-1].ShowWindow();
			}
		}
		ResizeWnd();
	}
}

//UPDATE	Ư�� ��Ƽ�� ������Ʈ.
function HandlePartyUpdateParty(string param)
{
	local int	ID;
	local int	idx;
	
	ParseInt(param, "ID", ID);
	if (ID>0)
	{
		idx = FindPartyID(ID);
		UpdateStatus(idx, param);	// �ش� �ε����� ��Ƽ�� ������ ����
	}
}

//DELETE	Ư�� ��Ƽ���� ����.
function HandlePartyDeleteParty(string param)
{
	local int	ID;
	local int	idx;
	local int	i;
	
	ParseInt(param, "ID", ID);
	if (ID>0)
	{
		idx = FindPartyID(ID);
		if (idx>-1)
		{	
			for (i=idx; i<m_CurCount-1; i++)	// �����Ϸ��� ��Ƽ�� �Ʒ��� ��Ƽ������ �����ش�. 
			{
				CopyStatus(i, i+1);
			}
			ClearStatus(m_CurCount-1);
			ClearPetStatus(m_CurCount-1);
			m_CurCount--;
			ResizeWnd();	// ���� ��Ƽ���� �ڽŹۿ� ���ٸ� �˾Ƽ� ��Ƽ������� �����.
		}
	}
}

//DELETE ALL	���� ��� �����..
function HandlePartyDeleteAllParty()
{
	Clear();
}

//Set Info	Ư�� �ε����� ��Ƽ���� ���� ����. ���� ���̵� ������ Ȯ���� ���� �ʿ��ϴ�.
function UpdateStatus(int idx, string param)
{
	local string	Name;
	local int		ID;
	local int		CP;
	local int		MaxCP;
	local int		HP;
	local int		MaxHP;
	local int		MP;
	local int		MaxMP;
	local int		ClassID;
	local int		MasterID;
	local UserInfo 	TargetUser;
	
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
	local CustomTooltip TooltipInfo2;
	
	local int UseVName;
	local int DominionIDForVName;
	local string VName;
	local string SummonVName;
		
	if (idx<0 || idx>=NPARTYSTATUS_MAXCOUNT)
		return;
	
	ParseString(param, "Name", Name);
	ParseInt(param, "ID", ID);
	GetUserInfo(ID, TargetUser);
	ParseInt(param, "CurCP", CP);
	ParseInt(param, "MaxCP", MaxCP);
	ParseInt(param, "CurHP", HP);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "CurMP", MP);
	ParseInt(param, "MaxMP", MaxMP);
	ParseInt(param, "ClassID", ClassID);
		
	UseVName = m_Vname[idx].UseVName;
	DominionIDForVName = m_Vname[idx].DominionIDForVName;
	VName = m_Vname[idx].VName;
	SummonVName = m_Vname[idx].SummonVName;
	
	//������Ʈ�ϰ�쿡�� ��Ƽ�� ������ �ȳ���´�.
	if (ParseInt(param, "MasterID", MasterID))
		m_MasterID = MasterID;
	
	//Window Tooltip
	TooltipInfo.DrawList.length = 1;
	TooltipInfo.DrawList[0].eType = DIT_TEXT;
	TooltipInfo.DrawList[0].t_bDrawOneLine = true;
	if (m_MasterID >0 && m_MasterID==ID)
	{	
		if (TargetUser.WantHideName && TargetUser.RealName != "")
		{
			TooltipInfo.DrawList[0].t_strText =  TargetUser.Name $ "(" $ GetSystemString(408) $ ")";
		}
		else
		{
			TooltipInfo.DrawList[0].t_strText =  Name $ "(" $ GetSystemString(408) $ ")";
		}
	}
	else
	{
		if (UseVName == 1)
		{
			TooltipInfo.DrawList[0].t_strText = VName;
		}
		else
		{
			TooltipInfo.DrawList[0].t_strText = Name;
		}
	}
	m_PartyStatus[idx].SetTooltipCustomType(TooltipInfo);
	
	//���� ������
	m_ClassIcon[idx].SetTexture(GetClassIconName(ClassID));
	
	//Custom Tooltip
	TooltipInfo2.DrawList.length = 2;
	TooltipInfo2.DrawList[0].eType = DIT_TEXT;
	TooltipInfo2.DrawList[0].t_bDrawOneLine = true;
	if (m_MasterID >0 && m_MasterID==ID)
	{	
		if (TargetUser.WantHideName && TargetUser.RealName != "")
			TooltipInfo2.DrawList[0].t_strText =  TargetUser.Name $ "(" $ GetSystemString(408) $ ")";
		else
			TooltipInfo2.DrawList[0].t_strText =  Name $ "(" $ GetSystemString(408) $ ")";
	}
	else
	{
		if (TargetUser.WantHideName && TargetUser.RealName != "")
			TooltipInfo2.DrawList[0].t_strText = TargetUser.Name;
		else
			TooltipInfo2.DrawList[0].t_strText = Name;
	}
	
	TooltipInfo2.DrawList[1].eType = DIT_TEXT;
	TooltipInfo2.DrawList[1].nOffSetY = 2;
	TooltipInfo2.DrawList[1].t_bDrawOneLine = true;
	TooltipInfo2.DrawList[1].bLineBreak = true;
	
	TooltipInfo2.DrawList[1].t_strText = GetClassStr(ClassID) $ " - " $ GetClassType(ClassID);
	TooltipInfo2.DrawList[1].t_color.R = 128;
	TooltipInfo2.DrawList[1].t_color.G = 128;
	TooltipInfo2.DrawList[1].t_color.B = 128;
	TooltipInfo2.DrawList[1].t_color.A = 255;
	m_ClassIcon[idx].SetTooltipCustomType(TooltipInfo2);
	
	//���� ������
	UpdateCPBar(idx, CP, MaxCP);
	UpdateHPBar(idx, HP, MaxHP);
	UpdateMPBar(idx, MP, MaxMP);
}

function HandlePartySummonAdd( string param )
{
	local int	SummonMasterID;
	local int	SummonID;
	local int	 i;
	local int	 MasterIndex;
	
	//debug("add Summon party!!");
	
	ParseInt(param, "SummonMasterID", SummonMasterID);	// ������ ID�� �Ľ��Ѵ�.
	ParseInt(param, "SummonID", SummonID);	// ������ ID�� �Ľ��Ѵ�.
	if (SummonMasterID>0)
	{
		MasterIndex = -1;
		for(i=0; i< NPARTYSTATUS_MAXCOUNT ; i++)
		{
			if(m_arrID[i] == SummonMasterID)
				MasterIndex = i;
		}
		
		if(MasterIndex == -1)
		{
			//debug("ERROR - Can't find master ID");
			return;
		}
		//ResizeWnd();
					
		m_arrPetID[MasterIndex] = SummonID;
		m_arrPetIDOpen[MasterIndex] = 1;
		UpdatePetStatus(MasterIndex, param);
		m_petButton[MasterIndex].showWindow();
		if( !m_PetPartyStatus[MasterIndex].isShowwindow())
		{
			m_PetPartyStatus[MasterIndex].ShowWindow();
			ResizeWnd();
		}
	}
}

function HandlePartySummonUpdate( string param )
{
	local int	SummonID;
	local int	idx;
	
	//debug(" PartySummonUpdate !! ");
	ParseInt(param, "SummonID", SummonID);
	if (SummonID>0)
	{
		idx = FindPetID(SummonID);
		UpdatePetStatus(idx, param);	// �ش� �ε����� �� ������ ����
	}
}

function HandlePartySummonDelete( string param )
{
	local int	SummonID;
	local int	idx;
	//~ local int	i;
	
	//debug("add Delete party!!");
	ParseInt(param, "SummonID", SummonID);
	if (SummonID>0)
	{
		idx = FindPetID(SummonID);
		if (idx>-1)
		{	
			ClearPetStatus(idx);
			ResizeWnd();	// ���� ��Ƽ���� �ڽŹۿ� ���ٸ� �˾Ƽ� ��Ƽ������� �����.
		}
	}
}


function UpdatePetStatus(int idx, string param)
{
	local int		SummonID;			// �� ID
	local int		SummonClassID;		// �� ����
	local int		SummonType;		// �� Ÿ�� 1-��ȯ�� 2-��
	local int		SummonMasterID;	// ������ ID
	local string		SummonNickName;	// �� �̸�
		
	local int		SummonHP;
	local int		SummonMaxHP;
	local int		SummonMP;
	local int		SummonMaxMP;
	local int		SummonLevel;
		
	//~ local int		Width;
	//~ local int		Height;
	//~ local string		tempStr;
	
	if (idx<0 || idx>=NPARTYSTATUS_MAXCOUNT)
		return;
	
	ParseString(param, "SummonNickName", SummonNickName);
	ParseInt(param, "SummonID", SummonID);
	ParseInt(param, "SummonClassID", SummonClassID);
	ParseInt(param, "SummonType", SummonType);
	ParseInt(param, "SummonMasterID", SummonMasterID);
	ParseInt(param, "SummonHP", SummonHP);
	ParseInt(param, "SummonMaxHP", SummonMaxHP);
	ParseInt(param, "SummonMP", SummonMP);
	ParseInt(param, "SummonMaxMP", SummonMaxMP);
	ParseInt(param, "SummonLevel", SummonLevel);
	
	//debug(" SummonNickName : " $ SummonNickName);
	//debug(" SummonID : " $ SummonID);
	//debug(" SummonClassID : " $ SummonClassID);
	//debug(" SummonType : " $ SummonType);
	//debug(" SummonMasterID : " $ SummonMasterID);
	//debug(" SummonHP : " $ SummonHP);
	//debug(" SummonMP : " $ SummonMP);
	//debug(" SummonMaxMP : " $ SummonMaxMP);
	//debug(" SummonLevel : " $ SummonLevel);
	//�̸�
	//
	
	//~ if( Len(SummonNickName) <1)	// �̸��� ������
	//~ {
		//~ if(SummonType == 1)	// ��ȯ��
			//~ m_PetName[idx].SetName((MakeFullSystemMsg( GetSystemMessage(2140), m_PlayerName[idx].GetName())), NCT_Normal,TA_Center);
			//~ //m_PetName[idx].SetName((m_PlayerName[idx].GetName() $ GetSystemString(1597)), NCT_Normal,TA_Center);
		//~ else // ��
			//~ m_PetName[idx].SetName((MakeFullSystemMsg( GetSystemMessage(2139), m_PlayerName[idx].GetName())), NCT_Normal,TA_Center);
			//~ //m_PetName[idx].SetName((m_PlayerName[idx].GetName() $ GetSystemString(1596)), NCT_Normal,TA_Center);
		
		//~ tempStr = m_PetName[idx].GetName();
		//~ //����
		//~ m_PetClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(tempStr));
	//~ }
	//~ else
	//~ {
		//~ m_PetName[idx].SetName(SummonNickName, NCT_Normal,TA_Center);
		//~ //����
		//~ if(SummonType == 1)	// ��ȯ��
			//~ tempStr = m_PetName[idx].GetName() $ " - " $ (MakeFullSystemMsg( GetSystemMessage(2140), m_PlayerName[idx].GetName()));
			//~ //tempStr = m_PetName[idx].GetName() $ " - " $ m_PlayerName[idx].GetName() $ GetSystemString(1597);
		//~ else // ��
			//~ tempStr = m_PetName[idx].GetName() $ " - " $ (MakeFullSystemMsg( GetSystemMessage(2139), m_PlayerName[idx].GetName()));
			//~ //tempStr = m_PetName[idx].GetName() $ " - " $ m_PlayerName[idx].GetName() $ GetSystemString(1596);
		
		//~ m_PetClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(tempStr));
		
	//~ }
			
	//�� ������
	m_PetClassIcon[idx].SetTexture("L2UI_CT1.Icon.ICON_DF_PETICON");
	//m_ClassIcon[idx].SetTexture(GetClassIconName(SummonClassID)); 
	//m_PetClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetClassStr(ClassID) $ " - " $ GetClassType(ClassID)));
	
	//���� ������
	UpdateHPBar(idx + 100, SummonHP, SummonMaxHP);
	UpdateMPBar(idx + 100, SummonMP, SummonMaxMP);
}

//��������Ʈ����
function HandlePartySpelledList(string param)
{
	local int i;
	local int idx;
	local int ID;
	local int Max;
	
	local int BuffCnt;
	local int BuffCurRow;
	
	local int DeBuffCnt;
	local int DeBuffCurRow;
	
	local bool isPC;	//pc���� ������ üũ�ϴ� �Լ�
	
	local StatusIconInfo info;
	
	DeBuffCurRow = -1;
	BuffCurRow = -1;
	
	ParseInt(param, "ID", ID);
	if (ID<1)
	{
		return;
	}
	
	idx = FindPartyID(ID);
	if(idx >=0)
	{
		//���� �ʱ�ȭ
		m_StatusIconBuff[idx].Clear();
		m_StatusIconDeBuff[idx].Clear();		
		isPC = true;
	}
	else	// ��Ƽ���̸� ���� �׳� �н�
	{
		idx = FindPetID(ID);	// ��Ƽ���� �ƴ϶��, ������ ���캻��. 
		if(idx >= 0)
		{
			//���� �ʱ�ȭ
			m_PetStatusIconBuff[idx].Clear();
			m_PetStatusIconDeBuff[idx].Clear();
			isPC = false;
		}
		else
		{
			return;	// �� ���̵��� ���ٸ� �� ���ù���
		}
	}
	
	//info �ʱ�ȭ
	info.Size = 10;
	info.bShow = true;
		
	ParseInt(param, "Max", Max);
	
	for (i=0; i<Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "Level_" $ i, info.Level);
		
		if (IsValidItemID(info.ID))
		{
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level);
			
			if (IsDeBuff( info.ID, info.Level) == true )
			{
				if (DeBuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					DeBuffCurRow++;
					if(isPC)	m_StatusIconDeBuff[idx].AddRow();
					else		m_PetStatusIconDeBuff[idx].AddRow();
				}
				if(isPC)	m_StatusIconDeBuff[idx].AddCol(DeBuffCurRow, info);	
				else 		m_PetStatusIconDeBuff[idx].AddCol(DeBuffCurRow, info);		
				DeBuffCnt++;
			}
			else
			{
				if (BuffCnt%NSTATUSICON_MAXCOL == 0)
				{
					BuffCurRow++;
					if(isPC)	m_StatusIconBuff[idx].AddRow();
					else		m_PetStatusIconBuff[idx].AddRow();
				}
				if(isPC)	m_StatusIconBuff[idx].AddCol(BuffCurRow, info);	
				else		m_PetStatusIconBuff[idx].AddCol(BuffCurRow, info);	
				BuffCnt++;
			}
		}
	}
	UpdateBuff();
}

//���������� ǥ��
function HandleShowBuffIcon(string param)
{
	local int nShow;
	ParseInt(param, "Show", nShow);
	
	m_CurBf = m_CurBf + 1;
	
	
	if (m_CurBf > 2)
	{
		m_CurBf = 0;
	}
	
	SetBuffButtonTooltip();
	
	switch (m_CurBf)
	{
		case 1:
		UpdateBuff();
		break;
		case 2:
		UpdateBuff();
		break;
		case 0:
		m_CurBf = 0;
		UpdateBuff();
	}
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton( string strID )
{
	local int idx;
	local PartyWnd script;
	script = PartyWnd( GetScript("PartyWnd") );
	switch( strID )
	{
	case "btnBuff":		//������ư Ŭ���� 
		OnBuffButton();
		script.OnBuffButton();
		break;
	case "btnOption":	// �ɼ� ��ư Ŭ����
		OnOpenPartyWndOption();
		break;
	case "btnSummon":	// ��ȯ�� ��ư Ŭ����
		//debug("ERROR - you can't enter here");	// ����� ������ ���� -_-;
		break;
	}
	
	if(  inStr( strID , "btnSummon") > -1)
	{
		idx = int( Right(strID , 1));
		if(m_PetPartyStatus[idx].isShowwindow())
		{
			m_PetPartyStatus[idx].HideWindow();
			m_arrPetIDOpen[idx] = 2;
		}
		else
		{
			m_PetPartyStatus[idx].ShowWindow();
			m_arrPetIDOpen[idx] = 1;
		}
		ResizeWnd();
	}
}

// �ɼǹ�ư Ŭ���� �Ҹ��� �Լ�
function OnOpenPartyWndOption()
{
	local int i;
	
	local PartyWndOption script;
	script = PartyWndOption( GetScript("PartyWndOption") );
	// �����ִ� ��ȯ�� â ������ �ɼ� ������� �����Ѵ�. 
	for(i=0; i<NPARTYSTATUS_MAXCOUNT; i++)
	{
		script.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
	}
	
	script.ShowPartyWndOption();
	m_PartyOption.SetAnchor("PartyWndCompact.PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
}

// ������ �ʴ� �Լ��ε�.  PartyWnd, PartyWndCompact, PartyWndOption ���� ������� ����
//		function OnCompactButton()
//		{
//			local int idx;
//			local int Size;
//			
//			if (m_bCompact)
//			{
//				Size = 16;
//			}
//			else
//			{
//				Size = 10;
//			}
//			m_bCompact = !m_bCompact;
//			
//			for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
//			{
//				m_StatusIconBuff[idx].SetIconSize(Size);	
//				m_StatusIconDeBuff[idx].SetIconSize(Size);	
//			}
//		}

// ������ư�� ������ ��� ����Ǵ� �Լ�
function OnBuffButton()
{
	m_CurBf = m_CurBf + 1;
	
	//3���� ��尡 ��ȯ�ȴ�.
	if (m_CurBf > 2)
	{
		m_CurBf = 0;
	}
	
	// ����ǥ��
	SetBuffButtonTooltip();
	
	UpdateBuff();
}

// ����ǥ��, ����� ǥ��,  ���� 3������带 ��ȯ�Ѵ�.
function UpdateBuff()
{
	local int idx;
	if (m_CurBf == 1)
	{
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			m_StatusIconBuff[idx].ShowWindow();	
			m_PetStatusIconBuff[idx].ShowWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
			
		}
	}
	else if (m_CurBf == 2)
	{
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();	
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].ShowWindow();	
			m_PetStatusIconDeBuff[idx].ShowWindow();
			
		}
	}
	else 
	{
		for (idx=0; idx<NPARTYSTATUS_MAXCOUNT; idx++)
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();	
			m_PetStatusIconDeBuff[idx].HideWindow();
		}
	}
}

//CP�� ����
function UpdateCPBar(int idx, int Value, int MaxValue)
{
	m_BarCP[idx].SetValue(MaxValue, Value);
}

//HP�� ����
function UpdateHPBar(int idx, int Value, int MaxValue)
{
	if(idx < 100)
		m_BarHP[idx].SetValue(MaxValue, Value);
	else
		m_PetBarHP[idx - 100].SetValue(MaxValue, Value);
}

//MP�� ����
function UpdateMPBar(int idx, int Value, int MaxValue)
{
	if(idx < 100)
		m_BarMP[idx].SetValue(MaxValue, Value);
	else 	// 100���� ũ�� ���� �����Ŷ��..
		m_PetBarMP[idx - 100].SetValue(MaxValue, Value);
}

//��Ƽ�� Ŭ�� ������..
function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;
	local int idx;
	
	rectWnd = m_wndTop.GetRect();
	if (X > rectWnd.nX + 30)
	{
		if (GetPlayerInfo(userinfo))
		{
			//idx = (Y-rectWnd.nY) / NPARTYSTATUS_HEIGHT;
			idx = GetIdx(Y-rectWnd.nY);
			//debug("OnLButtonDown : " $ idx);
			//RequestTargetUser(m_arrID[idx]);	// ���? �� ��Ƽâ�̶� ����Ʈâ�� ����� �ٸ���?
			if (IsPKMode())
			{
				if(idx <100)
					RequestAttack(m_arrID[idx], userinfo.Loc);
				else
					RequestAttack(m_arrPetID[idx-100], userinfo.Loc);
			}
			else
			{
				if(idx < 100)
					RequestAction(m_arrID[idx], userinfo.Loc);
				else
					RequestAction(m_arrPetID[idx-100], userinfo.Loc);
			}
		}
	}
}

//��Ƽ���� ��ý�Ʈ
function OnRButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local UserInfo userinfo;
	local int idx;
	
	rectWnd = m_wndTop.GetRect();
	if (X > rectWnd.nX + 30)
	{
		if (GetPlayerInfo(userinfo))
		{
			//idx = (Y-rectWnd.nY) / NPARTYSTATUS_HEIGHT;	//�꺸���ֱ� ���� ���� �ڵ�
			idx = GetIdx( Y-rectWnd.nY );
			//debug("OnRButtonUp : " $ idx);
			if(idx <100)
				RequestAssist(m_arrID[idx], userinfo.Loc);
			else
				RequestAssist(m_arrPetID[idx-100], userinfo.Loc);
		}
	}
}

// Y ��ǥ�� �̿��� �迭�� �ε��� ���� ���Ѵ�. ���� ��쿡�� + 100�� �Ͽ� �������ش�. 
function int GetIdx(int y)
{
	local int tempY;	// �̺����� �迭�� ���������� �Ȱ� �������鼭 ���� ���ҽ�Ų��. 
	local int i;
	local int idx;
	
	idx = -1;
	tempY = y;
	
	for(i=0 ; i<NPARTYSTATUS_MAXCOUNT ; i++)
	{
		tempY = tempY - NPARTYSTATUS_HEIGHT;
		if(i == 0) tempY = tempY - FIRSTWND_ADD_HEIGHT;	// ù��° â�� ũ�Ⱑ �� ũ�⶧���� ���� �� ���ش�. 
		
		if(tempY <0)	// 0���� ������ �ش� i�� IDX�� �ȴ�. 
		{
			idx = i;	//�ʿ��ұ� ������, ������ġ ��������..
			return idx;
		}
		else if( m_arrPetIDOpen[i] == 1) // �ش� �ε����� ���� �����ִٸ�
		{
			tempY = tempY - NPARTYPETSTATUS_HEIGHT;			
			if(tempY <0)	// 0���� ������ �ش� i�� IDX�� �ȴ�. 
			{
				idx = i + 100;	//���� ��� 100�� ���Ͽ� �����ش�. 
				return idx;
			}
		}		
	}
	
	return idx;
}

// ���� ������ �����Ѵ�.
function SetBuffButtonTooltip()
{
	local int idx;
	switch (m_CurBf)
	{
		case 0:	idx = 1496;
		break;
		case 1:	idx = 1497;
		break;
		case 2:	idx = 1498;
		break;
	}
	btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
}


function OnDropWnd( WindowHandle hTarget, WindowHandle hDropWnd, int x, int y )
{
	local string sTargetName, sDropName,sTargetParent;
	local int dropIdx, targetIdx,i;
	
	local  PartyWnd script1;			// Ȯ��� ��Ƽâ�� Ŭ����
	//local PartyWndCompact script2;	// ��ҵ� ��Ƽâ�� Ŭ����
	
	script1 = PartyWnd( GetScript("PartyWnd") );
	//script2 = PartyWndCompact( GetScript("PartyWndCompact") );
	
	dropIdx = -1;
	targetIdx = -1;
	
	if( hTarget == None || hDropWnd == None )
		return;
	
	sTargetName = hTarget.GetWindowName();
	sDropName = hDropWnd.GetWindowName();
	sTargetParent = hTarget.GetParentWindowName();
	
	// PartyStatusWnd���� �巡�� �� ����� �� �� �ִ�. 
	//if(( InStr( "PartyStatusWnd", sTargetName ) == -1 ) || ( InStr( "PartyStatusWnd" ,sDropName) == -1 ))
	if( (( InStr( sTargetName , "PartyStatusWnd" ) == -1 ) && ( InStr( sTargetParent , "PartyStatusWnd" ) == -1 )   ) || ( InStr( sDropName, "PartyStatusWnd") == -1 ))
	{
		//Debug( "sTargetName: " $ sTargetName );
		//Debug( "sTargetName: " $ sDropName );
		return;
	}
	else
	{
		dropIdx = int(Right(sDropName , 1));
		
		if( InStr( sTargetName , "PartyStatusWnd" ) > -1 ) 	//Ÿ�� ������ ���� �ܿ�
			targetIdx = int(Right(sTargetName , 1));
		else									//Ÿ�� ������ ������ �θ��� �̸��� PartyStatusWnd �϶�
			targetIdx = int(Right(sTargetParent , 1));
		
		if( dropIdx <0 || targetIdx <0 )
		{
			//Debug( "ERROR IDX: " $ dropIdx $ " / " $  targetIdx);
		}
		
				// �Ʒ� Ȥ�� ���� �о��ִ� �ڵ�
		if( dropIdx > targetIdx)
		{
			CopyStatus ( 8 , dropIdx );		//Ÿ���� �Űܳ���
			script1.CopyStatus ( 8 , dropIdx );		//Ÿ���� �Űܳ���
			
			for (i=dropIdx-1; i>targetIdx-1; i--)	// �Ʒ��� �о��ش�. 
			{
				CopyStatus(i+1, i);
				script1.CopyStatus(i+1, i);
			}
			CopyStatus ( targetIdx , 8  );
			script1.CopyStatus ( targetIdx , 8  );
		}
		else if(dropIdx < targetIdx)
		{
			CopyStatus ( 8 , dropIdx );		//Ÿ���� �Űܳ���
			script1.CopyStatus ( 8 , dropIdx );		//Ÿ���� �Űܳ���
			
			for (i=dropIdx+1; i<targetIdx+1; i++)	// ���� �����ش�.
			{
				CopyStatus(i-1, i);
				script1.CopyStatus(i-1, i);
			}
			CopyStatus ( targetIdx , 8  );
			script1.CopyStatus ( targetIdx , 8  );
		}
		ClearStatus(8);
		ClearPetStatus(8);
		
		//Update Client Data
		class'UIDATA_PARTY'.static.MovePartyMember( dropIdx, targetIdx );
		
		//CopyStatus ( 8 , targetIdx );		//Ÿ���� �Űܳ���
		//CopyStatus ( targetIdx , dropIdx  );
		//CopyStatus ( dropIdx ,  8  );
		//ClearStatus(8);
		//ClearPetStatus(8);
		
		//script1.CopyStatus ( 8 , targetIdx );		//Ÿ���� �Űܳ���
		//script1.CopyStatus ( targetIdx , dropIdx  );
		//script1.CopyStatus ( dropIdx ,  8  );
		//script1.ClearPetStatus(8);
		//script1.ClearStatus(8);
		
		ResizeWnd();
	}
	
	
	//hTarget.
	
	//m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ idx-1, "BottomLeft", "TopLeft", 0, 0);	// �� ������ ������ ��Ŀ
	
	//��Ŀ�� �������ش�. 
		
	//Debug( "DropTargetWindow: " $ hTarget.GetWindowName() );
	//Debug( "DropWindow: " $ hDropWnd.GetWindowName() );
}

function int GetVNameIndexByID( int ID )
{
	local int i;
	for (i=0; i<8; i++)
	{
		if( m_Vname[i].ID == ID )
			return i;
	}
	return -1;
}

function ResetVName()
{
	local int i;
	
	for (i=0; i<8; i++)
	{
		m_Vname[i].ID = i;
		m_Vname[i].UseVName = 0;
		m_Vname[i].DominionIDForVName = 0;
		m_Vname[i].VName = "";
		m_Vname[i].SummonVName = "";
	}
}
defaultproperties
{
}
