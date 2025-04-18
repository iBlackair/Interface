class MagicSkillWnd extends UICommonAPI;

const Skill_MAX_COUNT = 24;
const Skill_GROUP_COUNT = 8;

const Skill_GROUP_COUNT_P = 6;	//�нú��

//const SKILL_MAX_HERO = 6;
//const SKILL_MAX_ITEM = 1000;
//const SKILL_MAX_CHANGE = 20;

const SKILL_ITEMWND_WIDTH = 223;
const SKILL_SLOTBG_WIDTH = 216;
const TOP_MARGIN = 5;
const NAME_WND_HEIGHT = 20;
const BETWEEN_NAME_ITEM = 3;

// ��ų �׷� ��ȣ
const SKILL_NORMAL = 0;		// ���� ��ų. ������ �� ��, ���� ����.
const SKILL_BUF = 1;			// ����
const SKILL_DEBUF = 2;		// �����
const SKILL_TOGGLE = 3;		// ���
const SKILL_SONG_DANCE = 4;	// �۴�
const SKILL_ITEM = 5;			// ������ ��ų
const SKILL_HERO = 6;		// ���� ��ų
const SKILL_CHANGE = 7;		// ���� ��ų

var WindowHandle	m_wndTop;
var WindowHandle	m_wndSkillDrawWnd;
// ��Ƽ���
var WindowHandle	m_wndName[Skill_GROUP_COUNT];
var TextBoxHandle	m_NameStr[Skill_GROUP_COUNT];
var TextureHandle	m_NameBtn[Skill_GROUP_COUNT];
var TextureHandle	m_ItemBg[Skill_GROUP_COUNT];
var WindowHandle	m_wnd[Skill_GROUP_COUNT];
var ItemWindowHandle	m_Item[Skill_GROUP_COUNT];
var ButtonHandle		m_HiddenBtn[Skill_GROUP_COUNT];
var WindowHandle	areaScroll;
//�нú��
var WindowHandle	m_wndName_p[Skill_GROUP_COUNT_P];
var TextBoxHandle	m_NameStr_p[Skill_GROUP_COUNT_P];
var TextureHandle	m_NameBtn_p[Skill_GROUP_COUNT_P];
var TextureHandle	m_ItemBg_p[Skill_GROUP_COUNT_P];
var WindowHandle	m_wnd_p[Skill_GROUP_COUNT_P];
var ItemWindowHandle	m_Item_p[Skill_GROUP_COUNT_P];
var ButtonHandle		m_HiddenBtn_p[Skill_GROUP_COUNT_P];
var WindowHandle	areaScroll_p;

//var array<int> m_HeroSkillID;
//var array<int> m_ItemSkillID;
//var array<int> m_ChangeSkillID;

var bool m_bShow;
var String m_WindowName;
// ��Ƽ���
var int m_bExistSkill[Skill_GROUP_COUNT];	// 1�̸� �ش� �׷� ��ų�� ���°�, 2�̸� �ش� �׷� ��ų�� �ְ� �����ִ� ��. 3 �̸� �ش� �׷� ��ų�� �ְ� ���� �ִ� ��
var int nScrollHeight;					// ��ü �������� ��ũ�� ũ�� ����

// �нú��
var int m_bExistSkill_p[Skill_GROUP_COUNT_P];
var int nScrollHeight_p;					// ��ü �������� ��ũ�� ũ�� ����

var WindowHandle	Drawer;
var ButtonHandle	ResearchButton;

var LSTimerWnd script_timer;
var int LScount;

function OnRegisterEvent()
{
	RegisterEvent(EV_SkillListStart);
	RegisterEvent(EV_SkillList);
	RegisterEvent(EV_LanguageChanged);
	RegisterEvent(Ev_SkillEnchantInfoWndShow);
	
}

function OnLoad()
{
	m_WindowName="MagicSkillWnd";
	InitHandle();
		
	m_bShow = false;
}

function InitHandle()
{
	local int i;

	m_wndTop = GetWindowHandle( m_WindowName );
	Drawer = GetWindowHandle( "MagicSkillDrawerWnd");
	areaScroll = GetWindowHandle( m_WindowName $ ".ASkillScroll" );
	areaScroll_p = GetWindowHandle( m_WindowName $ ".PSkillScroll" );
	
	for(i=0; i<Skill_GROUP_COUNT ; i++)
	{
		m_wndName[i] = GetWindowHandle( m_WindowName $".ASkill.ASkillName" $ i ); 
		m_wnd[i] = GetWindowHandle( m_WindowName $ ".ASkill.ASkill" $ i ); 
		m_NameStr[i] = GetTextBoxHandle ( m_WindowName $ ".ASkill.ASkillName" $  i $ ".ASkillNameStr" $ i ); 
		m_NameBtn[i] = GetTextureHandle( m_WindowName $ ".ASkill.ASkillName" $  i $ ".ASkillBtn" $ i ); 
		m_Item[i] = GetItemWindowHandle ( m_WindowName $ ".ASkill.ASkill" $  i $ ".ASkillItem" $ i ); 
		m_ItemBg[i] = GetTextureHandle( m_WindowName $ ".ASkill.ASkill" $  i $ ".ASkillSlotBg" $ i ); 
		m_HiddenBtn[i] = GetButtonHandle ( m_WindowName $ ".ASkill.ASkillName" $  i $ ".ASkillHiddenBtn" $ i ); 
		m_HiddenBtn[i].SetAlpha(255);
	}
	
	for(i=0; i<Skill_GROUP_COUNT_P ; i++)
	{
		m_wndName_p[i] = GetWindowHandle( m_WindowName $".PSkill.PSkillName" $ i ); 
		m_wnd_p[i] = GetWindowHandle( m_WindowName $ ".PSkill.PSkill" $ i ); 
		m_NameStr_p[i] = GetTextBoxHandle ( m_WindowName $ ".PSkill.PSkillName" $  i $ ".PSkillNameStr" $ i ); 
		m_NameBtn_p[i] = GetTextureHandle( m_WindowName $ ".PSkill.PSkillName" $  i $ ".PSkillBtn" $ i ); 
		m_Item_p[i] = GetItemWindowHandle ( m_WindowName $ ".PSkill.PSkill" $  i $ ".PSkillItem" $ i ); 
		m_ItemBg_p[i] = GetTextureHandle( m_WindowName $ ".PSkill.PSkill" $  i $ ".PSkillSlotBg" $ i ); 
		m_HiddenBtn_p[i] = GetButtonHandle ( m_WindowName $ ".PSkill.PSkillName" $  i $ ".PSkillHiddenBtn" $ i ); 
		m_HiddenBtn_p[i].SetAlpha(255);
	}
	
	script_timer = LSTimerWnd(GetScript("LSTimerWnd"));
	LScount = 0;
}

function OnShow()
{
	RequestSkillList();
	m_bShow = true;
}

function OnHide()
{
	local MagicSkillDrawerWnd script_a;	

	m_bShow = false;

	script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));

	script_a.HideAgathion();
	Drawer.HideWindow();
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_SkillListStart)
	{
		//debug("!!!Skill!!! List ��Ŷ ���ƿ�");
		HandleSkillListStart();
	}
	else if (Event_ID == EV_SkillList)
	{
		if (m_wndTop.IsShowWindow() == true)
		{
			HandleSkillList(param);
			ComputeItemWndHeight();
			ComputeItemWndAnchor();
		}
	}
	else if (Event_ID == EV_LanguageChanged)
	{
		HandleLanguageChanged();
	}
	else if (Event_ID == Ev_SkillEnchantInfoWndShow)
	{
		Drawer.ShowWindow();
	}
}

//��ų�� Ŭ��
function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	local int		GroupID;
	
	if ( InStr( strID ,"ASkillItem" ) > -1 && index>-1)
	{
		GroupID = int(Right(strID, 1));
		if(m_Item[GroupID].GetItem(index, infItem))
		{
			// 10.04.5 ������ ���� ��û 
			//AddSystemMessageString("SkillID: " $ string(infItem.ID.ClassID) $ ", " $ string(infItem.ID.ServerID) $ ", ItemSub: " $ string(infItem.ItemSubType));
			//printItemInfo(infItem);
			UseSkill(infItem.ID, infItem.ItemSubType);
		}
	}
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton( string strID )
{
	local int i;				// for�� ������ ���� ����
	local int index;
	local int nWndWidth, nWndHeight; // ������ ������ �ޱ� ����
	local MagicSkillDrawerWnd script_a;	
	
	index = int(Right(strID, 1));	//��ư�� ���� �� ���ڸ� ������. 
	
	if( InStr( strID ,"ASkillHiddenBtn" ) > -1)
	{
		if (m_bExistSkill[index] == 1)		// ������ ������ �����ش�. 
		{
			m_wnd[index].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;; Height�� ���
			nScrollHeight = nScrollHeight - nWndHeight - BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
			m_NameBtn[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
			m_bExistSkill[index] = 2;
			m_wnd[index].HideWindow();	
			
			// ���� �������� ��Ŀ�� �������ش�.  (���� �ٷ� �ؿ� �ٿ���)
			if(index <Skill_GROUP_COUNT)
			{
				for(i = index + 1 ; i<Skill_GROUP_COUNT ; i++)	
				{
					if(m_bExistSkill[i]  >0)	// ���� �����찡 �������� ������ �ִ����� �Ű澲�� �ʴ´�. 
					{
						m_wndName[i].ClearAnchor();
						m_wndName[i].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ index, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}
		}
		else if(m_bExistSkill[index] == 2)		// ���������� ���ش�.
		{
			m_wnd[index].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;; Height�� ���
			nScrollHeight = nScrollHeight + nWndHeight + BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
			m_NameBtn[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
			m_bExistSkill[index] = 1;
			m_wnd[index].ShowWindow();
			
			// ���� �������� ��Ŀ�� �������ش�. 
			if(index <Skill_GROUP_COUNT)
			{
				for(i = index + 1; i<Skill_GROUP_COUNT ; i++)	
				{
					if(m_bExistSkill[i]  >0)	// ���� �����찡 �������� ������ �ִ����� �Ű澲�� �ʴ´�. 
					{
						m_wndName[i].ClearAnchor();
						m_wndName[i].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ index, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
				}
			}
		}
		areaScroll.SetScrollHeight(nScrollHeight);
		//areaScroll.SetScrollPosition( 0 );
	}
	else if( InStr( strID ,"PSkillHiddenBtn" ) > -1)
	{
		if (m_bExistSkill_p[index] == 1)		// ������ ������ �����ش�. 
		{
			m_wnd_p[index].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;; Height�� ���
			nScrollHeight_p = nScrollHeight_p - nWndHeight - BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
			m_NameBtn_p[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
			m_bExistSkill_p[index] = 2;
			m_wnd_p[index].HideWindow();	
			
			// ���� �������� ��Ŀ�� �������ش�.  (���� �ٷ� �ؿ� �ٿ���)
			if(index <Skill_GROUP_COUNT_P)
			{
				for(i = index + 1 ; i<Skill_GROUP_COUNT_P ; i++)	
				{
					if(m_bExistSkill_p[i]  >0)	// ���� �����찡 �������� ������ �ִ����� �Ű澲�� �ʴ´�. 
					{
						m_wndName_p[i].ClearAnchor();
						m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ index, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}
		}
		else if(m_bExistSkill_p[index] == 2)		// ���������� ���ش�.
		{
			m_wnd_p[index].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;; Height�� ���
			nScrollHeight_p = nScrollHeight_p + nWndHeight + BETWEEN_NAME_ITEM;	// ����� ���߱� ������ ��ũ�� ���̸� �������ش�. 
			m_NameBtn_p[index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
			m_bExistSkill_p[index] = 1;
			m_wnd_p[index].ShowWindow();
			
			// ���� �������� ��Ŀ�� �������ش�. 
			if(index <Skill_GROUP_COUNT_P)
			{
				for(i = index + 1; i<Skill_GROUP_COUNT_P ; i++)	
				{
					if(m_bExistSkill_p[i]  >0)	// ���� �����찡 �������� ������ �ִ����� �Ű澲�� �ʴ´�. 
					{
						m_wndName_p[i].ClearAnchor();
						m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ index, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
				}
			}
		}
		areaScroll_p.SetScrollHeight(nScrollHeight_p);
	}
	
	else if ( strID == "ResearchButton" ) //��ų ��æƮ ��ư Ŭ��
	{
		

		script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));

		if (Drawer.IsShowWindow())
		{
			Drawer.HideWindow();
			if (class'UIAPI_WINDOW'.static.IsShowWindow("SkillEnOpt"))
				class'UIAPI_WINDOW'.static.HideWindow("SkillEnOpt");
			script_a.HideAgathion();
			script_a.SkillInfoClear();
			RequestSkillList();
			//debug("CanEnchant"$iCnaEnchant);

			//script_a.txtMySp.SetText(MakeCostString( string(0) ));
			
		}
		else 
		{
			Drawer.ShowWindow();
			script_a.SkillInfoClear();
			script_a.txtMySp.SetText(MakeCostString( string(GetUserSP()) ));
			RequestSkillList();
			//debug("CanEnchant"$iCnaEnchant);

		}
	}
}



function HandleLanguageChanged()
{
	RequestSkillList();
}

function HandleSkillListStart()
{
	Clear();
}

function Clear()
{
	local int i;
	
	// ��ų �÷��� �ʱ�ȭ
	for(i =0; i<Skill_GROUP_COUNT ; i++)
	{
		m_bExistSkill[ i ] = 0;
		m_NameBtn[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
		m_wnd[i].HideWindow();
		m_wndName[i].HideWindow();
		m_Item[i].Clear();
	}
	
	for(i =0; i<Skill_GROUP_COUNT_P ; i++)
	{
		m_bExistSkill_p[ i ] = 0;
		m_NameBtn_p[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
		m_wnd_p[i].HideWindow();
		m_wndName_p[i].HideWindow();
		m_Item_p[i].Clear();
	}
}

function HandleSkillList(string param)
{
	local int Tmp;
	local ESkillCategory Type;
	local int SkillLevel;
	local int Lock;
	local string strIconName;
	local string strSkillName;
	local string strDescription;
	local string strEnchantName;
	local string strCommand;
	local string strIconPanel;
	local int iCanEnchant;
	
	local ItemInfo	infItem;
	
	ParseItemID(param, infItem.ID);
	ParseInt(param, "Type", Tmp);
	ParseInt(param, "Level", SkillLevel);
	ParseInt(param, "Lock", Lock);
	ParseString(param, "Name", strSkillName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "IconPanel", strIconPanel);
	ParseString(param, "Description", strDescription);
	ParseString(param, "EnchantName", strEnchantName);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "CanEnchant", iCanEnchant);
	
	//debug(" Type : " $ Tmp $ "SkillLevel : " $ SkillLevel $ " strSkillName : " $ strSkillName $ " Command : " $ strCommand);
	
	//debug("CanEnchant"$iCanEnchant);

	infItem.Level = SkillLevel;
	infItem.Name = strSkillName;
	infItem.AdditionalName = strEnchantName;
	infItem.IconName = strIconName;
	infItem.IconPanel = strIconPanel;
	infItem.Description = strDescription;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_SKILL);
	infItem.MacroCommand = strCommand;
	
	
	if (Lock>0)
	{
		infItem.bIsLock = true;
	}
	else
	{
		infItem.bIsLock = false;
	}

	infItem.Reserved = iCanEnchant;
	if(Drawer.IsShowWindow())
	{
			if (iCanEnchant>0)
			{
				infItem.bDisabled = false;

			}else
			{
				infItem.bDisabled = true;
			}
	}else
	{
				infItem.bDisabled = false;
	}
	


	//ItemWnd ADD
	Type = ESkillCategory(Tmp);
	
	GroupingSkill(infItem.ID.ClassID , SkillLevel, infItem);

	
}

function ComputeItemWndHeight()
{	
	local int i;			// for���� ������ ���� ����
	local int nItemNum;	// �ش� ������ �����쿡 ����ִ� ��ų�� ����
	local int nItemWndHeight;	// �������������� ����
	local int nWndWidth;	
	
	//---------------- ��Ƽ�� ��ų�� ���� ���
	nScrollHeight = 0;
	for (i=0 ; i<Skill_GROUP_COUNT ; i++)
	{
		nItemNum = m_Item[i].GetItemNum();
		
		if(nItemNum <1)	// ��ų�� ������
		{
			m_bExistSkill[i] = 0; //â�� �������� �ʴ´�. �ʱ�ȭ�� �������� �׷��� Ȥ�� �𸣴ϱ�!
			m_wnd[i].GetWindowSize(nWndWidth, nItemWndHeight);	
			m_wnd[i].SetWindowSize(nWndWidth, 0);
		}
		else
		{
			m_bExistSkill[i] = 1; // ������. ����� Ŭ���̺�Ʈ����
			
			nItemWndHeight = ((nItemNum - 1) / 6 + 1) * 32 + ((nItemNum - 1) / 6) * 4 + 12;	// ���Ʒ� �� + �׷�ڽ� ������ ��ġ�� 12!!
			m_wnd[i].SetWindowSize( SKILL_ITEMWND_WIDTH , nItemWndHeight);
			m_ItemBg[i].SetWindowSize( SKILL_SLOTBG_WIDTH , nItemWndHeight - 8);
			m_Item[i].SetRow((nItemNum - 1) / 6 + 2);	//??
			
			// â�� �ȶ������� ����ش�. 
			if( !m_wnd[i].IsShowWindow()) m_wnd[i].ShowWindow();
			if( !m_wndName[i] .IsShowWindow()) m_wndName[i].ShowWindow();
			
			nScrollHeight = nScrollHeight + TOP_MARGIN + NAME_WND_HEIGHT + BETWEEN_NAME_ITEM + nItemWndHeight ;	// ������Ų��
			//debug("!!!!SKill !! Height " $"   " $i $"    " $nScrollHeight $"  " $nItemWndHeight);
		}
	}
	//debug("!!!Skill!!! Height ������" $ nScrollHeight);
	if (areaScroll.IsShowWindow())
	areaScroll.SetScrollHeight(nScrollHeight);
	//debug("!!!Skill!!! Height Refresh");
	if (!areaScroll.IsShowWindow())
		areaScroll.SetScrollPosition( 0 );
	
	// ---------------�нú� ��ų�� ���� ���
	
	nScrollHeight_p = 0;
	for (i=0 ; i<Skill_GROUP_COUNT_P ; i++)
	{
		nItemNum = m_Item_p[i].GetItemNum();
		
		if(nItemNum <1)	// ��ų�� ������
		{
			m_bExistSkill_p[i] = 0; //â�� �������� �ʴ´�. �ʱ�ȭ�� �������� �׷��� Ȥ�� �𸣴ϱ�!
			m_wnd_p[i].GetWindowSize(nWndWidth, nItemWndHeight);	
			m_wnd_p[i].SetWindowSize(nWndWidth, 0);
		}
		else
		{
			m_bExistSkill_p[i] = 1; // ������. ����� Ŭ���̺�Ʈ����
			
			nItemWndHeight = ((nItemNum - 1) / 6 + 1) * 32 + ((nItemNum - 1) / 6) * 4 + 12;	// ���Ʒ� �� + �׷�ڽ� ������ ��ġ�� 12!!
			m_wnd_p[i].SetWindowSize( SKILL_ITEMWND_WIDTH , nItemWndHeight);
			m_ItemBg_p[i].SetWindowSize( SKILL_SLOTBG_WIDTH , nItemWndHeight - 8);
			m_Item_p[i].SetRow((nItemNum - 1) / 6 + 2);	//??
			
			// â�� �ȶ������� ����ش�. 
			if( !m_wnd_p[i].IsShowWindow()) m_wnd_p[i].ShowWindow();
			if( !m_wndName_p[i] .IsShowWindow()) m_wndName_p[i].ShowWindow();
			
			nScrollHeight_p = nScrollHeight_p + TOP_MARGIN + NAME_WND_HEIGHT + BETWEEN_NAME_ITEM + nItemWndHeight ;	// ������Ų��
			//debug("!!!!SKill2 !! Height " $"   " $i $"    " $nScrollHeight_p $"  " $nItemWndHeight);
		}
	}
	
	//debug("!!!Skill2!!! Height ������" $ nScrollHeight_p);
	if (areaScroll_p.IsShowWindow())
	areaScroll_p.SetScrollHeight(nScrollHeight_p);
	//debug("!!!Skill2!!! Height Refresh" );
	if (!areaScroll_p.IsShowWindow())
		areaScroll_p.SetScrollPosition( 0 );
}

function ComputeItemWndAnchor()
{	
	local int i, j;			// for���� ������ ���� ����
	local int nWndWidth, nWndHeight;	// ������ ������ �ޱ� ����
	
	//------------- ��Ƽ���� ��Ŀ ����ֱ�
	//ù��° â�� �������� ���
	if(m_bExistSkill[0] == 0) 
	{
		for (i = 1 ; i < Skill_GROUP_COUNT ; i++)
		{
			// Ȱ��ȭ ���� ù��° â�� �ٿ��ش�. 
			if(m_bExistSkill[i] > 0)
			{
				m_wndName[i].SetAnchor(m_WindowName $ ".ASkillScroll", "TopLeft", "TopLeft", 5, 4);	// ��ũ���� ����Ǵ� ������ ����
				m_wndName[i].ClearAnchor();
				break;
			}		
		}
	}
	
	// 0��°�� ������� �ʾƵ� �ȴ�. 
	for (i = 0 ; i < Skill_GROUP_COUNT ; i++)
	{
		// Ȱ��ȭ ���϶��� ��Ŀ
		if(m_bExistSkill[i] > 0)
		{
			for(j=i+1 ; j<Skill_GROUP_COUNT; j++)
			{
				if(m_bExistSkill[j] > 0)	// ���� Ȱ��ȭ�� â�� �˻� �� �ٿ��ش�.
				{
					if( m_bExistSkill[i] == 1)	// ������ �����찡 �������� ���
					{
						m_wnd[i].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;;
						m_wndName[j].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ i, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
					else if( m_bExistSkill[i] == 2)	// ������ �����찡 �������� ���
					{	
						m_wndName[j].SetAnchor(m_WindowName $ ".ASkill.ASkillName" $ i, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}			
		}		
	}
	
	//------------- �нú��� ��Ŀ ����ֱ�
	//ù��° â�� �������� ���
	if(m_bExistSkill_p[0] == 0) 
	{
		for (i = 1 ; i < Skill_GROUP_COUNT_P ; i++)
		{
			// Ȱ��ȭ ���� ù��° â�� �ٿ��ش�. 
			if(m_bExistSkill_p[i] > 0)
			{
				m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkillScroll", "TopLeft", "TopLeft", 5, 4);	// ��ũ���� ����Ǵ� ������ ����
				m_wndName_p[i].ClearAnchor();
				break;
			}		
		}
	}
	
	// 0��°�� ������� �ʾƵ� �ȴ�. 
	for (i = 0 ; i < Skill_GROUP_COUNT_P ; i++)
	{
		// Ȱ��ȭ ���϶��� ��Ŀ
		if(m_bExistSkill_p[i] > 0)
		{
			for(j=i+1 ; j<Skill_GROUP_COUNT_P; j++)
			{
				if(m_bExistSkill_p[j] > 0)	// ���� Ȱ��ȭ�� â�� �˻� �� �ٿ��ش�.
				{
					if( m_bExistSkill_p[i] == 1)	// ������ �����찡 �������� ���
					{
						m_wnd_p[i].GetWindowSize(nWndWidth, nWndHeight);	// width�� ������ -_-;;
						m_wndName_p[j].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ i, "BottomCenter", "TopCenter", 0, nWndHeight + BETWEEN_NAME_ITEM + TOP_MARGIN);
						break;
					}
					else if( m_bExistSkill_p[i] == 2)	// ������ �����찡 �������� ���
					{	
						m_wndName_p[j].SetAnchor(m_WindowName $ ".PSkill.PSkillName" $ i, "BottomCenter", "TopCenter", 0, TOP_MARGIN);
						break;
					}
				}
			}			
		}		
	}
}

// ID�� ������ ������ ���� �ش� ��ų�� ������ Ȯ�����´�.
function GroupingSkill( int  SkillID , int SkillLevel, ItemInfo infItem )
{	
	local SkillInfo info;
	local ItemInfo InfControl;
	
	// ID�� ������ ��ų�� ������ ���´�. ������ �й�
	if( !GetSkillInfo( SkillID, SkillLevel , info ) )
	{
		//debug("ERROR - no skill info!!");
		return;
	}
	
	switch ( info.IconType )
	{
		//------------------ ACTIVE
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
			m_Item[info.IconType].AddItem(infItem);
			if (infItem.Name == "Paralyze v2")
			{
				//AddSystemMessageString("Got HEAL");
				//script_tali.skill1.Clear();
				if (!script_timer.skill[0].GetItem(0, InfControl))
				{
					script_timer.skill[0].AddItem(infItem);
					LScount++; //default LScount++ //custom LScount = 1;

					//AddSystemMessageString("Got Paral + Count = "$string(LScount));
					
					switch (LScount)
					{
						case 1:
						script_timer.lstimerWndHandle.SetWindowSize( 53, 41 );
						script_timer.skill[0].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 18,4);
						script_timer.lstimerWndHandle.ShowWindow();
						break;
						case 2:
						script_timer.lstimerWndHandle.SetWindowSize( 92, 41 );
						script_timer.skill[0].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 55,4);
						break;
						case 3:
						script_timer.lstimerWndHandle.SetWindowSize( 126, 41 );
						script_timer.skill[0].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 92,4);
						break;
						case 4:
						script_timer.lstimerWndHandle.SetWindowSize( 164, 41 );
						script_timer.skill[0].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 18,4);
						script_timer.skill[1].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 55,4);
						script_timer.skill[2].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 92,4);
						script_timer.skill[3].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 129,4);
						break;
					}
				}
			} else if (infItem.Name == "Item Skill: Heal")
			{
				//AddSystemMessageString("Got Paralyze");
				//script_tali.skill1.Clear();
				if (!script_timer.skill[1].GetItem(0, InfControl))
				{
					script_timer.skill[1].AddItem(infItem);
					LScount++;
					//AddSystemMessageString("Got Paral + Count = "$string(LScount));
					
					switch (LScount)
					{
						case 1:
						script_timer.lstimerWndHandle.SetWindowSize( 53, 41 );
						script_timer.skill[1].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 18,4);
						script_timer.lstimerWndHandle.ShowWindow();
						break;
						case 2:
						script_timer.lstimerWndHandle.SetWindowSize( 92, 41 );
						script_timer.skill[1].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 55,4);
						break;
						case 3:
						script_timer.lstimerWndHandle.SetWindowSize( 126, 41 );
						script_timer.skill[1].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 92,4);
						break;
						case 4:
						script_timer.lstimerWndHandle.SetWindowSize( 164, 41 );
						script_timer.skill[0].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 18,4);
						script_timer.skill[1].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 55,4);
						script_timer.skill[2].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 92,4);
						script_timer.skill[3].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 129,4);
						break;
					}
				}
				
			} else if (infItem.Name == "Fear v2")
			{
				//AddSystemMessageString("Got Fear");
				//script_tali.skill1.Clear();
				if (!script_timer.skill[2].GetItem(0, InfControl))
				{
					script_timer.skill[2].AddItem(infItem);
					LScount++;
					//AddSystemMessageString("Got Fear + Count = "$string(LScount));
					
					switch (LScount)
					{
						case 1:
						script_timer.lstimerWndHandle.SetWindowSize( 53, 41 );
						script_timer.skill[2].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 18,4);
						script_timer.lstimerWndHandle.ShowWindow();
						break;
						case 2:
						script_timer.lstimerWndHandle.SetWindowSize( 92, 41 );
						script_timer.skill[2].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 55,4);
						break;
						case 3:
						script_timer.lstimerWndHandle.SetWindowSize( 126, 41 );
						script_timer.skill[2].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 92,4);
						break;
						case 4:
						script_timer.lstimerWndHandle.SetWindowSize( 164, 41 );
						script_timer.skill[0].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 18,4);
						script_timer.skill[1].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 55,4);
						script_timer.skill[2].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 92,4);
						script_timer.skill[3].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 129,4);
						break;
					}
				}
				
			} else if (infItem.Name == "Medusa v2")
			{
				//AddSystemMessageString("Got Medusa");
				//script_tali.skill1.Clear();
				if (!script_timer.skill[3].GetItem(0, InfControl))
				{
					script_timer.skill[3].AddItem(infItem);
					LScount++;
					//AddSystemMessageString("Got Medusa + Count = "$string(LScount));
					
					switch (LScount)
					{
						case 1:
						script_timer.lstimerWndHandle.SetWindowSize( 53, 41 );
						script_timer.skill[3].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 18,4);
						script_timer.lstimerWndHandle.ShowWindow();
						break;
						case 2:
						script_timer.lstimerWndHandle.SetWindowSize( 92, 41 );
						script_timer.skill[3].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 55,4);
						break;
						case 3:
						script_timer.lstimerWndHandle.SetWindowSize( 126, 41 );
						script_timer.skill[3].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 92,4);
						break;
						case 4:
						script_timer.lstimerWndHandle.SetWindowSize( 164, 41 );
						script_timer.skill[0].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 18,4);
						script_timer.skill[1].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 55,4);
						script_timer.skill[2].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 92,4);
						script_timer.skill[3].SetAnchor("LSTimerWnd", "TopLeft", "TopLeft", 129,4);
						break;
					}
				}
				
			}
			break;
		
		//------------------ PASSIVE
		case 11:
		case 12:
		case 13:
		case 14:
		case 15:
		case 16:
			m_Item_p[info.IconType-11].AddItem(infItem);
			break;
		default:
			break;
	}
}


//���� ��ų �˻�
function bool IsHeroSkillID(int SkillID)
{
	switch(SkillID)
	{
		case 395:
		case 396:
		case 1374:
		case 1375:
		case 1376:
			return true;
		
		default:
			return false;
	}
}

// ������ ��ų �˻�
function bool IsItemSkillID(int SkillID)
{
	switch(SkillID)
	{
		default:
			return false;
	}
}

//���� ��ų �˻�
function bool IsChangeSkillID(int SkillID)
{
	switch(SkillID)
	{
		default:
			return false;
	}
}


function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	local MagicSkillDrawerWnd script_a;
	local string dragsrcName;
	
	
	
	script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));

	dragsrcName = Left(a_ItemInfo.DragSrcName,10);
	//RequestSkillList();

	
	//debug("CanEnchant");
	switch (a_WindowID)
	{		
		case "ResearchButton":

		if (dragsrcName== "PSkillItem" || dragsrcName == "ASkillItem")
		{

				RequestSkillList();
					if ( a_ItemInfo.Reserved == 0)
					{
						script_a.SkillInfoClear();
						script_a.SetAdenaSpInfo();
						script_a.ResearchGuideDesc.SetText(GetSystemString(2041));
						script_a.AddSystemMessage(3070);//�ٲ�� ��
						
					} else
					{
						RequestExEnchantSkillInfo(a_ItemInfo.ID.ClassID, a_ItemInfo.Level); 
						script_a.SetCurSkillInfo(a_ItemInfo);
						script_a.txtMySp.SetText(MakeCostString( string(GetUserSP()) ));
					}


		}
	
		break;

	}
}

//SP ��ġ�� ǥ���Ѵ�.
function int GetuserSP()
{

	local UserInfo infoPlayer;
	local int iPlayerSP;

	GetPlayerInfo(infoPlayer);
	iPlayerSP=infoPlayer.nSP;

	return iPlayerSP;
}
defaultproperties
{
    
}
