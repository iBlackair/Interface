/////////////////////////////////////////////////////////////////////////////////////////////
//								����Ʈ �˸��� â 									     //
//														- create by innowind 2007.10.17	     //
/////////////////////////////////////////////////////////////////////////////////////////////

class QuestAlarmWnd extends UICommonAPI;
	
// ������ ����
// Ȯ�� Ÿ�̸�
const TIMER_ID=11;
const TIMER_DELAY=2000;			// �� �����̸�ŭ �����Ǹ� â�� Ȯ��ȴ�.
// ��� Ÿ�̸�
const TIMER_ID2=12;
const TIMER_DELAY2=500;			// �� �����̸�ŭ �����Ǹ� â�� ��ҵȴ�.

const EXPEND_CONTRACT_GAP = 37;

const CONTRACT_WIN_WIDTH = 213;
const EXPEND_WIN_WIDTH = 250;		// Ȯ��� ��ü ������ ����

const CONTRACT_QUEST_NAME_WIDTH = 198;
const EXPEND_QUEST_NAME_WIDTH = 235;	// ����Ʈ �̸� ����

const CONTRACT_ITEM_NAME_WIDTH = 113;
const EXPEND_ITEM_NAME_WIDTH = 150;	// ������ �̸� ����

const QUEST_ITEM_NUM_DEFAULT = 85;		// ����Ʈ ������ ����


const TEXT_HEIGHT = 18;				// �ؽ�Ʈ �⺻ ����
//const TEXT_HEIGHT_MARGIN = 2;			// �ؽ�Ʈ ����

const WINDOW_HEIGHT_MARGIN = 10;		// ������ ������ ����

const MAX_ITEM = 5;				// �ִ� ������ ��
const MAX_QUEST = 5;			// �ִ� ����Ʈ ��
const MAX_QUEST_ALL = 25;		//���� �� ���� ���Ѱ� ;;

// �������� �����
var bool isWaitExpand;		// â�� Ȯ���ϱ� ���� ��ٸ��� �ִ°�?
var bool isWaitContract;	// â�� ��� �Ǳ� ���� ��ٸ��� �ִ°�?
var bool isExpand;		// â�� ���� Ȯ��� �����ΰ�?

var bool isClickedAdd;		// ��ư Ŭ������ �ֵ� �ߴ��� Ȯ���ϴ� �Լ�

var int m_NumOfQuest;		// ���� �������� �ִ� ����Ʈ�� ����

var int i, j;				// for ������ ���� ����

var Color Gold;
var Color White;
var Color Gray;

// �ڵ� �����
var WindowHandle Me;
var WindowHandle QuestWndOverCheck;
var ButtonHandle btnClose;

var WindowHandle QuestWnd[MAX_QUEST];
var NameCtrlHandle QuestAlarmName[MAX_QUEST];
var int QuestAlarmNameID[MAX_QUEST];
var NameCtrlHandle QuestItemName[MAX_QUEST_ALL];
var int QuestItemNameID[MAX_QUEST_ALL];
var TextBoxHandle QuestItemNum[MAX_QUEST_ALL];
var INT64 QuestItemNumInt[MAX_QUEST_ALL];

function OnRegisterEvent()
{
	RegisterEvent( EV_GamingStateExit );
	RegisterEvent( EV_MouseOver );
	RegisterEvent( EV_MouseOut );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();
	Load();
	InitData();	//�ش� �������� �ʱ�ȭ�۾�
	FitWindowSize();	//������ �����۾�
}

// �ڵ� �ʱ�ȭ
function Initialize()
{
	//�ڵ� ������
	Me = GetHandle( "QuestAlarmWnd" );
	QuestWndOverCheck = GetHandle( "QuestWndOverCheck" );
	btnClose = ButtonHandle ( GetHandle( "QuestAlarmWnd.btnClose" ) );
	
	for(i=0 ; i<MAX_QUEST ; i++)
	{
		QuestWnd[i] =  GetHandle( "QuestAlarmWnd.QuestWnd" $ i+1 );
		QuestAlarmName[i] = NameCtrlHandle ( GetHandle( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestAlarmName1") );
		for (j=0 ; j<MAX_ITEM ; j++)
		{			
			QuestItemName[i * 5 + j] = NameCtrlHandle ( GetHandle( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1) );
			QuestItemNum[i*5 + j] = TextBoxHandle ( GetHandle( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemNum" $ j + 1) );
			QuestItemNum[i*5 + j].SetAnchor("QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1, "TopRight", "TopLeft", 3, 0);
		}
	}	
}

function InitializeCOD()
{
	//�ڵ� ������
	Me = GetWindowHandle( "QuestAlarmWnd" );
	QuestWndOverCheck = GetWindowHandle( "QuestWndOverCheck" );
	btnClose = GetButtonHandle ( "QuestAlarmWnd.btnClose" );
	
	for(i=0 ; i<MAX_QUEST ; i++)
	{
		QuestWnd[i] =  GetWindowHandle( "QuestAlarmWnd.QuestWnd" $ i+1 );
		QuestAlarmName[i] = GetNameCtrlHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestAlarmName1");
		for (j=0 ; j<MAX_ITEM ; j++)
		{			
			QuestItemName[i * 5 + j] = GetNameCtrlHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1);
			QuestItemNum[i*5 + j] = GetTextBoxHandle ( "QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemNum" $ j + 1);
			QuestItemNum[i*5 + j].SetAnchor("QuestAlarmWnd.QuestWnd" $ i + 1 $ ".QuestItemName" $ j + 1, "TopRight", "TopLeft", 3, 0);
		}
	}	
}

function Load()
{
	
	Gold.R = 175;
	Gold.G = 152;
	Gold.B = 120;
	Gold.A = 255;
	
	White.R = 250;
	White.G = 250;
	White.B = 250;
	White.A = 255;
	
	Gray.R = 135;
	Gray.G = 135;
	Gray.B = 135;
	Gray.A = 255;
}

function InitData()
{
	isWaitExpand = false;
	isExpand = false;
	
	for(i=0 ; i<MAX_QUEST ; i++)
	{
		QuestAlarmNameID[i] = -1;	// -1�̸� �󽽷�
		QuestAlarmName[i].SetName("", NCT_Normal,TA_Left);
		for (j=0 ; j<MAX_ITEM ; j++)
		{			
			QuestItemNameID[i*5 + j] = -1; 	// -1�̸� �󽽷�
			QuestItemName[i*5 + j].SetName("", NCT_Normal,TA_Left);
			QuestItemNum[i*5 + j].SetText("");			
		}
	}	
	m_NumOfQuest= 0;
	
	isClickedAdd = false;
}

function OnEvent( int a_EventID, String a_Param )
{
	local string CurrentWndName;
	local string ParentWndName;
	
	switch( a_EventID )
	{
	case EV_MouseOver:
		ParseString(a_Param, "Name", CurrentWndName);
		ParseString(a_Param, "TopWndName", ParentWndName);
		//debug("mouse over!! Name : " $ CurrentWndName $ " parent : " $ ParentWndName);
		if(CurrentWndName == "QuestWndOverCheck" || ParentWndName == "QuestWndOverCheck")
		{
			if(isExpand == false)	// â�� ��ҵ� ���¿����� Ȯ��� ���·� ���� �� ����
			{
				Me.SetTimer(TIMER_ID,TIMER_DELAY);
				isWaitExpand = true;
			}
		}
		break;
	
	case EV_MouseOut:
		ParseString(a_Param, "Name", CurrentWndName);
		ParseString(a_Param, "TopWndName", ParentWndName);
		//debug("mouse out!! Name : " $ CurrentWndName $ " parent : " $ ParentWndName);
		if(CurrentWndName == "QuestWndOverCheck" || ParentWndName == "QuestWndOverCheck")
		{			
			if(isExpand == true)	// Ȯ��� ���¿����� �ٿ��� �� �ִ�. 
			{
				ContractWindowSize();
				isExpand = false;
				isWaitContract = false;
			}
			isWaitExpand = false;
		}
		break;
	case EV_GamingStateExit:	//������ �ʱ�ȭ���ֱ�
		InitData();
		break;
	}
}

// Ÿ�̸� �⵿
function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID)
	{
		if(isExpand == false && isWaitExpand == true )	// â�� Ȯ����� ���� ���¿����� Ȯ�����ش�.
		{
			ExpendWindowSize();
			
			isExpand = true;
			isWaitExpand = false;
		}
		Me.KillTimer( TIMER_ID );
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
	case "btnClose":
		OnbtnCloseClick();
		break;
	}
}

function OnbtnCloseClick()
{
	InitData();
	if(Me.isShowWindow()) Me.HideWindow();
}

// Ȯ��� ��� ������ ������ ��ȭ��
function ExpendWindowSize()
{
	local int Height;
	local String tempStr;
	local int nWidth, nHeight;
	
	Me.GetWindowSize(i, Height);	//���̴� ��¥�� ������� �ʱ� ������ �׳� ����(i) ��Ȱ��
	
	Me.SetWindowSize( EXPEND_WIN_WIDTH,  Height );
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		QuestWnd[i].GetWindowSize(j , Height); //���̴� ��¥�� ������� �ʱ� ������ �׳� ����(j) ��Ȱ��
		QuestWnd[i].SetWindowSize( EXPEND_QUEST_NAME_WIDTH,  Height );
		QuestAlarmName[i].SetWindowSize( EXPEND_QUEST_NAME_WIDTH,  TEXT_HEIGHT );
	}
	
	for(i = 0 ; i< MAX_QUEST_ALL ; i++)
	{
		tempStr = QuestItemName[i].GetName();
		GetTextSizeDefault(tempStr, nWidth, nHeight);
		if(nWidth < EXPEND_ITEM_NAME_WIDTH && nWidth > 5)	// 5�� �׳� ����. (������ �̸��� 5�ȼ� ������ �� ���� ������ ) �ſ� ���� ������ ������ ("") �� �������� ����� ���߷��� ���� ���ϰ� �ϱ� ����
		{
			QuestItemName[i].SetWindowSize( nWidth,  TEXT_HEIGHT );
		}
		else
		{		
			QuestItemName[i].SetWindowSize( EXPEND_ITEM_NAME_WIDTH,  TEXT_HEIGHT );
		}
	}
	
	Me.MoveEx(CONTRACT_WIN_WIDTH - EXPEND_WIN_WIDTH  ,0);	// ����ŭ �̵����� �ش�.
}

// ��ҵ� ��� ������ ������ ��ȭ��
function ContractWindowSize()
{
	local int Height;
	local String tempStr;
	local int nWidth, nHeight;
	
	Me.GetWindowSize(i, Height);	//���̴� ��¥�� ������� �ʱ� ������ �׳� ����(i) ��Ȱ��	
	Me.SetWindowSize( CONTRACT_WIN_WIDTH,  Height );
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		QuestWnd[i].GetWindowSize(j , Height); //���̴� ��¥�� ������� �ʱ� ������ �׳� ����(j) ��Ȱ��
		QuestWnd[i].SetWindowSize( CONTRACT_QUEST_NAME_WIDTH,  Height );
		QuestAlarmName[i].SetWindowSize( CONTRACT_QUEST_NAME_WIDTH,  TEXT_HEIGHT );
	}
	
	for(i = 0 ; i< MAX_QUEST_ALL ; i++)
	{
		tempStr = QuestItemName[i].GetName();
		GetTextSizeDefault(tempStr, nWidth, nHeight);
		if(nWidth < CONTRACT_ITEM_NAME_WIDTH  && nWidth > 5) // 5�� �׳� ����. (������ �̸��� 5�ȼ� ������ �� ���� ������ ) �ſ� ���� ������ ������ ("") �� �������� ����� ���߷��� ���� ���ϰ� �ϱ� ����
		{
			QuestItemName[i].SetWindowSize( nWidth,  TEXT_HEIGHT );
		}
		else
		{		
			QuestItemName[i].SetWindowSize( CONTRACT_ITEM_NAME_WIDTH,  TEXT_HEIGHT );
		}
	}
	
	Me.MoveEx(EXPEND_WIN_WIDTH - CONTRACT_WIN_WIDTH   ,0);	// ����ŭ �̵����� �ش�.
}

// ���� ��ϵ� ����Ʈ�鿡 �°� ������ ����� �����Ѵ�.  (�ַ� ���� ������)
function FitWindowSize()
{

	local int Width, Height;
	
	local int totalHeight; //�� �������� ����
	local int oneWinHeight;	// ������ �ϳ��� ����
	
	totalHeight = 0;
	m_NumOfQuest = 0;
	for(i = 0; i<MAX_QUEST ; i++)	// ����Ʈ�� ��ϵǾ��ٸ�, ����Ʈ �����츦 ��� ���ش�. 
	{
		if( QuestAlarmNameID[i] == -1)	
		{
			if(QuestWnd[i].IsShowWindow())		//��ϵ��� �ʾҴµ� show �ǰ��ִٸ� ���̵� �����ش�.
			{
				QuestWnd[i].HideWindow();
			}
		}
		else
		{
			m_NumOfQuest++;	// ǥ�õǰ� �ִ� ����Ʈ�� ���� ������Ų��.
			if(!QuestWnd[i].IsShowWindow())
			{
				QuestWnd[i].showWindow();
			}
			
			oneWinHeight = 0;
			
			oneWinHeight = oneWinHeight + TEXT_HEIGHT;	//����Ʈ �̸���			
			
			for(j=0 ; j<MAX_ITEM ; j++)
			{
				if( QuestItemNameID[i * 5 + j] != -1)	
				{
					oneWinHeight = oneWinHeight + TEXT_HEIGHT;
				}
			}
			totalHeight = totalHeight + oneWinHeight +WINDOW_HEIGHT_MARGIN;
			
			QuestWnd[i].GetWindowSize(Width, Height);
			QuestWnd[i].SetWindowSize(Width, oneWinHeight);
		}
	}
	
	if(m_NumOfQuest == 0)	
	{
		if(Me.IsShowWindow()) Me.HideWindow();
	}
	else
	{
		//debug("totalHeight = " $ totalHeight);
		Me.GetWindowSize(Width, Height);
		Me.SetWindowSize(Width, totalHeight);
		if(!Me.IsShowWindow()) Me.ShowWindow();	
	}
}

// ����Ʈ �˶��� ����Ѵ�.
function AddQuestAlarm(int QuestID, int Level, int ItemID, INT64 ItemNum)
{
	local string QuestName, ItemName;
	local int idx, idxItem, idxItemSomeID;
	local INT64 itemCount;
	local String tempStr;
	local int nWidth, nHeight;
	
	//local int nItemNumWidth, nItemNumHeight;
		
	QuestName = class'UIDATA_QUEST'.static.GetQuestName(QuestID);
	ItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(ItemID));
	
	// ����Ʈ ���̵�� �̹� ��ϵ� ����Ʈ���� �˻��Ѵ�.	
	idx = QuestSlotIdx(QuestID);
	if( idx == -1) 	// �̹� ��ϵǾ� ���� ���� ����Ʈ��.
	{
		idx = FindEmptyQuestSlot();
		if(idx == -1)	// �󽽷��� ������ ����!
		{
			// 5�� �̻� ����� �� �����ϴ�. �ý��� �޼��� �����ֱ�.
			if(isClickedAdd == true)
			{
				AddSystemMessage(2279);
			}			
			isClickedAdd = false;
			return;
		}
		else
		{
			QuestAlarmName[idx].SetNameWithColor(QuestName, NCT_Normal,TA_Left, Gold);
			QuestAlarmNameID[idx] = QuestID;
		}
	}	
	
	// ������ �̸� �־��ֱ�.	
	idxItem = FindEmptyItemSlot(idx);	// Ư�� ����Ʈ�� ������ ������ ���� ���� üũ
	if(idxItem == -1)	// �󽽷��� ������ ����!
	{
		//���״� �ƴϰ� ������ �� ADD �ϸ� ���� ����	
		return;
	}
	else
	{
		idxItemSomeID = QuestItemSlotIdx(idx, ItemID);
		
		if(idxItemSomeID == -1)	//���� �������� ���ٸ� �߰�
		{
			itemCount = GetInventoryItemCount(GetItemID(ItemID));		
			
			//debug("itemcount  = " $ string(itemCount));
			
			if(itemCount < ItemNum || ItemNum == IntToInt64(0))
			{
				tempStr = "- " $ ItemName;
				GetTextSizeDefault(tempStr, nWidth, nHeight);
				QuestItemName[idx*5 + idxItem].SetNameWithColor( tempStr, NCT_Normal,TA_Left, White);
				QuestItemNum[idx*5 + idxItem].SetTextColor(White);
				
				if(nWidth < CONTRACT_ITEM_NAME_WIDTH)
				{
					QuestItemName[idx*5 + idxItem].GetWindowSize( i , nHeight);	// i�� ������� �ʴ� ����. 
					QuestItemName[idx*5 + idxItem].SetWindowSize(nWidth , nHeight);
				}
			}
			else
			{
				tempStr = "- " $ ItemName;
				GetTextSizeDefault(tempStr, nWidth, nHeight);
				QuestItemName[idx*5 + idxItem].SetNameWithColor(tempStr, NCT_Normal,TA_Left, Gray);
				QuestItemNum[idx*5 + idxItem].SetTextColor(Gray);
				
				if(nWidth < CONTRACT_ITEM_NAME_WIDTH)
				{
					QuestItemName[idx*5 + idxItem].GetWindowSize( i , nHeight);	// i�� ������� �ʴ� ����. 
					QuestItemName[idx*5 + idxItem].SetWindowSize(nWidth , nHeight);
				}
			}
			 
			// ������ ���� ǥ��
			//if(ItemNum == 0)	QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ "�� )");
			//if(ItemNum == 0)	QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ GetSystemString(858) $ ")");
			if(ItemNum < IntToInt64(1))	{QuestItemNum[idx*5 + idxItem].SetText( "(" $ Int64ToString(itemCount) $ ")");}	// ������ ���� ���� �������� ������ ǥ�����ش�.
			else				
			{				
				QuestItemNum[idx*5 + idxItem].SetText( "(" $ Int64ToString(itemCount) $ "/" $ Int64ToString(ItemNum) $ ")");
				//if( itemCount < ItemNum )		QuestItemNum[idx*5 + idxItem].SetText( "(" $ itemCount $ "/" $ ItemNum $ ")");
				//else 						QuestItemNum[idx*5 + idxItem].SetText( "(" $ ItemNum $ "/" $ ItemNum $ ")");
			}
				
			QuestItemNameID[idx*5 + idxItem] = ItemID;	
			QuestItemNumInt[idx*5 + idxItem] = ItemNum;
		}
	}
	
	 FitWindowSize();
	
	isClickedAdd = false;
}

function AddQuestAlarmExpand(int questID, int questLevel, int npcId, int numOfKillMonsters, INT64 npcMaxCount)
{
	local int npcCurrentCount;

	local string questName, npcName;
	local int existQuestIndex;//, emptySlotIndex;
	local int emptyNpcSlotIndex, existNpcSlotIndex;

	local string tempStr;
	local int nWidth, nHeight;

	questName = class'UIDATA_QUEST'.static.GetQuestName( questId );

	//if( questType == 0)
	//{
	npcName = class'UIDATA_NPC'.static.GetNPCName( npcId - 1000000 );
	//}

	// óġ : 2240
	npcName = npcName $ " " $ GetSystemString(2240);

	npcCurrentCount = numOfKillMonsters;

	existQuestIndex = QuestSlotIdx( questId );
	if( existQuestIndex == -1 )
	{
		existQuestIndex = FindEmptyQuestSlot( );
		if( existQuestIndex == -1 )
		{
			if( isClickedAdd == true )
			{
				AddSystemMessage( 2279 );
			}	
			isClickedAdd = false;
			return;
		}
		else
		{
			QuestAlarmName[existQuestIndex].SetNameWithColor( questName, NCT_Normal, TA_Left, Gold );
			QuestAlarmNameID[existQuestIndex] = questId;
		}
	}

	emptyNpcSlotIndex = FindEmptyItemSlot( existQuestIndex );
	if(emptyNpcSlotIndex == -1)	
	{
		return;
	}
	else
	{
		existNpcSlotIndex = QuestItemSlotIdx( existQuestIndex, npcId );

		if( existNpcSlotIndex == -1 )
		{
			if( IntToInt64(npcCurrentCount) < npcMaxCount || npcMaxCount == IntToInt64(0) )
			{
				tempStr = "- " $ npcName;
				GetTextSizeDefault( tempStr, nWidth, nHeight );
				QuestItemName[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetNameWithColor( tempStr, NCT_Normal, TA_Left, White );
				QuestItemNum[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetTextColor( White );

				if( nWidth < CONTRACT_ITEM_NAME_WIDTH )
				{
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].GetWindowSize( i , nHeight );
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].SetWindowSize( nWidth , nHeight );
				}
			}
			else
			{
				tempStr = "- " $ npcName;
				GetTextSizeDefault( tempStr, nWidth, nHeight );
				QuestItemName[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetNameWithColor( tempStr, NCT_Normal, TA_Left, Gray );
				QuestItemNum[ existQuestIndex * 5 + emptyNpcSlotIndex ].SetTextColor( Gray );

				if( nWidth < CONTRACT_ITEM_NAME_WIDTH )
				{
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].GetWindowSize( i , nHeight );
					QuestItemName[existQuestIndex * 5 + emptyNpcSlotIndex].SetWindowSize( nWidth , nHeight );
				}
			}

			if( npcMaxCount < IntToInt64(1) )
			{
				QuestItemNum[existQuestIndex * 5 + emptyNpcSlotIndex ].SetText( " (" $ string( npcCurrentCount ) $ ")" );
			}
			else				
			{		
				QuestItemNum[existQuestIndex * 5 + emptyNpcSlotIndex ].SetText( " (" $ string( npcCurrentCount ) $ "/" $ Int64ToString( npcMaxCount ) $ ")" );
			}
				
			QuestItemNameID[existQuestIndex * 5 + emptyNpcSlotIndex ] = npcId;
			QuestItemNumInt[existQuestIndex * 5 + emptyNpcSlotIndex ] = npcMaxCount;
		}
	}

	FitWindowSize();	
	isClickedAdd = false;	
}


// ����Ʈ �˶����� ����
function DeleteQuestAlarm(int QuestID )	
{
	local int idx;
	local Color tempColor;
	local int nWidth, nHeight;
	
	idx = QuestSlotIdx(QuestID); 
	
	if( idx == -1) 	// �̹� ��ϵǾ� ���� ���� ����Ʈ��� �ƹ��͵� ���� �ʴ´�.
	{
		return; 
	}
	else
	{		
		// �Ʒ� ����Ʈ�� �����ֱ�
		for(i = idx + 1 ;  i < MAX_QUEST ; i++)
		{
			QuestAlarmName[i -1].SetNameWithColor( QuestAlarmName[i].GetName(), NCT_Normal,TA_Left, Gold);
			QuestAlarmNameID[i-1] = QuestAlarmNameID[i];	
			for (j=0 ; j<MAX_ITEM ; j++)
			{		
				tempColor =  QuestItemNum[i*5 + j].GetTextColor();
				
				QuestItemName[(i-1)*5 + j].SetNameWithColor(QuestItemName[i*5 + j].GetName() , NCT_Normal,TA_Left, tempColor);
				QuestItemName[i*5 + j].GetWindowSize(nWidth, nHeight);			// ������ ����� �Ű��ش�.
				QuestItemName[(i-1)*5 + j].SetWindowSize(nWidth, nHeight);
				QuestItemNameID[(i-1)*5 + j] = QuestItemNameID[i*5 + j]; 	
				QuestItemNum[(i-1)*5 + j].SetText( QuestItemNum[i*5 + j].GetText() );
				QuestItemNum[(i-1)*5 + j].SetTextColor (tempColor);
				QuestItemNumInt[(i-1)*5 + j] = QuestItemNumInt[i*5 + j];
			}
		}
		
		idx = MAX_QUEST - 1;
		QuestAlarmName[idx].SetName("", NCT_Normal,TA_Left);
		QuestAlarmNameID[idx] = -1;	
		for (j=0 ; j<MAX_ITEM ; j++)
		{		
			QuestItemName[idx*5 + j].SetName("", NCT_Normal,TA_Left);			
			QuestItemNameID[idx*5 + j] = -1; 	// -1�̸� �󽽷�
			QuestItemNum[idx*5 + j].SetText("");
			QuestItemNumInt[idx*5 + j] = IntToInt64(-1);
		}
	}
	
	 FitWindowSize();
}

// Ư�� ���̵� �ش��ϴ� ����Ʈ �������� ������ �����Ͽ� �ش�.
function UpdateAlarmItem(int ItemID , INT64 Count)
{
	local string NameTemp1;
	
	for( i = 0; i < MAX_QUEST_ALL; i++ )
	{
		if( QuestItemNameID[ i ] == ItemID)	
		{			
			if( Count < QuestItemNumInt[ i ]  || QuestItemNumInt[ i ] == IntToInt64(0) )	
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, White );
				QuestItemNum[ i ].SetTextColor( White );	
			}
			else
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, Gray );
				QuestItemNum[ i ].SetTextColor( Gray );
			}

			if(QuestItemNumInt[i] == IntToInt64(0))
			{
				QuestItemNum[i].SetText( "(" $ Int64ToString( Count ) $ ")");
			}
			else				
			{	
				QuestItemNum[i].SetText( "(" $ Int64ToString( Count) $ "/" $ Int64ToString( QuestItemNumInt[ i ] )  $ ")");
			}				
		}
	}
}

function UpdateAlarmExpand(int npcId , int Count)
{
	local string NameTemp1;

	for( i = 0; i<MAX_QUEST_ALL ; i++ )
	{
		if( QuestItemNameID[ i ] == npcId )	
		{			
			if( IntToInt64(Count) < QuestItemNumInt[ i ]  || QuestItemNumInt[ i ] == IntToInt64(0))	
			{	
				NameTemp1 = QuestItemName[ i ].GetName();
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, White );
				QuestItemNum[ i ].SetTextColor( White );	
			}
			else
			{	
				NameTemp1 = QuestItemName[ i ].GetName( );
				QuestItemName[ i ].SetNameWithColor( NameTemp1, NCT_Normal,TA_Left, Gray );
				QuestItemNum[ i ].SetTextColor( Gray );
			}
			
			if( QuestItemNumInt[i] == IntToInt64(0) )	
			{
				QuestItemNum[ i ].SetText( " (" $ string(Count) $ ")");
			}
			else				
			{	
				QuestItemNum[i].SetText( " (" $ string(Count) $ "/" $ Int64ToString(QuestItemNumInt[i])  $ ")");
			}				
		}
	}
}

// �� ����Ʈ ������ ã�´�. -1�̸� �� á��
function int FindEmptyQuestSlot()
{
	local int slotID;
	
	slotID = -1;
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		if( QuestAlarmNameID[i] == -1)	
		{
			slotID = i;
			break;
		}
	}
	
	return slotID;
}

//�ش� ����Ʈ ���̵��� ���ؽ��� �����Ѵ�. 
function int QuestSlotIdx(int QuestID)
{
	local int slotID;
	
	slotID = -1;
	
	for(i = 0; i<MAX_QUEST ; i++)
	{
		if( QuestAlarmNameID[i] == QuestID)
		{
			slotID = i;
			break;
		}
	}
	
	return slotID;
}

// �� ����Ʈ ������ ������ ã�´�. -1�̸� �� á��
function int FindEmptyItemSlot(int QuestIdx)
{
	local int itemSlotID;
	
	itemSlotID = -1;
	for(i = 0; i<MAX_ITEM ; i++)
	{
		if( QuestItemNameID[QuestIdx * 5 + i] == -1)	
		{
			itemSlotID = i;
			break;
		}
	}
	
	return itemSlotID;
}

//�ش� ����Ʈ �������� ���̵� ���ؽ��� �����Ѵ�. 
function int QuestItemSlotIdx(int QuestIdx , int ItemID)
{
	local int itemSlotID;
	
	itemSlotID = -1;	
	for(i = 0; i<MAX_ITEM ; i++)
	{
		if(QuestItemNameID[QuestIdx * 5 + i]== ItemID)
		{
			itemSlotID = i;
			break;
		}
	}
	
	return itemSlotID;
}
defaultproperties
{
}
